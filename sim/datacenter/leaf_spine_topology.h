#ifndef LEAF_SPINE
#define LEAF_SPINE
#include "main.h"
#include "randomqueue.h"
#include "pipe.h"
#include "config.h"
#include "loggers.h"
#include "network.h"
#include "firstfit.h"
#include "topology.h"
#include "logfile.h"
#include "eventlist.h"
#include "switch.h"
#include <ostream>

#define HOST_POD_SWITCH(src) (src/LP_SRV_K)

#ifndef QT
#define QT
typedef enum {RANDOM, ECN, COMPOSITE, CTRL_PRIO, LOSSLESS, LOSSLESS_INPUT, LOSSLESS_INPUT_ECN} queue_type;
#endif

class LeafSpineTopology: public Topology{
 public:
  vector <Switch*> switches_lp;
  vector <Switch*> switches_up;
  vector <Switch*> switches_c;

  vector< vector<Pipe*> > pipes_nup_nlp;
  vector< vector<Pipe*> > pipes_nlp_ns;
  vector< vector<Queue*> > queues_nup_nlp;
  vector< vector<Queue*> > queues_nlp_ns;

  vector< vector<Pipe*> > pipes_nlp_nup;
  vector< vector<Pipe*> > pipes_ns_nlp;
  vector< vector<Queue*> > queues_nlp_nup;
  vector< vector<Queue*> > queues_ns_nlp;

  FirstFit* ff;
  Logfile* logfile;
  EventList* eventlist;
  queue_type qt;
  double PER_HOP_DELAY;

  LeafSpineTopology(mem_b queuesize, Logfile* log,EventList* ev,FirstFit* f, queue_type q, double RTT);

  void init_network();
  virtual vector<const Route*>* get_paths(int src, int dest);

  Queue* alloc_src_queue(QueueLogger* q);
  Queue* alloc_queue(QueueLogger* q, mem_b queuesize);
  Queue* alloc_queue(QueueLogger* q, uint64_t speed, mem_b queuesize);

  void count_queue(Queue*);
  void print_path(std::ofstream& paths,int src,const Route* route);
  vector<int>* get_neighbours(int src) { return NULL;};
 private:
  map<Queue*,int> _link_usage;
  int find_lp_switch(Queue* queue);
  int find_up_switch(Queue* queue);
  int find_destination(Queue* queue);
  void set_params();
  int LP_SRV_K, NLP, NUP, NSRV;
  mem_b _queuesize;
};

#endif
