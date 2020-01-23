import os
import sys
import re
import argparse
import math
import numpy as np

workload = sys.argv[1]
load = float(sys.argv[2])
bandwidth = int(sys.argv[3])
pktsize = int(sys.argv[4])
nodes_per_rack = int(sys.argv[5])
propagation_delay_per_hop_in_ns = float(sys.argv[6])
skew = float(sys.argv[7])
protocol = sys.argv[8]

flows = {}

folder = "workload/dc_workload/all-to-all-144-"+workload
filename = protocol+"-"+str(bandwidth)+"G-"+str(propagation_delay_per_hop_in_ns)+"ns-"+str(load)+"-"+str(skew)+".out"

def get_oracle_fct(src_addr, dst_addr, flow_size):
    num_hops = 4
    if (src_addr / nodes_per_rack == dst_addr / nodes_per_rack):
        num_hops = 2

    propagation_delay = (num_hops * propagation_delay_per_hop_in_ns)
    if (flow_size < pktsize):
        transmission_delay = ((num_hops * flow_size * 8.0) / bandwidth)
    else:
        transmission_delay = ((num_hops * pktsize * 8.0) / bandwidth)
        transmission_delay += (((flow_size - pktsize) * 8.0) / bandwidth)

    return transmission_delay + propagation_delay

tracefile = "trace-"+str(bandwidth)+"G-"+str(load)+"-"+str(skew)".csv"
inp = open(folder+"/"+tracefile, "r")
for line in inp:
    tokens = line.split(',')
    flows[int(tokens[0].strip())] = [int(tokens[1].strip()), int(tokens[2].strip()), int(float(tokens[3].strip())), float(tokens[4].strip())]

out = open(folder+"/"+filename, "w")
out.write("Flow ID,"+"Src,"+"Dst,"+"Flow Size(bytes),"+"Flow Completion Time(secs),"+"Slowdown,"+"Throughput(Gbps)")
out.write("\n")

fct_file = open(protocol+"_debug", "r")
for line in fct_file:
    tokens = line.split()
    if (len(tokens) > 2 and tokens[2] == "finished"):
        ID = int((tokens[1].split('-'))[1])
        #assert(ID in flows)
        if (ID in flows):
            src_addr = flows[ID][0]
            dst_addr = flows[ID][1]
            flowsize = int(flows[ID][2])
            fct = float(tokens[4])*1e-3 - float(flows[ID][3]) # end-start in sec
            rate = (flowsize*8.0)/(fct*1e9) #in Gbps
            oracle_fct = get_oracle_fct(src_addr, dst_addr, flowsize)
            slowdown = (fct*1e9) / oracle_fct
            #assert(slowdown >= 1.0)
            if (slowdown < 1.0):
                out.write("Problem,")
            out.write(str(ID)+","+str(src_addr)+","+str(dst_addr)+","+str(flowsize)+","+str(fct)+","+str(slowdown)+","+str(rate))
            out.write("\n")
            del flows[ID]
fct_file.close()
out.close()

