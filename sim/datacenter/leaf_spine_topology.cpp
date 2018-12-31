// -*- c-basic-offset: 4; tab-width: 8; indent-tabs-mode: t -*-
#include "leaf_spine_topology.h"
#include <vector>
#include "string.h"
#include <sstream>
#include <strstream>
#include <iostream>
#include "main.h"
#include "queue.h"
#include "switch.h"
#include "compositequeue.h"
#include "prioqueue.h"
#include "queue_lossless.h"
#include "queue_lossless_input.h"
#include "queue_lossless_output.h"
#include "ecnqueue.h"

extern uint32_t RTT;

string ntoa(double n);
string itoa(uint64_t n);

LeafSpineTopology::LeafSpineTopology(mem_b queuesize, Logfile* lg, 
				 EventList* ev,FirstFit * fit,queue_type q){
    _queuesize = queuesize;
    logfile = lg;
    eventlist = ev;
    ff = fit;
    qt = q;

    set_params();

    init_network();
}

void LeafSpineTopology::set_params() {
    NLP = 9; //9 leaf
    NUP = 4; //4 spine
    LP_SRV_K = 16; //16 nodes per rack
    NSRV = NLP * LP_SRV_K; //144 nodes

    switches_lp.resize(NLP,NULL);
    switches_up.resize(NUP,NULL);

    pipes_nup_nlp.resize(NUP, vector<Pipe*>(NLP));
    pipes_nlp_ns.resize(NLP, vector<Pipe*>(NSRV));
    queues_nup_nlp.resize(NUP, vector<Queue*>(NLP));
    queues_nlp_ns.resize(NLP, vector<Queue*>(NSRV));

    pipes_nlp_nup.resize(NLP, vector<Pipe*>(NUP));
    pipes_ns_nlp.resize(NSRV, vector<Pipe*>(NLP));
    queues_nlp_nup.resize(NLP, vector<Queue*>(NUP));
    queues_ns_nlp.resize(NSRV, vector<Queue*>(NLP));
}

Queue* LeafSpineTopology::alloc_src_queue(QueueLogger* queueLogger){
    return  new PriorityQueue(speedFromMbps((uint64_t)HOST_NIC), memFromPkt(FEEDER_BUFFER), *eventlist, queueLogger);
}

Queue* LeafSpineTopology::alloc_queue(QueueLogger* queueLogger, mem_b queuesize){
    return alloc_queue(queueLogger, HOST_NIC, queuesize);
}

Queue* LeafSpineTopology::alloc_queue(QueueLogger* queueLogger, uint64_t speed, mem_b queuesize){
    if (qt==RANDOM)
	//return new RandomQueue(speedFromMbps(speed), memFromPkt(SWITCH_BUFFER + RANDOM_BUFFER), *eventlist, queueLogger, memFromPkt(RANDOM_BUFFER));
	return new RandomQueue(speedFromMbps(speed), queuesize, *eventlist, queueLogger, memFromPkt(RANDOM_BUFFER));
    else if (qt==COMPOSITE)
	return new CompositeQueue(speedFromMbps(speed), queuesize, *eventlist, queueLogger);
    else if (qt==CTRL_PRIO)
	return new CtrlPrioQueue(speedFromMbps(speed), queuesize, *eventlist, queueLogger);
    else if (qt==ECN)
	//return new ECNQueue(speedFromMbps(speed), memFromPkt(2*SWITCH_BUFFER), *eventlist, queueLogger, memFromPkt(15));
	return new ECNQueue(speedFromMbps(speed), queuesize, *eventlist, queueLogger, memFromPkt(15));
    else if (qt==LOSSLESS)
	return new LosslessQueue(speedFromMbps(speed), memFromPkt(50), *eventlist, queueLogger, NULL);
    else if (qt==LOSSLESS_INPUT)
	return new LosslessOutputQueue(speedFromMbps(speed), memFromPkt(200), *eventlist, queueLogger);
    else if (qt==LOSSLESS_INPUT_ECN)
	return new LosslessOutputQueue(speedFromMbps(speed), memFromPkt(10000), *eventlist, queueLogger,1,memFromPkt(16));
    assert(0);
}

void LeafSpineTopology::init_network(){
  QueueLoggerSampling* queueLogger;

  for (int j=0;j<NUP;j++)
    for (int k=0;k<NLP;k++){
      queues_nup_nlp[j][k] = NULL;
      pipes_nup_nlp[j][k] = NULL;
      queues_nlp_nup[k][j] = NULL;
      pipes_nlp_nup[k][j] = NULL;
  }

  for (int j=0;j<NLP;j++)
    for (int k=0;k<NSRV;k++){
      queues_nlp_ns[j][k] = NULL;
      pipes_nlp_ns[j][k] = NULL;
      queues_ns_nlp[k][j] = NULL;
      pipes_ns_nlp[k][j] = NULL;
  }

  //create switches if we have lossless operation
  if (qt==LOSSLESS) {
      for (int j=0;j<NUP;j++) {
          switches_up[j] = new Switch("Switch_UpperPod_"+ntoa(j));
      }
      for (int j=0;j<NLP;j++) {
          switches_lp[j] = new Switch("Switch_LowerPod_"+ntoa(j));
      }
  }

  // links from lower layer pod switch to server
  for (int j = 0; j < NLP; j++) {
      for (int l = 0; l < LP_SRV_K; l++) {
          int k = j * LP_SRV_K + l;
          // Downlink
          queueLogger = new QueueLoggerSampling(timeFromMs(1000), *eventlist);
          logfile->addLogger(*queueLogger);

          queues_nlp_ns[j][k] = alloc_queue(queueLogger, _queuesize);
          queues_nlp_ns[j][k]->setName("LP" + ntoa(j) + "->DST" +ntoa(k));
          logfile->writeName(*(queues_nlp_ns[j][k]));

          pipes_nlp_ns[j][k] = new Pipe(timeFromUs(RTT), *eventlist);
          pipes_nlp_ns[j][k]->setName("Pipe-LP" + ntoa(j)  + "->DST" + ntoa(k));
          logfile->writeName(*(pipes_nlp_ns[j][k]));

          // Uplink
          queueLogger = new QueueLoggerSampling(timeFromMs(1000), *eventlist);
          logfile->addLogger(*queueLogger);
          queues_ns_nlp[k][j] = alloc_src_queue(queueLogger);
          queues_ns_nlp[k][j]->setName("SRC" + ntoa(k) + "->LP" +ntoa(j));
          logfile->writeName(*(queues_ns_nlp[k][j]));

          if (qt==LOSSLESS) {
              switches_lp[j]->addPort(queues_nlp_ns[j][k]);
              ((LosslessQueue*)queues_nlp_ns[j][k])->setRemoteEndpoint(queues_ns_nlp[k][j]);
          } else if (qt==LOSSLESS_INPUT || qt == LOSSLESS_INPUT_ECN) {
              //no virtual queue needed at server
              new LosslessInputQueue(*eventlist,queues_ns_nlp[k][j]);
          }

          pipes_ns_nlp[k][j] = new Pipe(timeFromUs(RTT), *eventlist);
          pipes_ns_nlp[k][j]->setName("Pipe-SRC" + ntoa(k) + "->LP" + ntoa(j));
          logfile->writeName(*(pipes_ns_nlp[k][j]));

          if (ff) {
            ff->add_queue(queues_nlp_ns[j][k]);
            ff->add_queue(queues_ns_nlp[k][j]);
          }
      }
  }

  //Lower layer in pod to upper layer in pod!
  for (int j = 0; j < NLP; j++) {
      for (int k=0; k<NUP;k++){
        // Downlink
        queueLogger = new QueueLoggerSampling(timeFromMs(1000), *eventlist);
        logfile->addLogger(*queueLogger);
        queues_nup_nlp[k][j] = alloc_queue(queueLogger, (CORE_TO_HOST*HOST_NIC), _queuesize);
        queues_nup_nlp[k][j]->setName("UP" + ntoa(k) + "->LP_" + ntoa(j));
        logfile->writeName(*(queues_nup_nlp[k][j]));

        pipes_nup_nlp[k][j] = new Pipe(timeFromUs(RTT), *eventlist);
        pipes_nup_nlp[k][j]->setName("Pipe-UP" + ntoa(k) + "->LP" + ntoa(j));
        logfile->writeName(*(pipes_nup_nlp[k][j]));

        // Uplink
        queueLogger = new QueueLoggerSampling(timeFromMs(1000), *eventlist);
        logfile->addLogger(*queueLogger);
        queues_nlp_nup[j][k] = alloc_queue(queueLogger, (CORE_TO_HOST*HOST_NIC), _queuesize);
        queues_nlp_nup[j][k]->setName("LP" + ntoa(j) + "->UP" + ntoa(k));
        logfile->writeName(*(queues_nlp_nup[j][k]));

        if (qt==LOSSLESS){
            switches_lp[j]->addPort(queues_nlp_nup[j][k]);
            ((LosslessQueue*)queues_nlp_nup[j][k])->setRemoteEndpoint(queues_nup_nlp[k][j]);
            switches_up[k]->addPort(queues_nup_nlp[k][j]);
            ((LosslessQueue*)queues_nup_nlp[k][j])->setRemoteEndpoint(queues_nlp_nup[j][k]);
        } else if (qt==LOSSLESS_INPUT || qt == LOSSLESS_INPUT_ECN){
            new LosslessInputQueue(*eventlist, queues_nlp_nup[j][k]);
            new LosslessInputQueue(*eventlist, queues_nup_nlp[k][j]);
        }

        pipes_nlp_nup[j][k] = new Pipe(timeFromUs(RTT), *eventlist);
        pipes_nlp_nup[j][k]->setName("Pipe-LP" + ntoa(j) + "->UP" + ntoa(k));
        logfile->writeName(*(pipes_nlp_nup[j][k]));

        if (ff) {
          ff->add_queue(queues_nlp_nup[j][k]);
          ff->add_queue(queues_nup_nlp[k][j]);
        }
    }
  }

    //init thresholds for lossless operation
    if (qt==LOSSLESS) {
        for (int j=0;j<NUP;j++){
            switches_up[j]->configureLossless();
        }
        for (int j=0;j<NLP;j++){
            switches_lp[j]->configureLossless();
        }
    }
}

static void check_non_null(Route* rt){
  int fail = 0;
  for (unsigned int i=1;i<rt->size()-1;i+=2)
    if (rt->at(i)==NULL){
      fail = 1;
      break;
    }

  if (fail){
    //    cout <<"Null queue in route"<<endl;
    for (unsigned int i=1;i<rt->size()-1;i+=2)
      printf("%p ",rt->at(i));

    cout<<endl;
    assert(0);
  }
}

vector<const Route*>* LeafSpineTopology::get_paths(int src, int dest){
  vector<const Route*>* paths = new vector<const Route*>();

  route_t *routeout, *routeback;
  if (HOST_POD_SWITCH(src)==HOST_POD_SWITCH(dest)) { //src, dest within same ToR

    // forward path
    routeout = new Route();
    routeout->push_back(queues_ns_nlp[src][HOST_POD_SWITCH(src)]);
    routeout->push_back(pipes_ns_nlp[src][HOST_POD_SWITCH(src)]);

    if (qt==LOSSLESS_INPUT || qt==LOSSLESS_INPUT_ECN) {
        routeout->push_back(queues_ns_nlp[src][HOST_POD_SWITCH(src)]->getRemoteEndpoint());
    }

    routeout->push_back(queues_nlp_ns[HOST_POD_SWITCH(dest)][dest]);
    routeout->push_back(pipes_nlp_ns[HOST_POD_SWITCH(dest)][dest]);

    // reverse path for RTS packets
    routeback = new Route();
    routeback->push_back(queues_ns_nlp[dest][HOST_POD_SWITCH(dest)]);
    routeback->push_back(pipes_ns_nlp[dest][HOST_POD_SWITCH(dest)]);

    if (qt==LOSSLESS_INPUT || qt==LOSSLESS_INPUT_ECN) {
        routeback->push_back(queues_ns_nlp[dest][HOST_POD_SWITCH(dest)]->getRemoteEndpoint());
    }

    routeback->push_back(queues_nlp_ns[HOST_POD_SWITCH(src)][src]);
    routeback->push_back(pipes_nlp_ns[HOST_POD_SWITCH(src)][src]);

    routeout->set_reverse(routeback);
    routeback->set_reverse(routeout);

    //print_route(*routeout);
    paths->push_back(routeout);

    check_non_null(routeout);
    return paths;
  }

  else {
    //there are NUP paths between the source and the destination
    for (int upper = 0;upper < NUP; upper++){
      //upper is nup

      routeout = new Route();
      routeout->push_back(queues_ns_nlp[src][HOST_POD_SWITCH(src)]);
      routeout->push_back(pipes_ns_nlp[src][HOST_POD_SWITCH(src)]);

      if (qt==LOSSLESS_INPUT || qt==LOSSLESS_INPUT_ECN) {
          routeout->push_back(queues_ns_nlp[src][HOST_POD_SWITCH(src)]->getRemoteEndpoint());
      }

      routeout->push_back(queues_nlp_nup[HOST_POD_SWITCH(src)][upper]);
      routeout->push_back(pipes_nlp_nup[HOST_POD_SWITCH(src)][upper]);

      if (qt==LOSSLESS_INPUT || qt==LOSSLESS_INPUT_ECN) {
          routeout->push_back(queues_nlp_nup[HOST_POD_SWITCH(src)][upper]->getRemoteEndpoint());
      }

      routeout->push_back(queues_nup_nlp[upper][HOST_POD_SWITCH(dest)]);
      routeout->push_back(pipes_nup_nlp[upper][HOST_POD_SWITCH(dest)]);

      if (qt==LOSSLESS_INPUT || qt==LOSSLESS_INPUT_ECN) {
          routeout->push_back(queues_nup_nlp[upper][HOST_POD_SWITCH(dest)]->getRemoteEndpoint());
      }

      routeout->push_back(queues_nlp_ns[HOST_POD_SWITCH(dest)][dest]);
      routeout->push_back(pipes_nlp_ns[HOST_POD_SWITCH(dest)][dest]);

      // reverse path for RTS packets
      routeback = new Route();

      routeback->push_back(queues_ns_nlp[dest][HOST_POD_SWITCH(dest)]);
      routeback->push_back(pipes_ns_nlp[dest][HOST_POD_SWITCH(dest)]);

      if (qt==LOSSLESS_INPUT || qt==LOSSLESS_INPUT_ECN) {
          routeback->push_back(queues_ns_nlp[dest][HOST_POD_SWITCH(dest)]->getRemoteEndpoint());
      }

      routeback->push_back(queues_nlp_nup[HOST_POD_SWITCH(dest)][upper]);
      routeback->push_back(pipes_nlp_nup[HOST_POD_SWITCH(dest)][upper]);

      if (qt==LOSSLESS_INPUT || qt==LOSSLESS_INPUT_ECN) {
          routeback->push_back(queues_nlp_nup[HOST_POD_SWITCH(dest)][upper]->getRemoteEndpoint());
      }

      routeback->push_back(queues_nup_nlp[upper][HOST_POD_SWITCH(src)]);
      routeback->push_back(pipes_nup_nlp[upper][HOST_POD_SWITCH(src)]);

      if (qt==LOSSLESS_INPUT || qt==LOSSLESS_INPUT_ECN) {
          routeback->push_back(queues_nup_nlp[upper][HOST_POD_SWITCH(src)]->getRemoteEndpoint());
      }
      
      routeback->push_back(queues_nlp_ns[HOST_POD_SWITCH(src)][src]);
      routeback->push_back(pipes_nlp_ns[HOST_POD_SWITCH(src)][src]);

      routeout->set_reverse(routeback);
      routeback->set_reverse(routeout);

      //print_route(*routeout);
      paths->push_back(routeout);
      check_non_null(routeout);
    }
    return paths;
  }
}

void LeafSpineTopology::count_queue(Queue* queue){
  if (_link_usage.find(queue)==_link_usage.end()){
    _link_usage[queue] = 0;
  }

  _link_usage[queue] = _link_usage[queue] + 1;
}

int LeafSpineTopology::find_lp_switch(Queue* queue){
  //first check ns_nlp
  for (int i=0;i<NSRV;i++)
    for (int j = 0;j<NLP;j++)
      if (queues_ns_nlp[i][j]==queue)
	return j;

  //only count nup to nlp
  count_queue(queue);

  for (int i=0;i<NUP;i++)
    for (int j = 0;j<NLP;j++)
      if (queues_nup_nlp[i][j]==queue)
	return j;

  return -1;
}

int LeafSpineTopology::find_up_switch(Queue* queue){
  count_queue(queue);
  //check nlp_nup
  for (int i=0;i<NLP;i++)
    for (int j = 0;j<NUP;j++)
      if (queues_nlp_nup[i][j]==queue)
	return j;

  return -1;
}

int LeafSpineTopology::find_destination(Queue* queue){
  //first check nlp_ns
  for (int i=0;i<NLP;i++)
    for (int j = 0;j<NSRV;j++)
      if (queues_nlp_ns[i][j]==queue)
	return j;

  return -1;
}

//void LeafSpineTopology::print_path(std::ofstream &paths,int src,const Route* route){
//  paths << "SRC_" << src << " ";
//  
//  if (route->size()/2==2){
//    paths << "LS_" << find_lp_switch((Queue*)route->at(1)) << " ";
//    paths << "DST_" << find_destination((Queue*)route->at(3)) << " ";
//  } else if (route->size()/2==4){
//    paths << "LS_" << find_lp_switch((Queue*)route->at(1)) << " ";
//    paths << "US_" << find_up_switch((Queue*)route->at(3)) << " ";
//    paths << "LS_" << find_lp_switch((Queue*)route->at(5)) << " ";
//    paths << "DST_" << find_destination((Queue*)route->at(7)) << " ";
//  } else if (route->size()/2==6){
//    paths << "LS_" << find_lp_switch((Queue*)route->at(1)) << " ";
//    paths << "US_" << find_up_switch((Queue*)route->at(3)) << " ";
//    paths << "CS_" << find_core_switch((Queue*)route->at(5)) << " ";
//    paths << "US_" << find_up_switch((Queue*)route->at(7)) << " ";
//    paths << "LS_" << find_lp_switch((Queue*)route->at(9)) << " ";
//    paths << "DST_" << find_destination((Queue*)route->at(11)) << " ";
//  } else {
//    paths << "Wrong hop count " << ntoa(route->size()/2);
//  }
//  
//  paths << endl;
//}
