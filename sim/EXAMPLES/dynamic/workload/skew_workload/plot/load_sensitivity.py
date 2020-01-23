import sys
import os

workload = sys.argv[1]
dirname = "workload/skew_workload/all-to-all-144-"+workload
protocol = sys.argv[2]

bandwidth = ['40G', '100G']
delay = ['200.0ns']
load = [0.6]
skew = [0.2, 0.4, 0.6, 0.8]

slowdown_val = []

for b in bandwidth:
    for d in delay:
        for s in skew:
            slowdown_val = []
            for l in load:
                try:
                    f = open(dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+"-"+str(s)+".out.slowdown.all.mean", "r")
                    for line in f:
                        slowdown_val.append(line.strip())
                    f.close()
                except:
                    slowdown_val.append("1")
                    continue
            out = open(dirname+"/"+protocol+"-"+b+"-"+d+"-ANY-"+str(s)+".out.slowdown.all.mean", "w")
            out.write("arch ")
            for i in range(len(load)):
                out.write(str(load[i])+" ")
            out.write("\n")
            out.write(protocol)
            out.write(" ")
            for s_val in slowdown_val:
                out.write(s_val)
                out.write(" ")
            out.close()

for b in bandwidth:
    for d in delay:
        for s in skew:
            slowdown_val = []
            for l in load:
                try:
                    f = open(dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+"-"+str(s)+".out.slowdown.all.99", "r")
                    for line in f:
                        slowdown_val.append(line.strip())
                    f.close()
                except:
                    slowdown_val.append("1")
                    continue
            out = open(dirname+"/"+protocol+"-"+b+"-"+d+"-ANY-"+str(s)+".out.slowdown.all.99", "w")
            out.write("arch ")
            for i in range(len(load)):
                out.write(str(load[i])+" ")
            out.write("\n")
            out.write(protocol)
            out.write(" ")
            for l_val in slowdown_val:
                out.write(l_val)
                out.write(" ")
            out.close()
