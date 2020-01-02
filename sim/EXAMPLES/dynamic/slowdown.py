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

flows = {}

folder = "workload/dc_workload/all-to-all-144-"+workload
filename = "xpass-"+str(bandwidth)+"G-"+str(propagation_delay_per_hop_in_ns)+"ns-"+str(load)+".out"

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

def main():
    flowfile = open("flowfile.tr", "r")
    for line in flowfile:
        tokens = line.split()
        flows[tokens[1]] = [tokens[2],tokens[3]]
    flowfile.close()

    f = open("outputs/fct.out", "r")
    f1 = open(folder+"/"+filename, "w")

    f1.write("Flow ID,"+"Src,"+"Dst,"+"Flow Size(bytes),"+"Flow Completion Time(secs),"+"Slowdown,"+"Throughput(Gbps)")
    f1.write("\n")
    count = 0
    for line in f:
        if count==0:
            count += 1
            continue
        else:
            tokens = line.split(",")
            src_addr = int(flows[tokens[0]][0])
            dst_addr = int(flows[tokens[0]][1])
            flow_size = int(tokens[1])
            oracle_fct = get_oracle_fct(src_addr, dst_addr, flow_size)
            slowdown = (float(tokens[3])*1e9) / oracle_fct
            #assert(slowdown >= 1.0)
            if (slowdown < 1.0):
                f1.write("Problem,")
            f1.write(tokens[0]+","+str(src_addr)+","+str(dst_addr)+","+tokens[1]+","+tokens[3]+","+str(slowdown)+","+tokens[4])
    f.close()
    f1.close()

if __name__ == '__main__' : main()
