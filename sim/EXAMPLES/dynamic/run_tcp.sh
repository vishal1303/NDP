#!/bin/bash

no_of_nodes=128
linkspeed=10
cwnd=35
queuesize=50
pktsize=1500

endtime=100 #in sec
flowsfinish=127 #stop experiment after these many flows have finished

shortflowsize=102400 #in bytes
longflowsize=1000000 #in bytes

#TEST
#for ((i=0;i<=0;i=i+1));
#do
#    echo ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i test/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i test/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} > tcp_debug
#    echo "Parsing the logfile: ../../parse_output tcp_logfile -tcp -show > tcp_rate"
#    ../../parse_output tcp_logfile -tcp -show > tcp_rate
#    echo "Extracting FCT and Rates: python process_data.py tcp_debug tcp_rate test/${i}.csv tcp ${linkspeed}"
#    python process_data.py tcp_debug tcp_rate test/${i}.csv tcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py test/${i}.csv.tcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py test/${i}.csv.tcp ${shortflowsize} ${longflowsize}
#done

#PERM SHORT FLOWS
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i perm-shortflows-512/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i perm-shortflows-512/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} > tcp_debug
#    echo "Parsing the logfile: ../../parse_output tcp_logfile -tcp -show > tcp_rate"
#    ../../parse_output tcp_logfile -tcp -show > tcp_rate
#    echo "Extracting FCT and Rates: python process_data.py tcp_debug tcp_rate perm-shortflows-512/${i}.csv tcp ${linkspeed}"
#    python process_data.py tcp_debug tcp_rate perm-shortflows-512/${i}.csv tcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py perm-shortflows-512/${i}.csv.tcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py perm-shortflows-512/${i}.csv.tcp ${shortflowsize} ${longflowsize}
#done

#PREDICTABILITY
#`for i in 0.9 0.5 0;
#`do
#`    echo ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i predictability/${i}.csv.new -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish}
#`    ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i predictability/${i}.csv.new -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} > tcp_debug
#`    echo "Parsing the logfile: ../../parse_output tcp_logfile -tcp -show > tcp_rate"
#`    ../../parse_output tcp_logfile -tcp -show > tcp_rate
#`    echo "Extracting FCT and Rates: python process_data_1.py tcp_debug tcp_rate predictability/${i}.csv.new tcp ${linkspeed} 511 0"
#`    python process_data_1.py tcp_debug tcp_rate predictability/${i}.csv.new tcp ${linkspeed} 511 0
#`    echo "Data cleaning: python extract_fct_tput.py predictability/${i}.csv.new.tcp ${shortflowsize} ${longflowsize}"
#`    python extract_fct_tput.py predictability/${i}.csv.new.tcp ${shortflowsize} ${longflowsize}
#`done

#INCAST
for ((i=128;i<=128;i=i+1));
do
    echo ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i incast-128/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish}
    ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i incast-128/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} > tcp_debug
    echo "Parsing the logfile: ../../parse_output tcp_logfile -tcp -show > tcp_rate"
    ../../parse_output tcp_logfile -tcp -show > tcp_rate
    echo "Extracting FCT and Rates: python process_data.py tcp_debug tcp_rate incast-128/${i}.dat tcp ${linkspeed}"
    python process_data.py tcp_debug tcp_rate incast-128/${i}.dat tcp ${linkspeed}
done

#PERMUTATION
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i permutation-512/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime}
#    ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i permutation-512/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > tcp_debug -endtime ${endtime}
#    echo "Parsing the logfile: ../../parse_output tcp_logfile -tcp -show > tcp_rate"
#    ../../parse_output tcp_logfile -tcp -show > tcp_rate
#    echo "Extracting FCT and Rates: python process_data.py tcp_debug tcp_rate permutation-512/${i}.dat tcp ${linkspeed}"
#    python process_data.py tcp_debug tcp_rate permutation-512/${i}.dat tcp ${linkspeed}
#done

#DC Workloads
#for ((i=0;i<=4;i=i+1));
#do
#    echo ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > tcp_debug
#    echo "Parsing the logfile: ../../parse_output tcp_logfile -tcp -show > tcp_rate"
#    ../../parse_output tcp_logfile -tcp -show > tcp_rate
#    echo "Extracting FCT and Rates: python process_data.py tcp_debug tcp_rate dc_workload_100G/log_flows_fattree_load-${i}.csv tcp ${linkspeed}"
#    python process_data.py tcp_debug tcp_rate dc_workload_100G/log_flows_fattree_load-${i}.csv tcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py dc_workload_100G/log_flows_fattree_load-${i}.csv.tcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py dc_workload_100G/log_flows_fattree_load-${i}.csv.tcp ${shortflowsize} ${longflowsize}
#done

#Disaggregated Workloads
#for fname in bdb_nodes=512_flows=2000000_load=0.25.csv graphlab_nodes=512_flows=2000000_load=0.25.csv memcached_nodes=512_flows=2000000_load=0.25.csv terasort_hadoop_nodes=512_flows=2000000_load=0.25.csv terasort_spark_nodes=512_flows=2000000_load=0.25.csv ;
#do
#    echo ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > tcp_debug
#    echo "Parsing the logfile: ../../parse_output tcp_logfile -tcp -show > tcp_rate"
#    ../../parse_output tcp_logfile -tcp -show > tcp_rate
#    echo "Extracting FCT and Rates: python process_data.py tcp_debug tcp_rate disaggregated_workload_100G/${fname} tcp ${linkspeed}"
#    python process_data.py tcp_debug tcp_rate disaggregated_workload_100G/${fname} tcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py disaggregated_workload_100G/${fname}.tcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py disaggregated_workload_100G/${fname}.tcp ${shortflowsize} ${longflowsize}
#done
#for fname in bdb_nodes=512_flows=2000000_load=0.10.csv graphlab_nodes=512_flows=2000000_load=0.10.csv memcached_nodes=512_flows=2000000_load=0.10.csv terasort_hadoop_nodes=512_flows=2000000_load=0.10.csv terasort_spark_nodes=512_flows=2000000_load=0.10.csv ;
#do
#    echo ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_tcp_dynamic -o tcp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > tcp_debug
#    echo "Parsing the logfile: ../../parse_output tcp_logfile -tcp -show > tcp_rate"
#    ../../parse_output tcp_logfile -tcp -show > tcp_rate
#    echo "Extracting FCT and Rates: python process_data.py tcp_debug tcp_rate disaggregated_workload_100G/${fname} tcp ${linkspeed}"
#    python process_data.py tcp_debug tcp_rate disaggregated_workload_100G/${fname} tcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py disaggregated_workload_100G/${fname}.tcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py disaggregated_workload_100G/${fname}.tcp ${shortflowsize} ${longflowsize}
#done
