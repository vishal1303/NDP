#!/bin/bash

linkspeed=50
cwnd=35
queuesize=100
pktsize=1500

endtime=0.025 #in sec
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
#    echo "Extracting FCT and Rates: python process_data.py dcqcn_debug dcqcn_rate test/${i}.csv dcqcn ${linkspeed}"
#    python process_data.py dcqcn_debug dcqcn_rate test/${i}.csv dcqcn ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py test/${i}.csv.dcqcn ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py test/${i}.csv.dcqcn ${shortflowsize} ${longflowsize}
#done

#PERM SHORT FLOWS
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i perm-shortflows-512/${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i perm-shortflows-512/${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} > dcqcn_debug
#    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
#    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
#    echo "Extracting FCT and Rates: python process_data.py dcqcn_debug dcqcn_rate perm-shortflows-512/${i}.csv dcqcn ${linkspeed}"
#    python process_data.py dcqcn_debug dcqcn_rate perm-shortflows-512/${i}.csv dcqcn ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py perm-shortflows-512/${i}.csv.dcqcn ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py perm-shortflows-512/${i}.csv.dcqcn ${shortflowsize} ${longflowsize}
#done

#PREDICTABILITY
for i in 0.9 0.5 0;
do
    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i predictability/${i}.csv.new -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish}
    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i predictability/${i}.csv.new -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} > dcqcn_debug
    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
    echo "Extracting FCT and Rates: python process_data_1.py dcqcn_debug dcqcn_rate predictability/${i}.csv.new dcqcn ${linkspeed} 511 0"
    python process_data_1.py dcqcn_debug dcqcn_rate predictability/${i}.csv.new dcqcn ${linkspeed} 511 0
    echo "Data cleaning: python extract_fct_tput.py predictability/${i}.csv.new.dcqcn ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py predictability/${i}.csv.new.dcqcn ${shortflowsize} ${longflowsize}
done

#INCAST
#for ((i=201;i<=201;i=i+1));
#do
#    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i incast-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize}
#    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i incast-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > dcqcn_debug
#    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
#    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
#    echo "Extracting FCT and Rates: python process_data.py dcqcn_debug dcqcn_rate incast-512/${i}.dat dcqcn ${linkspeed}"
#    python process_data.py dcqcn_debug dcqcn_rate incast-512/${i}.dat dcqcn ${linkspeed}
#done

#PERMUTATION
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i permutation-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime}
#    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i permutation-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > dcqcn_debug -endtime ${endtime}
#    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
#    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
#    echo "Extracting FCT and Rates: python process_data.py dcqcn_debug dcqcn_rate permutation-512/${i}.dat dcqcn ${linkspeed}"
#    python process_data.py dcqcn_debug dcqcn_rate permutation-512/${i}.dat dcqcn ${linkspeed}
#done

#DC Workloads
#for ((i=0;i<=4;i=i+1));
#do
#    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > dcqcn_debug
#    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
#    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
#    echo "Extracting FCT and Rates: python process_data.py dcqcn_debug dcqcn_rate dc_workload_100G/log_flows_fattree_load-${i}.csv dcqcn ${linkspeed}"
#    python process_data.py dcqcn_debug dcqcn_rate dc_workload_100G/log_flows_fattree_load-${i}.csv dcqcn ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py dc_workload_100G/log_flows_fattree_load-${i}.csv.dcqcn ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py dc_workload_100G/log_flows_fattree_load-${i}.csv.dcqcn ${shortflowsize} ${longflowsize}
#done

#Disaggregated Workloads
#for fname in bdb_nodes=512_flows=2000000_load=0.25.csv graphlab_nodes=512_flows=2000000_load=0.25.csv memcached_nodes=512_flows=2000000_load=0.25.csv terasort_hadoop_nodes=512_flows=2000000_load=0.25.csv terasort_spark_nodes=512_flows=2000000_load=0.25.csv ;
#do
#    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i disaggregated_workload_100G/${fname} -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i disaggregated_workload_100G/${fname} -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > dcqcn_debug
#    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
#    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
#    echo "Extracting FCT and Rates: python process_data.py dcqcn_debug dcqcn_rate disaggregated_workload_100G/${fname} dcqcn ${linkspeed}"
#    python process_data.py dcqcn_debug dcqcn_rate disaggregated_workload_100G/${fname} dcqcn ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py disaggregated_workload_100G/${fname}.dcqcn ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py disaggregated_workload_100G/${fname}.dcqcn ${shortflowsize} ${longflowsize}
#done
#for fname in bdb_nodes=512_flows=2000000_load=0.10.csv graphlab_nodes=512_flows=2000000_load=0.10.csv memcached_nodes=512_flows=2000000_load=0.10.csv terasort_hadoop_nodes=512_flows=2000000_load=0.10.csv terasort_spark_nodes=512_flows=2000000_load=0.10.csv ;
#do
#    echo ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i disaggregated_workload_100G/${fname} -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_dcqcn_dynamic -o dcqcn_logfile -i disaggregated_workload_100G/${fname} -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > dcqcn_debug
#    echo "Parsing the logfile: ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate"
#    ../../parse_output dcqcn_logfile -dcqcn -show > dcqcn_rate
#    echo "Extracting FCT and Rates: python process_data.py dcqcn_debug dcqcn_rate disaggregated_workload_100G/${fname} dcqcn ${linkspeed}"
#    python process_data.py dcqcn_debug dcqcn_rate disaggregated_workload_100G/${fname} dcqcn ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py disaggregated_workload_100G/${fname}.dcqcn ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py disaggregated_workload_100G/${fname}.dcqcn ${shortflowsize} ${longflowsize}
#done
