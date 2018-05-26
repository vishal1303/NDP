# NDP
NDP datacenter stack.
The doc directory contains documentation about the project.
The sim directory contains the simulator implementation of NDP which allows running experiments in various datacenter topologies. For much more information about NDP, see the [wiki](https://github.com/nets-cs-pub-ro/NDP/wiki).

# To change the link bandwidth
1. Change the link speed in #define HOST_NIC 50000 line 7 in sim/datacenter/main.h
2. Change the link speed in the function NdpPullPacer::NdpPullPacer(EventList& event, double pull_rate_modifier) line 1191 in file sim/ndp.cpp
