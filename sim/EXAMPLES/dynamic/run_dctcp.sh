#!/bin/bash

cwnd=35
queuesize=100
pktsize=1500

endtime=0.1 #in sec
flowsfinish=500000 #stop experiment after these many flows have finished

shortflowsize=102400 #in bytes
longflowsize=1000000 #in bytes

#TEST
#for ((i=0;i<=0;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i test/${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i test/${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} > dctcp_debug
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_dctcp.py dctcp_debug dctcp_rate test/${i}.csv"
#    python process_dctcp.py dctcp_debug dctcp_rate test/${i}.csv
#    echo "Data cleaning: python extract_fct_tput.py test/${i}.csv.dctcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py test/${i}.csv.dctcp ${shortflowsize} ${longflowsize}
#done

#INCAST
#for ((i=201;i<=201;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i incast-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i incast-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > dctcp_debug
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_dctcp.py dctcp_debug dctcp_rate incast-512/${i}.dat"
#    python process_dctcp.py dctcp_debug dctcp_rate incast-512/${i}.dat
#done

#PERMUTATION
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > dctcp_debug -endtime ${endtime}
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_dctcp.py dctcp_debug dctcp_rate permutation-512/${i}.dat"
#    python process_dctcp.py dctcp_debug dctcp_rate permutation-512/${i}.dat
#done

#DC Workloads
for ((i=0;i<=4;i=i+1));
do
    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i dc_workload/log_flows_fattree_load-${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i dc_workload/log_flows_fattree_load-${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > dctcp_debug
    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
    echo "Extracting FCT and Rates: python process_dctcp.py dctcp_debug dctcp_rate dc_workload/log_flows_fattree_load-${i}.csv"
    python process_dctcp.py dctcp_debug dctcp_rate dc_workload/log_flows_fattree_load-${i}.csv
    echo "Data cleaning: python extract_fct_tput.py dc_workload/log_flows_fattree_load-${i}.csv.dctcp ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py dc_workload/log_flows_fattree_load-${i}.csv.dctcp ${shortflowsize} ${longflowsize}
done
