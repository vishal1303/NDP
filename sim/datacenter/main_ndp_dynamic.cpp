// -*- c-basic-offset: 4; tab-width: 8; indent-tabs-mode: t -*-        
#include "config.h"
#include <sstream>
#include <strstream>
#include <iostream>
#include <string.h>
#include <math.h>
#include <list>
#include "network.h"
#include "randomqueue.h"
//#include "subflow_control.h"
#include "shortflows.h"
#include "pipe.h"
#include "eventlist.h"
#include "logfile.h"
#include "loggers.h"
#include "clock.h"
#include "ndp.h"
#include "compositequeue.h"
#include "firstfit.h"
#include "topology.h"
#include "connection_matrix.h"

//#include "vl2_topology.h"
//#include "fat_tree_topology.h"
#include "leaf_spine_topology.h"
//#include "oversubscribed_fat_tree_topology.h"
//#include "multihomed_fat_tree_topology.h"
//#include "star_topology.h"
//#include "bcube_topology.h"
#include <list>

// Simulation params

#define PRINT_PATHS 0

#define PERIODIC 0
#include "main.h"

double RTT;
double PER_HOP_DELAY; // this is per link delay in ns
int DEFAULT_NODES = 432;
#define DEFAULT_QUEUE_SIZE 8

FirstFit* ff = NULL;
unsigned int subflow_count = 1;

string ntoa(double n);
string itoa(uint64_t n);
void log_utilization(long long unsigned curr_time);

//#define SWITCH_BUFFER (SERVICE * PER_HOP_DELAY / 1000)
#define USE_FIRST_FIT 0
#define FIRST_FIT_INTERVAL 100

EventList eventlist;

Logfile* lg;

void exit_error(char* progr) {
    cout << "Usage " << progr << " [UNCOUPLED(DEFAULT)|COUPLED_INC|FULLY_COUPLED|COUPLED_EPSILON] [epsilon][COUPLED_SCALABLE_TCP" << endl;
    exit(1);
}

void print_path(std::ofstream &paths,const Route* rt){
    for (unsigned int i=0;i<rt->size();i+=1){
	RandomQueue* q = (RandomQueue*)rt->at(i);
	if (q!=NULL)
	    paths << q->str() << " ";
	else 
	    paths << "NULL ";
    }

    paths<<endl;
}

int main(int argc, char **argv) {
    double endtime = 24*60*60; //in seconds
    int num_of_flows_to_finish = 1000000;
    int num_of_flows_to_start = 1000000;
    Clock c(timeFromSec(5 / 100.), eventlist);
    int no_of_conns = 0, cwnd = 5, no_of_nodes = DEFAULT_NODES,
        pktsize=1500, queuesize=8;
    uint64_t flowsize=pktsize*50;
    stringstream filename(ios_base::out);
    RouteStrategy route_strategy = NOT_SET;
    char inp_filename[5000];

    int i = 1;
    filename << "logout.dat";

    while (i<argc) {
	if (!strcmp(argv[i],"-o")) {
	    filename.str(std::string());
	    filename << argv[i+1];
	    i++;
    } else if (!strcmp(argv[i],"-i")){
        strcpy(inp_filename, argv[i+1]);
        cout << "input file: " << inp_filename << endl;
	    i++;
	} else if (!strcmp(argv[i],"-sub")) {
	    subflow_count = atoi(argv[i+1]);
	    i++;
	} else if (!strcmp(argv[i],"-conns")) {
	    no_of_conns = atoi(argv[i+1]);
	    cout << "no_of_conns "<<no_of_conns << endl;
	    i++;
	} else if (!strcmp(argv[i],"-nodes")) {
	    no_of_nodes = atoi(argv[i+1]);
	    cout << "no_of_nodes "<<no_of_nodes << endl;
	    i++;
	} else if (!strcmp(argv[i],"-cwnd")) {
	    cwnd = atoi(argv[i+1]);
	    cout << "cwnd "<< cwnd << endl;
	    i++;
	} else if (!strcmp(argv[i],"-flowsize")){
            flowsize = atol(argv[i+1]);
            cout << "flowsize "<< flowsize << endl;
            i++;
	} else if (!strcmp(argv[i],"-pktsize")){
            pktsize = atoi(argv[i+1]);
            cout << "pktsize "<< pktsize << endl;
            i++;
	} else if (!strcmp(argv[i],"-queuesize")){
            queuesize = atoi(argv[i+1]);
            cout << "queuesize "<< queuesize << endl;
            i++;
	} else if (!strcmp(argv[i],"-endtime")){
            endtime = atof(argv[i+1]);
            cout << "endtime "<< endtime << endl;
            i++;
	} else if (!strcmp(argv[i],"-numflowsfinish")){
            num_of_flows_to_finish = atoi(argv[i+1]);
            cout << "finish after "<< num_of_flows_to_finish << " flows have finished"<<endl;
            i++;
	} else if (!strcmp(argv[i],"-numflowsstart")){
            num_of_flows_to_start = atoi(argv[i+1]);
            cout << "finish after "<< num_of_flows_to_start << " flows have started"<<endl;
            i++;
	} else if (!strcmp(argv[i],"-delay")){
            PER_HOP_DELAY = atof(argv[i+1]);
            cout << "Per hop delay "<< PER_HOP_DELAY <<endl;
            i++;
	} else if (!strcmp(argv[i],"-strat")){
	    if (!strcmp(argv[i+1], "perm")) {
		route_strategy = SCATTER_PERMUTE;
	    } else if (!strcmp(argv[i+1], "rand")) {
		route_strategy = SCATTER_RANDOM;
	    } else if (!strcmp(argv[i+1], "pull")) {
		route_strategy = PULL_BASED;
	    } else if (!strcmp(argv[i+1], "single")) {
		route_strategy = SINGLE_PATH;
	    }
	    i++;
	} else
	    exit_error(argv[0]);
	
	i++;
    }
    srand(time(NULL));
      
    if (route_strategy == NOT_SET) {
	fprintf(stderr, "Route Strategy not set.  Use the -strat param.  \nValid values are perm, rand, pull, rg and single\n");
	exit(1);
    }

    eventlist.setEndtime(timeFromSec(endtime));

    cout << "Using subflow count " << subflow_count <<endl;

    Packet::set_packet_size(pktsize);

    // prepare the loggers

    cout << "Logging to " << filename.str() << endl;
    //Logfile 
    Logfile logfile(filename.str(), eventlist);

#if PRINT_PATHS
    filename << ".paths";
    cout << "Logging path choices to " << filename.str() << endl;
    std::ofstream paths(filename.str().c_str());
    if (!paths){
	cout << "Can't open for writing paths file!"<<endl;
	exit(1);
    }
#endif


    int tot_subs = 0;
    int cnt_con = 0;

    lg = &logfile;

    logfile.setStartTime(timeFromSec(0));

    NdpSinkLoggerSampling sinkLogger = NdpSinkLoggerSampling(timeFromMs(10), eventlist);
    logfile.addLogger(sinkLogger);
    //NdpTrafficLogger traffic_logger = NdpTrafficLogger();
    //logfile.addLogger(traffic_logger);
    NdpSrc::setMinRTO(1000); //increase RTO to avoid spurious retransmits
    NdpSrc::setRouteStrategy(route_strategy);
    NdpSink::setRouteStrategy(route_strategy);

    NdpSrc* ndpSrc;
    NdpSink* ndpSnk;

    Route* routeout, *routein;
    double extrastarttime;

    // scanner interval must be less than min RTO
    NdpRtxTimerScanner ndpRtxScanner(timeFromUs((uint32_t)1000), eventlist);
   
#if USE_FIRST_FIT
    if (subflow_count==1){
	ff = new FirstFit(timeFromMs(FIRST_FIT_INTERVAL),eventlist);
    }
#endif

#ifdef FAT_TREE
    FatTreeTopology* top = new FatTreeTopology(no_of_nodes, memFromPkt(queuesize),
            &logfile,&eventlist,ff,COMPOSITE,0);
#endif

#ifdef OV_FAT_TREE
    OversubscribedFatTreeTopology* top = new OversubscribedFatTreeTopology(&logfile, &eventlist,ff);
#endif

#ifdef MH_FAT_TREE
    MultihomedFatTreeTopology* top = new MultihomedFatTreeTopology(&logfile, &eventlist,ff);
#endif

#ifdef STAR
    StarTopology* top = new StarTopology(&logfile, &eventlist,ff);
#endif

#ifdef BCUBE
    BCubeTopology* top = new BCubeTopology(&logfile,&eventlist,ff);
    cout << "BCUBE " << K << endl;
#endif

#ifdef VL2
    VL2Topology* top = new VL2Topology(&logfile,&eventlist,ff);
#endif

#ifdef LEAF_SPINE
    LeafSpineTopology* top = new LeafSpineTopology(memFromPkt(queuesize),
            &logfile, &eventlist, ff, COMPOSITE, PER_HOP_DELAY);
#endif

    vector<const Route*>*** net_paths;
    net_paths = new vector<const Route*>**[no_of_nodes];

    int* is_dest = new int[no_of_nodes];
    
    for (int i=0;i<no_of_nodes;i++){
	is_dest[i] = 0;
	net_paths[i] = new vector<const Route*>*[no_of_nodes];
	for (int j = 0;j<no_of_nodes;j++)
	    net_paths[i][j] = NULL;
    }
    
#ifdef USE_FIRST_FIT
    if (ff)
	ff->net_paths = net_paths;
#endif
    

    //ConnectionMatrix* conns = new ConnectionMatrix(no_of_nodes);
    //conns->setLocalTraffic(top);

    
    //cout << "Running perm with " << no_of_conns << " connections" << endl;
    //conns->setPermutation(no_of_conns);
    //cout << "Running incast with " << no_of_conns << " connections" << endl;
    //conns->setIncast(no_of_conns, no_of_nodes-no_of_conns);
    //conns->setStride(no_of_conns);
    //conns->setStaggeredPermutation(top,(double)no_of_conns/100.0);
    //conns->setStaggeredRandom(top,512,1);
    //conns->setHotspot(no_of_conns,512/no_of_conns);
    //conns->setManytoMany(128);

    //conns->setVL2();

    //conns->setRandom(no_of_conns);

    NdpPullPacer* pacer[no_of_nodes];
    for (int i = 0; i < no_of_nodes; ++i) {
        pacer[i] = new NdpPullPacer(eventlist,  1 /*pull at line rate*/);   
        //NdpPullPacer* pacer = new NdpPullPacer(eventlist, "/Users/localadmin/poli/new-datacenter-protocol/data/1500.recv.cdf.pretty");   
    }

    // used just to print out stats data at the end
    list <const Route*> routes;
    list <NdpSrc*> srcs;

    string line, id, src_string, dest_string, flowsize_string, starttime_string;
    ifstream input_file(inp_filename);
    int connID = 0;

    while (getline(input_file, line)) {
        if (connID == 2000000) break;
        stringstream iss(line);
        getline(iss, id, ',');
        getline(iss, src_string, ',');
        getline(iss, dest_string, ',');
        getline(iss, flowsize_string, ',');
        getline(iss, starttime_string, '\n');

        int src = atoi(src_string.c_str());
        int dest = atoi(dest_string.c_str());
        flowsize = atol(flowsize_string.c_str());
        double starttime;
        sscanf(starttime_string.c_str(), "%lf", &starttime);

        vector<int> subflows_chosen;

        NdpSrc::setRouteStrategy(SCATTER_PERMUTE);
        NdpSink::setRouteStrategy(SCATTER_PERMUTE);

        for (unsigned int dst_id = 0;dst_id<1;dst_id++){
            if (!net_paths[src][dest]) {
                vector<const Route*>* paths = top->get_paths(src,dest);
                net_paths[src][dest] = paths;
                for (unsigned int i = 0; i < paths->size(); i++) {
                    routes.push_back((*paths)[i]);
                }
            }
            if (!net_paths[dest][src]) {
                vector<const Route*>* paths = top->get_paths(dest,src);
                net_paths[dest][src] = paths;
            }

            for (int connection=0;connection<1;connection++){
                subflows_chosen.clear();

                int it_sub;
                int crt_subflow_count = subflow_count;
                tot_subs += crt_subflow_count;
                cnt_con ++;

                it_sub = crt_subflow_count > net_paths[src][dest]->size()?net_paths[src][dest]->size():crt_subflow_count;

		        //if (connID%10!=0)
		        //it_sub = 1;

		        ndpSrc = new NdpSrc(NULL, NULL, eventlist);
		        //srcs.push_back(ndpSrc);
		        ndpSrc->setCwnd(cwnd*Packet::data_packet_size());
		        ndpSrc->set_flowsize(flowsize);
		        ndpSnk = new NdpSink(pacer[dest]);
		        //ndpSnk = new NdpSink(eventlist, 1 /*pull at line rate*/);
		        //if (connID == no_of_conns-1)
		        //    ndpSrc->log_me();

		        ndpSrc->setName("ndp_" + itoa(src) + "_" + itoa(dest)+"_"+itoa(connID));
		        logfile.writeName(*ndpSrc);

		        ndpSnk->setName("ndp_sink_" + itoa(src) + "_" + itoa(dest)+ "_"+itoa(connID));
                logfile.writeName(*ndpSnk);

                connID++;

                if (connID % 100000 ==0)
                    cout << connID << " flows read from the tracefile" << endl;

                ndpRtxScanner.registerNdp(*ndpSrc);

		        int choice = 0;

#ifdef FAT_TREE
                choice = rand()%net_paths[src][dest]->size();
#endif

#ifdef LEAF_SPINE
                choice = rand()%net_paths[src][dest]->size();
#endif
	  
#ifdef OV_FAT_TREE
                choice = rand()%net_paths[src][dest]->size();
#endif
	  
#ifdef MH_FAT_TREE
                int use_all = it_sub==net_paths[src][dest]->size();

                if (use_all)
                    choice = inter;
                else
                    choice = rand()%net_paths[src][dest]->size();
#endif
	  
#ifdef VL2
                choice = rand()%net_paths[src][dest]->size();
#endif
	  
#ifdef STAR
                choice = 0;
#endif
	  
#ifdef BCUBE
                //choice = inter;
	  
                int min = -1, max = -1,minDist = 1000,maxDist = 0;
                if (subflow_count==1){
                    //find shortest and longest path 
                    for (int dd=0;dd<net_paths[src][dest]->size();dd++){
                        if (net_paths[src][dest]->at(dd)->size()<minDist){
                            minDist = net_paths[src][dest]->at(dd)->size();
                            min = dd;
                        }
                        if (net_paths[src][dest]->at(dd)->size()>maxDist){
                            maxDist = net_paths[src][dest]->at(dd)->size();
                            max = dd;
                        }
                    }
                    choice = min;
                } 
                else
                    choice = rand()%net_paths[src][dest]->size();
#endif
                //cout << "Choice "<<choice<<" out of "<<net_paths[src][dest]->size();
                subflows_chosen.push_back(choice);
	  
                /*if (net_paths[src][dest]->size()==K*K/4 && it_sub<=K/2){
                  int choice2 = rand()%(K/2);*/
	  
                if (choice>=net_paths[src][dest]->size()){
                    printf("Weird path choice %d out of %lu\n",choice,net_paths[src][dest]->size());
                    exit(1);
                }

#if PRINT_PATHS
                for (int ll=0;ll<net_paths[src][dest]->size();ll++){
                    paths << "Route from "<< ntoa(src) << " to " << ntoa(dest) << "  (" << ll << ") -> " ;
                    print_path(paths,net_paths[src][dest]->at(ll));
                }
		/*				if (src>=12){
						assert(net_paths[src][dest]->size()>1);
						net_paths[src][dest]->erase(net_paths[src][dest]->begin());
						paths << "Killing entry!" << endl;
				  
						if (choice>=net_paths[src][dest]->size())
						choice = 0;
						}*/
#endif
	  
                routeout = new Route(*(net_paths[src][dest]->at(choice)));
                routeout->add_endpoints(ndpSrc, ndpSnk);
	  
                routein = new Route(*top->get_paths(dest,src)->at(choice));
                routein->add_endpoints(ndpSnk, ndpSrc);

                extrastarttime = starttime*1000; //drand()
	  
                ndpSrc->connect(*routeout, *routein, *ndpSnk, timeFromMs(extrastarttime));

                //if (connID==1){
                //  pacer->set_preferred_flow(ndpSrc->flow_id());
                //}
		
	  
#ifdef NDP_PACKET_SCATTER
                ndpSrc->set_paths(net_paths[src][dest]);
                ndpSnk->set_paths(net_paths[dest][src]);

                //ndpSrc->set_traffic_logger(&traffic_logger);
#endif
                sinkLogger.monitorSink(ndpSnk);

            }
        }
    }

    cout << "Mean number of subflows " << ntoa((double)tot_subs/cnt_con)<<endl;

    // Record the setup
    pktsize = Packet::data_packet_size();
    logfile.write("# pktsize=" + ntoa(pktsize) + " bytes");
    logfile.write("# subflows=" + ntoa(subflow_count));
    logfile.write("# hostnicrate = " + ntoa(HOST_NIC) + " pkt/sec");
    logfile.write("# corelinkrate = " + ntoa(HOST_NIC*CORE_TO_HOST) + " pkt/sec");
    double rtt = timeAsSec(timeFromNs(PER_HOP_DELAY));
    logfile.write("# rtt =" + ntoa(rtt));

    // GO!
    long cntr = 100; //log every 100us
    while (eventlist.doNextEvent()) {
        long long unsigned curr_time = eventlist.now();
        if (curr_time/1000000 >= cntr) {
            cntr = cntr + 100;
            log_utilization(curr_time);
        }

        if (eventlist.getNumOfFlowsFinished() >= num_of_flows_to_finish
        || eventlist.getNumOfFlowsStarted() >= num_of_flows_to_start) {
            log_utilization(curr_time);
            break;
        }
    }

    cout << "Done" << endl;

    list <const Route*>::iterator rt_i;
    int counts[10]; int hop;
    for (int i = 0; i < 10; i++)
	counts[i] = 0;
    for (rt_i = routes.begin(); rt_i != routes.end(); rt_i++) {
	const Route* r = (*rt_i);
#ifdef PRINTPATHS
	cout << "Path:" << endl;
#endif
	hop = 0;
	for (int i = 0; i < r->size(); i++) {
	    PacketSink *ps = r->at(i); 
	    CompositeQueue *q = dynamic_cast<CompositeQueue*>(ps);
	    if (q == 0) {
#ifdef PRINTPATHS
		cout << ps->nodename() << endl;
#endif
	    } else {
#ifdef PRINTPATHS
		cout << q->nodename() << " id=" << q->id << " " << q->num_packets() << "pkts " 
		     << q->num_headers() << "hdrs " << q->num_acks() << "acks " << q->num_nacks() << "nacks " << q->num_stripped() << "stripped"
		     << endl;
#endif
		counts[hop] += q->num_stripped();
		hop++;
	    }
	} 
#ifdef PRINTPATHS
	cout << endl;
#endif
    }
    for (int i = 0; i < 10; i++)
	cout << "Hop " << i << " Count " << counts[i] << endl;
    list<NdpSrc*>::iterator src_i;
    int src_count=0, total_new=0, total_acked=0, total_nacked=0, total_bounced=0, total_rtx=0;
    for (src_i = srcs.begin(); src_i != srcs.end(); src_i++) {
	NdpSrc* s = (*src_i);
	src_count++;
	total_new += s->_new_packets_sent;
	total_acked += s->_acks_received;
	total_nacked += s->_nacks_received;
	total_bounced += s->_bounces_received;
	total_rtx += s->_rtx_packets_sent;
    }
    cout << "Srcs: " << src_count << " New: " << total_new << " Acks: " << total_acked
	 << " Nacks: " << total_nacked << " Bounced: " << total_bounced
	 << " RTX: " << total_bounced << endl;
}

string ntoa(double n) {
    stringstream s;
    s << n;
    return s.str();
}

string itoa(uint64_t n) {
    stringstream s;
    s << n;
    return s.str();
}

void log_utilization(long long unsigned curr_time) {
    double utilization = ((double)eventlist.getNumOfBitsReceived() / (double)eventlist.getNumOfBitsStarted()) * 100.0;
    printf("******************************* t = %llu us bits recvd = %ld bits started = %ld utilization = %lf utilization = %lf\n",
            curr_time/1000000, eventlist.getNumOfBitsReceived(), eventlist.getNumOfBitsStarted(), utilization,
            (eventlist.getNumOfBitsReceived()/(eventlist.now()/10000.0))/1);
}
