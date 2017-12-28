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
#    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i test/${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i test/${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} > dcqcn_debug
#    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
#    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
#    echo "Extracting FCT and Rates: python process_dcqcn.py dcqcn_debug dcqcn_rate test/${i}.csv"
#    python process_dcqcn.py dcqcn_debug dcqcn_rate test/${i}.csv
#    echo "Data cleaning: python extract_fct_tput.py test/${i}.csv.dcqcn ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py test/${i}.csv.dcqcn ${shortflowsize} ${longflowsize}
#done

#INCAST
#for ((i=201;i<=201;i=i+1));
#do
#    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i incast-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize}
#    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i incast-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > dcqcn_debug
#    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
#    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
#    echo "Extracting FCT and Rates: python process_dcqcn.py dcqcn_debug dcqcn_rate incast-512/${i}.dat"
#    python process_dcqcn.py dcqcn_debug dcqcn_rate incast-512/${i}.dat
#done

#PERMUTATION
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i permutation-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime}
#    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i permutation-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > dcqcn_debug -endtime ${endtime}
#    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
#    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
#    echo "Extracting FCT and Rates: python process_dcqcn.py dcqcn_debug dcqcn_rate permutation-512/${i}.dat"
#    python process_dcqcn.py dcqcn_debug dcqcn_rate permutation-512/${i}.dat
#done

#DC Workloads
for ((i=0;i<=4;i=i+1));
do
    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i dc_workload/log_flows_fattree_load-${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i dc_workload/log_flows_fattree_load-${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > dcqcn_debug
    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
    echo "Extracting FCT and Rates: python process_dcqcn.py dcqcn_debug dcqcn_rate dc_workload/log_flows_fattree_load-${i}.csv"
    python process_dcqcn.py dcqcn_debug dcqcn_rate dc_workload/log_flows_fattree_load-${i}.csv
    echo "Data cleaning: python extract_fct_tput.py dc_workload/log_flows_fattree_load-${i}.csv.dcqcn ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py dc_workload/log_flows_fattree_load-${i}.csv.dcqcn ${shortflowsize} ${longflowsize}
done
