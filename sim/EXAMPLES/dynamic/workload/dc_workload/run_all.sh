#!/bin/bash

no_of_nodes=144
nodes_per_rack=16

endtime=500 #in sec
flowsfinish=1000000 #stop experiment after these many flows have finished
flowsstart=100000 #stop experiment after these many flows have started

#NDP
declare -a workload=("aditya" "dctcp")
bandwidth=40
pktsize=1500
cwnd=35
queuesize=12
protocol="ndp"

for workload in "${workload[@]}"
do
    for delay in 625.6 #propagation delay per hop (ns)
    do
        for load in 0.2 0.4 0.6 0.8
        do
            echo "../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i workload/dc_workload/all-to-all-144-${workload}/trace-${bandwidth}G-${load}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -delay ${delay} -strat perm > ${protocol}_debug"
            ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i workload/dc_workload/all-to-all-144-${workload}/trace-${bandwidth}G-${load}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -delay ${delay} -strat perm > ${protocol}_debug
            cp ${protocol}_debug workload/dc_workload/all-to-all-144-${workload}/${protocol}-${bandwidth}G-${delay}ns-${load}.stats
            echo "Extracting Slowdown: python process_data.py ${workload} ${load} ${bandwidth} ${pktsize} ${nodes_per_rack} ${delay} ${protocol}"
            python process_data.py ${workload} ${load} ${bandwidth} ${pktsize} ${nodes_per_rack} ${delay} ${protocol}
        done
    done
done

#DCTCP
declare -a workload=("aditya" "dctcp")
bandwidth=40
pktsize=1500
cwnd=35
queuesize=100
protocol="dctcp"

for workload in "${workload[@]}"
do
    for delay in 625.6 #propagation delay per hop (ns)
    do
        for load in 0.2 0.4 0.6 0.8
        do
            echo "../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i workload/dc_workload/all-to-all-144-${workload}/trace-${bandwidth}G-${load}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -delay ${delay} > ${protocol}_debug"
            ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i workload/dc_workload/all-to-all-144-${workload}/trace-${bandwidth}G-${load}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -delay ${delay} > ${protocol}_debug
            cp ${protocol}_debug workload/dc_workload/all-to-all-144-${workload}/${protocol}-${bandwidth}G-${delay}ns-${load}.stats
            echo "Extracting Slowdown: python process_data.py ${workload} ${load} ${bandwidth} ${pktsize} ${nodes_per_rack} ${delay} ${protocol}"
            python process_data.py ${workload} ${load} ${bandwidth} ${pktsize} ${nodes_per_rack} ${delay} ${protocol}
        done
    done
done

#DCQCN
declare -a workload=("aditya" "dctcp")
bandwidth=40
pktsize=1500
cwnd=35
queuesize=100
protocol="dcqcn"

for workload in "${workload[@]}"
do
    for delay in 625.6 #propagation delay per hop (ns)
    do
        for load in 0.2 0.4 0.6 0.8
        do
            echo "../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i workload/dc_workload/all-to-all-144-${workload}/trace-${bandwidth}G-${load}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -delay ${delay} > ${protocol}_debug"
            ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i workload/dc_workload/all-to-all-144-${workload}/trace-${bandwidth}G-${load}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -delay ${delay} > ${protocol}_debug
            cp ${protocol}_debug workload/dc_workload/all-to-all-144-${workload}/${protocol}-${bandwidth}G-${delay}ns-${load}.stats
            echo "Extracting Slowdown: python process_data.py ${workload} ${load} ${bandwidth} ${pktsize} ${nodes_per_rack} ${delay} ${protocol}"
            python process_data.py ${workload} ${load} ${bandwidth} ${pktsize} ${nodes_per_rack} ${delay} ${protocol}
        done
    done
done
