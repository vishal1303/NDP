#!/bin/bash

no_of_nodes=144
linkspeed=10
cwnd=35
queuesize=12
pktsize=1500

endtime=0.05 #in sec
flowsfinish=2059200000 #stop experiment after these many flows have finished

shortflowsize=1 #in bytes
longflowsize=1 #in bytes

#TEST
#for ((i=0;i<=0;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i test/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i test/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate test/${i}.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate test/${i}.csv ndp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py test/${i}.csv.ndp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py test/${i}.csv.ndp ${shortflowsize} ${longflowsize}
#done

#PERM SHORT FLOWS
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i perm-shortflows-512/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i perm-shortflows-512/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate perm-shortflows-512/${i}.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate perm-shortflows-512/${i}.csv ndp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py perm-shortflows-512/${i}.csv.ndp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py perm-shortflows-512/${i}.csv.ndp ${shortflowsize} ${longflowsize}
#done

#PREDICTABILITY
#for i in 0.9 0.5 0;
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i predictability/${i}.csv.new -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i predictability/${i}.csv.new -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data_1.py ndp_debug ndp_rate predictability/${i}.csv.new ndp ${linkspeed} 511 0"
#    python process_data_1.py ndp_debug ndp_rate predictability/${i}.csv.new ndp ${linkspeed} 511 0
#    echo "Data cleaning: python extract_fct_tput.py predictability/${i}.csv.new.ndp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py predictability/${i}.csv.new.ndp ${shortflowsize} ${longflowsize}
#done

#INCAST
#for ((i=501;i<=501;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i incast-512/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -strat perm -numflowsfinish ${i}
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i incast-512/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -strat perm -numflowsfinish ${i} > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate incast-512/${i}.dat ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate incast-512/${i}.dat ndp ${linkspeed}
#done

#PERMUTATION
#for ((i=144;i<=144;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > ndp_debug -endtime ${endtime} -strat perm
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate permutation-144/${i}.dat ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate permutation-144/${i}.dat ndp ${linkspeed}
#done

#ALL-TO-ALL
for ((i=16;i<=16;i=i+1));
do
    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -strat perm
    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > ndp_debug -endtime ${endtime} -numflowsfinish ${flowsfinish} -strat perm
    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
    ../../parse_output ndp_logfile -ndp -show > ndp_rate
    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate all-to-all-144/${i}.dat ndp ${linkspeed}"
    python process_data.py ndp_debug ndp_rate all-to-all-144/${i}.dat ndp ${linkspeed}
    echo "Data cleaning: python extract_fct_tput.py all-to-all-144/${i}.dat.ndp ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py all-to-all-144/${i}.dat.ndp ${shortflowsize} ${longflowsize}
done

#DC Workloads
#for ((i=4;i>=0;i=i-1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate dc_workload_100G/log_flows_fattree_load-${i}.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate dc_workload_100G/log_flows_fattree_load-${i}.csv ndp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py dc_workload_100G/log_flows_fattree_load-${i}.csv.ndp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py dc_workload_100G/log_flows_fattree_load-${i}.csv.ndp ${shortflowsize} ${longflowsize}
#done

#Disaggregated Workloads
#for fname in bdb_nodes=512_flows=2000000_load=0.25.csv graphlab_nodes=512_flows=2000000_load=0.25.csv memcached_nodes=512_flows=2000000_load=0.25.csv terasort_hadoop_nodes=512_flows=2000000_load=0.25.csv terasort_spark_nodes=512_flows=2000000_load=0.25.csv ;
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate disaggregated_workload_100G/${fname} ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate disaggregated_workload_100G/${fname} ndp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py disaggregated_workload_100G/${fname}.ndp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py disaggregated_workload_100G/${fname}.ndp ${shortflowsize} ${longflowsize}
#done
#for fname in bdb_nodes=512_flows=2000000_load=0.10.csv graphlab_nodes=512_flows=2000000_load=0.10.csv memcached_nodes=512_flows=2000000_load=0.10.csv terasort_hadoop_nodes=512_flows=2000000_load=0.10.csv terasort_spark_nodes=512_flows=2000000_load=0.10.csv ;
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate disaggregated_workload_100G/${fname} ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate disaggregated_workload_100G/${fname} ndp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py disaggregated_workload_100G/${fname}.ndp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py disaggregated_workload_100G/${fname}.ndp ${shortflowsize} ${longflowsize}
#done
