import sys
import numpy as np
import os.path

dirname = sys.argv[1]
short_flow = int(sys.argv[2]) #in bytes
long_flow = int(sys.argv[3]) #in bytes
pktsize = int(sys.argv[4]) #in bytes
propagation_delay_per_hop_in_ns = int(sys.argv[5])
link_bandwidth = int(sys.argv[6])

protocols = ['ndp', 'dctcp', 'dcqcn']
load_val = [20, 40, 60, 80]


#slowdown_bins = [10000, 50000, 100000, 500000, 1000000, 5000000, 10000000]
slowdown_bins = [100000, 5000000]

def get_oracle_fct(src_addr, dst_addr, flow_size, bandwidth):
    num_hops = 4
    if (src_addr / 16 == dst_addr / 16):
        num_hops = 2

    propagation_delay = (num_hops * propagation_delay_per_hop_in_ns)*1e-3
    transmission_delay = 0

    # transmission_delay = (incl_overhead_bytes + 40) * 8.0 / bandwidth
    transmission_delay = flow_size * 8.0 / bandwidth
    if (num_hops == 4):
        transmission_delay += 1.5 * pktsize * 8.0 / bandwidth
    else:
        transmission_delay += 1 * pktsize * 8.0 / bandwidth
    return transmission_delay + propagation_delay

for protocol in protocols:
    slowdown_all_val = 0.0
    slowdown_all_count = 0
    slowdown_list = [[] for i in range(len(slowdown_bins)+1)]
    slowdown_val = [0.0 for i in range(len(slowdown_bins)+1)]
    slowdown_count = [0 for i in range(len(slowdown_bins)+1)]
    slowdown_avg = [0.0 for i in range(len(slowdown_bins)+1)]
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
                ideal_fct = get_oracle_fct(int(tokens[1]), int(tokens[2]), flowsize, link_bandwidth*1000) # bandwidth in Mbps
                slowdown = fct/ideal_fct
                if (slowdown < 1.0):
                    slowdown = 1.0
                slowdown_all_val += slowdown
                slowdown_all_count += 1
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

        out = open(dirname+"/"+protocol+"-"+str(load)+".txt.out.slowdown.all", "w")
        mean_slowdown = slowdown_all_val / slowdown_all_count
        out.write(str(mean_slowdown))
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
