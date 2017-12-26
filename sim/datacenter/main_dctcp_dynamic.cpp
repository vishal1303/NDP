// -*- c-basic-offset: 4; tab-width: 8; indent-tabs-mode: t -*-        

#include "config.h"
#include <sstream>
#include <strstream>
#include <iostream>
#include <string.h>
#include <math.h>
#include "network.h"
#include "randomqueue.h"
//#include "subflow_control.h"
#include "shortflows.h"
#include "pipe.h"
#include "eventlist.h"
#include "logfile.h"
#include "loggers.h"
#include "clock.h"
#include "tcp.h"
#include "compositequeue.h"
#include "firstfit.h"
#include "topology.h"
#include "connection_matrix.h"
#include "dctcp.h"
//#include "vl2_topology.h"

#include "fat_tree_topology.h"
//#include "oversubscribed_fat_tree_topology.h"
//#include "multihomed_fat_tree_topology.h"
//#include "star_topology.h"
//#include "bcube_topology.h"
#include <list>

// Simulation params

#define PRINT_PATHS 0

#define PERIODIC 0
#include "main.h"

//int RTT = 10; // this is per link delay; identical RTT microseconds = 0.02 ms
uint32_t RTT = 1; // this is per link delay in us; identical RTT microseconds = 0.001 ms
int DEFAULT_NODES = 432;

FirstFit* ff = NULL;
unsigned int subflow_count = 1;

string ntoa(double n);
string itoa(uint64_t n);

//#define SWITCH_BUFFER (SERVICE * RTT / 1000)
#define USE_FIRST_FIT 0
#define FIRST_FIT_INTERVAL 100

EventList eventlist;

Logfile* lg;

void exit_error(char* progr) {
    cout << "Usage " << progr << " See source file for available flags." << endl;
    exit(1);
}

void print_path(std::ofstream &paths, const Route* rt){
    for (unsigned int i=1;i<rt->size()-1;i+=2){
	RandomQueue* q = (RandomQueue*)rt->at(i);
	if (q!=NULL)
	    paths << q->str() << " ";
	else 
	    paths << "NULL ";
    }

    paths<<endl;
}

class StopLogger : public EventSource {
public:
    StopLogger(EventList& eventlist, const string& name) : EventSource(eventlist, name) {};
    void doNextEvent() {
	//nothing to do, just prevent flow restarting
    }
private:
};

int main(int argc, char **argv) {
    eventlist.setEndtime(timeFromSec(2));
    Clock c(timeFromSec(5 / 100.), eventlist);
    int no_of_conns = 0, no_of_nodes = DEFAULT_NODES, cwnd = 15,
	pktsize=1500, flowsize=pktsize*50, queuesize=8;
    stringstream filename(ios_base::out);
    char inp_filename[5000];

    int i = 1;
    filename << "logout.dat";

    while (i<argc) {
	if (!strcmp(argv[i],"-o")){
	    filename.str(std::string());
	    filename << argv[i+1];
	    i++;
    } else if (!strcmp(argv[i],"-i")){
        strcpy(inp_filename, argv[i+1]);
	    i++;
	} else if (!strcmp(argv[i],"-sub")){
	    subflow_count = atoi(argv[i+1]);
	    i++;
	} else if (!strcmp(argv[i],"-conns")){
	    no_of_conns = atoi(argv[i+1]);
	    cout << "no_of_conns "<<no_of_conns << endl;
	    i++;
	} else if (!strcmp(argv[i],"-nodes")){
	    no_of_nodes = atoi(argv[i+1]);
	    cout << "no_of_nodes "<<no_of_nodes << endl;
	    i++;
	} else if (!strcmp(argv[i],"-cwnd")) {
	    cwnd = atoi(argv[i+1]);
	    cout << "cwnd "<< cwnd << endl;
	    i++;
	} else if (!strcmp(argv[i],"-flowsize")){
            flowsize = atoi(argv[i+1]);
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
	} else
	    exit_error(argv[0]);

	i++;
    }
    srand(13);
      
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

    TcpSinkLoggerSampling sinkLogger = TcpSinkLoggerSampling(timeFromMs(10), eventlist);
    logfile.addLogger(sinkLogger);
    TcpTrafficLogger traffic_logger = TcpTrafficLogger();
    logfile.addLogger(traffic_logger);
    
    TcpSrc* tcpSrc;
    TcpSink* tcpSnk;
    StopLogger stop_logger = StopLogger(eventlist, "stoplogger");

    Route* routeout, *routein;
    double extrastarttime;

    TcpRtxTimerScanner tcpRtxScanner(timeFromMs(1), eventlist);
   

#if USE_FIRST_FIT
    if (subflow_count==1){
	ff = new FirstFit(timeFromMs(FIRST_FIT_INTERVAL),eventlist);
    }
#endif

#ifdef FAT_TREE
    FatTreeTopology* top = new FatTreeTopology(no_of_nodes, memFromPkt(queuesize), &logfile, 
					       &eventlist,ff,ECN,0);
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
    //conns->setIncast(no_of_conns, no_of_nodes-no_of_conns);
    //conns->setStride(no_of_conns);
    //conns->setStaggeredPermutation(top,(double)no_of_conns/100.0);
    //conns->setStaggeredRandom(top,512,1);
    //conns->setHotspot(no_of_conns,512/no_of_conns);
    //conns->setManytoMany(128);

    //cout << "Running all to all with " << no_of_conns << " nodes" << endl;
    //conns->setAlltoAll(no_of_conns);
    //cout << "Running bi-incast with " << no_of_conns << " connections" << endl;
    //conns->setBidirectionalIncast(no_of_conns);
    //cout << "Running disaggregated workload with " << no_of_conns << " degree" << endl;
    //conns->setResourceFlows(no_of_conns,0,0);

    //conns->setVL2();

    //conns->setRandom(no_of_conns);

    // used just to print out stats data at the end
    list <const Route*> routes;

    string line, id, src_string, dest_string, flowsize_string, starttime_string;
    ifstream input_file(inp_filename);
    int connID = 0;

    while (getline(input_file, line)) {
        stringstream iss(line);
        getline(iss, id, ",");
        getline(iss, src_string, ",");
        getline(iss, dest_string, ",");
        getline(iss, flowsize_string, ",");
        getline(iss, starttime_string, "\n");

        int src = atoi(src_string);
        int dest = atoi(dest_string);
        flowsize = atoi(flowsize_string);
        double starttime;
        sscanf(starttime_string, "%lf", starttime);

        vector<int> subflows_chosen;

        for (unsigned int dst_id = 0;dst_id<1;dst_id++){
            cout << "From " << src << " to " <<dest << endl;
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

                tcpSrc = new DCTCPSrc(NULL, &traffic_logger, eventlist);
                tcpSnk = new TcpSink();

                tcpSrc->set_ssthresh(cwnd*Packet::data_packet_size());
                tcpSrc->set_flowsize(flowsize);

                tcpSrc->_rto = timeFromMs(10);
                tcpSrc->setName("tcp_" + ntoa(src) + "_" + ntoa(dest)+"("+ntoa(connID)+")");
                logfile.writeName(*tcpSrc);

                tcpSnk->setName("tcp_sink_" + ntoa(src) + "_" + ntoa(dest)+ "("+ntoa(connID)+")");
                logfile.writeName(*tcpSnk);

                connID++;

                tcpRtxScanner.registerTcp(*tcpSrc);

                int choice = 0;

#ifdef FAT_TREE
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
#endif

                routeout = new Route(*(net_paths[src][dest]->at(choice)));
                routeout->push_back(tcpSnk);
                routein = new Route();

                routein = new Route(*top->get_paths(dest,src)->at(choice));
                routein->push_back(tcpSrc);

                extrastarttime = starttime*1000; //drand();

                tcpSrc->connect(*routeout, *routein, *tcpSnk, timeFromMs(extrastarttime));

#ifdef PACKET_SCATTER
                tcpSrc->set_paths(net_paths[src][dest]);
                tcpSnk->set_paths(net_paths[dest][src]);

                cout << "Using PACKET SCATTER!!!!"<<endl;
#endif

                //if (ff)
                //    ff->add_flow(src,dest,tcpSrc);

                sinkLogger.monitorSink(tcpSnk);
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
    //logfile.write("# buffer = " + ntoa((double) (queues_na_ni[0][1]->_maxsize) / ((double) pktsize)) + " pkt");
    double rtt = timeAsSec(timeFromUs(RTT));
    logfile.write("# rtt =" + ntoa(rtt));

    // GO!
    while (eventlist.doNextEvent()) {
    }

    cout << "Done" << endl;
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
