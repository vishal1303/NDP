import sys
import os
import numpy as np

workload = sys.argv[1]
dirname = "workload/skew_workload/all-to-all-144-"+sys.argv[1]
protocol = sys.argv[2]

bandwidth = ['40G', '100G']
delay = ['200.0ns']
load = [0.6]
skew = [0.2, 0.4, 0.6, 0.8]

#slowdown
for b in bandwidth:
    for d in delay:
        for l in load:
            for s in skew:
                slowdown_all_val = 0.0
                slowdown_all_count = 0
                slowdown_all_list = []
                slowdown_bins = [10000, 100000, 1000000]
                slowdown_bin_symbols = ["(0,10K]", "(10-100K]", "(100K-1M]", "(1M-infty)"]
                slowdown_list = [[] for i in range(len(slowdown_bins)+1)]
                slowdown_val = [0.0 for i in range(len(slowdown_bins)+1)]
                slowdown_count = [0 for i in range(len(slowdown_bins)+1)]
                slowdown_avg = [0.0 for i in range(len(slowdown_bins)+1)]
                try:
                    f = open(dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+"-"+str(s)+".out", "r")
                    for line in f:
                        tokens = line.split(',')
                        if (tokens[0] != 'Flow ID' and tokens[0] != 'Problem'):
                            flow_size = float(tokens[3])
                            slowdown = float(tokens[5])
                            slowdown_all_val += slowdown
                            slowdown_all_count += 1
                            slowdown_all_list.append(slowdown)
                            for k in range(len(slowdown_bins)):
                                if (flow_size <= slowdown_bins[k]):
                                    slowdown_list[k].append(slowdown)
                                    slowdown_val[k] = slowdown_val[k] + slowdown
                                    slowdown_count[k] = slowdown_count[k] + 1
                                    break
                            if (flow_size > slowdown_bins[len(slowdown_bins)-1]):
                                slowdown_list[len(slowdown_bins)].append(slowdown)
                                slowdown_val[len(slowdown_bins)] = slowdown_val[len(slowdown_bins)] + slowdown
                                slowdown_count[len(slowdown_bins)] = slowdown_count[len(slowdown_bins)] + 1
                    f.close()
                except:
                    print dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+"-"+str(s)+".out "+"not found"
                    pass

                out = open(dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+"-"+str(s)+".out.slowdown.bin.mean", "w")
                out.write("arch ")
                for s in slowdown_bin_symbols:
                    out.write(s)
                    out.write(" ")
                out.write("\n")
                out.write(protocol)
                out.write(" ")
                for j in range(len(slowdown_val)):
                    if slowdown_val[j] != 0:
                        assert(slowdown_count[j] != 0)
                        slowdown_avg[j] = slowdown_val[j] / slowdown_count[j]
                        if j < len(slowdown_bins):
                            out.write(str(slowdown_avg[j]))
                            out.write(" ")
                        else:
                            out.write(str(slowdown_avg[j]))
                            out.write("\n")
                    else:
                        if j < len(slowdown_bins):
                            out.write("1 ")
                        else:
                            out.write("1")
                            out.write("\n")
                out.close()

                out = open(dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+"-"+str(s)+".out.slowdown.bin.99", "w")
                out.write("arch ")
                for s in slowdown_bin_symbols:
                    out.write(s)
                    out.write(" ")
                out.write("\n")
                out.write(protocol)
                out.write(" ")
                for j in range(len(slowdown_list)):
                    if len(slowdown_list[j]) != 0:
                        slowdown_list[j].sort()
                        if j < len(slowdown_bins):
                            out.write(str(np.percentile(slowdown_list[j], 99)))
                            out.write(" ")
                        else:
                            out.write(str(np.percentile(slowdown_list[j], 99)))
                            out.write("\n")
                    else:
                        if j < len(slowdown_bins):
                            out.write("1 ")
                        else:
                            out.write("1")
                            out.write("\n")
                out.close()

                out = open(dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+"-"+str(s)+".out.slowdown.all.mean", "w")
                if (slowdown_all_count == 0):
                    out.write("1")
                else:
                    mean_slowdown = slowdown_all_val / slowdown_all_count
                    out.write(str(mean_slowdown))
                out.close()

                out = open(dirname+"/"+protocol+"-"+b+"-"+d+"-"+str(l)+"-"+str(s)+".out.slowdown.all.99", "w")
                if (len(slowdown_all_list) == 0):
                    out.write("1")
                else:
                    slowdown_all_list.sort()
                    p99_slowdown = np.percentile(slowdown_all_list, 99)
                    out.write(str(p99_slowdown))
                out.close()
