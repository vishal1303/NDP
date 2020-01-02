import sys
import os

workload = sys.argv[1]
dirname = "workload/dc_workload/all-to-all-144-"+workload
protocol = sys.argv[2]

bandwidth = ['40G', '100G', '400G']
delay = ['625.6ns']
load = [0.2, 0.4, 0.6, 0.8]

slowdown_val = []

for b in bandwidth:
    for l in load:
        slowdown_val = []
        for d in delay:
            try:
                f = open(dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+".out.slowdown.all.mean", "r")
                for line in f:
                    slowdown_val.append(line.strip())
                f.close()
            except:
                slowdown_val.append("0")
                continue
        out = open(dirname+"/"+protocol+"-"+b+"-ANY"+"-"+str(l)+".out.slowdown.all.mean", "w")
        out.write("arch 625")
        out.write("\n")
        out.write(protocol)
        out.write(" ")
        for s_val in slowdown_val:
            out.write(s_val)
            out.write(" ")
        out.close()

for b in bandwidth:
    for l in load:
        slowdown_val = []
        for d in delay:
            try:
                f = open(dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+".out.slowdown.all.99", "r")
                for line in f:
                    slowdown_val.append(line.strip())
                f.close()
            except:
                slowdown_val.append("0")
                continue
        out = open(dirname+"/"+protocol+"-"+b+"-ANY"+"-"+str(l)+".out.slowdown.all.99", "w")
        out.write("arch 625")
        out.write("\n")
        out.write(protocol)
        out.write(" ")
        for s_val in slowdown_val:
            out.write(s_val)
            out.write(" ")
        out.close()
