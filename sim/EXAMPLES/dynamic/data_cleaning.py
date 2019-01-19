import sys
import numpy as np
import os.path

dirname = sys.argv[1]
short_flow = int(sys.argv[2]) #in bytes
long_flow = int(sys.argv[3]) #in bytes
pktsize = int(sys.argv[4]) #in bytes
propagation_delay_in_ns = int(sys.argv[5])
link_bandwidth = int(sys.argv[6])

protocols = ['ndp', 'dctcp']
load_val = [20, 40, 60, 80]

slowdown_bins = [10000, 50000, 100000, 500000, 1000000, 5000000, 10000000]
slowdown_list = [[] for i in range(len(slowdown_bins)+1)]
slowdown_val = [0.0 for i in range(len(slowdown_bins)+1)]
slowdown_count = [0 for i in range(len(slowdown_bins)+1)]
slowdown_avg = [0.0 for i in range(len(slowdown_bins)+1)]

for protocol in protocols:
    for load in load_val:
        filename = dirname+"/"+"trace-"+str(load)+".txt.csv."+protocol
        if (not os.path.isfile(filename)):
            print "Error: " + filename + " does not exist!"
            continue
        inp = open(filename, "r")

        sorted_fct = []
        sorted_tput = []

        for line in inp:
            tokens = line.split(',')
            flowsize = int(tokens[3])
            fct = float((tokens[5].split())[0])
            tput = float((tokens[6].split())[0])
            if (fct != -1):
                #calculate slowdown
                ideal_fct = ((flowsize*8.0)/link_bandwidth)/1e3 + 3*(((pktsize*8.0)/link_bandwidth)/1e3) + (propagation_delay_in_ns * 1e-3)
                slowdown = fct/ideal_fct
                if (slowdown < 1.0):
                    slowdown = 1.0
                for k in range(len(slowdown_bins)):
                    if (flowsize <= slowdown_bins[k]):
                        slowdown_list[k].append(slowdown)
                        slowdown_val[k] = slowdown_val[k] + slowdown
                        slowdown_count[k] = slowdown_count[k] + 1
                        break
                if (flowsize > slowdown_bins[len(slowdown_bins)-1]):
                    slowdown_val[len(slowdown_bins)] = slowdown_val[len(slowdown_bins)] + slowdown
                    slowdown_count[len(slowdown_bins)] = slowdown_count[len(slowdown_bins)] + 1
            if (flowsize <= short_flow):
                if (fct != -1):
                    sorted_fct.append(fct)
            elif (flowsize >= long_flow):
                if (tput != 0):
                    sorted_tput.append(tput)
        inp.close()

        out = open(dirname+"/"+protocol+"-"+str(load)+".txt.out.slowdown.mean", "w")
        for j in range(len(slowdown_val)):
            if slowdown_val[j] != 0:
                assert(slowdown_count[j] != 0)
                slowdown_avg[j] = slowdown_val[j] / slowdown_count[j]
                if j < len(slowdown_bins):
                    out.write(str(slowdown_bins[j])+","+str(slowdown_avg[j]))
                else:
                    out.write("infinity"+","+str(slowdown_avg[j]))
                out.write("\n")
        out.close()

        out = open(dirname+"/"+protocol+"-"+str(load)+".txt.out.slowdown.99", "w")
        for j in range(len(slowdown_list)):
            if len(slowdown_list[j]) != 0:
                if j < len(slowdown_bins):
                    out.write(str(slowdown_bins[j])+","+str(np.percentile(slowdown_list[j], 99)))
                else:
                    out.write("infinity"+","+str(np.percentile(slowdown_list[j], 99)))
                out.write("\n")
        out.close()

        if (len(sorted_fct) == 0):
            sorted_fct.append(-1)
        if (len(sorted_tput) == 0):
            sorted_tput.append(-1)

        sorted_fct.sort()
        f = np.array(sorted_fct)
        sorted_tput.sort()
        t = np.array(sorted_tput)

        fct = open(filename+".fct", "w")
        fct_cdf = open(filename+".fct.cdf", "w")
        tput = open(filename+".tput", "w")
        tput_cdf = open(filename+".tput.cdf", "w")

        for i in sorted_fct:
            fct_cdf.write(str(i))
            fct_cdf.write("\n")
        fct_cdf.close()

        for i in sorted_tput:
            tput_cdf.write(str(i))
            tput_cdf.write("\n")
        tput_cdf.close()

        for i in xrange(0,101,5):
            fct.write(str(i) + " " + str(np.percentile(f,i)))
            fct.write("\n")
        fct.write("99 " + str(np.percentile(f,99)) + "\n")
        fct.write("99.9 " + str(np.percentile(f,99.9)) + "\n")
        fct.write("avg " + str(sum(sorted_fct)/len(sorted_fct)))
        fct.close()

        for i in xrange(0,101,5):
            tput.write(str(i) + " " + str(np.percentile(t,i)))
            tput.write("\n")
        tput.write("avg " + str(sum(sorted_tput)/len(sorted_tput)))
        tput.close()
