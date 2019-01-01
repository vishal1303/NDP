#!/bin/bash

no_of_nodes=144
linkspeed=10
cwnd=35
queuesize=100
pktsize=1500

endtime=0.05 #in sec
flowsfinish=1000000 #stop experiment after these many flows have finished
flowsstart=100000 #stop experiment after these many flows have started

shortflowsize=102400 #in bytes
longflowsize=1000000 #in bytes

#TEST
#for ((i=0;i<=0;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i test/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i test/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate test/${i}.csv dctcp ${linkspeed}"
#    python process_data.py dctcp_debug dctcp_rate test/${i}.csv dctcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py test/${i}.csv.dctcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py test/${i}.csv.dctcp ${shortflowsize} ${longflowsize}
#done

#PERM SHORT FLOWS
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i perm-shortflows-512/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i perm-shortflows-512/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate perm-shortflows-512/${i}.csv dctcp ${linkspeed}"
#    python process_data.py dctcp_debug dctcp_rate perm-shortflows-512/${i}.csv dctcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py perm-shortflows-512/${i}.csv.dctcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py perm-shortflows-512/${i}.csv.dctcp ${shortflowsize} ${longflowsize}
#done

#PREDICTABILITY
#`for i in 0.9 0.5 0;
#`do
#`    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i predictability/${i}.csv.new -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
#`    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i predictability/${i}.csv.new -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
#`    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#`    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#`    echo "Extracting FCT and Rates: python process_data_1.py dctcp_debug dctcp_rate predictability/${i}.csv.new dctcp ${linkspeed} 511 0"
#`    python process_data_1.py dctcp_debug dctcp_rate predictability/${i}.csv.new dctcp ${linkspeed} 511 0
#`    echo "Data cleaning: python extract_fct_tput.py predictability/${i}.csv.new.dctcp ${shortflowsize} ${longflowsize}"
#`    python extract_fct_tput.py predictability/${i}.csv.new.dctcp ${shortflowsize} ${longflowsize}
#`done

#INCAST
#for ((i=144;i<=144;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i incast-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i incast-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate incast-144/${i}.dat dctcp ${linkspeed}"
#    python process_data.py dctcp_debug dctcp_rate incast-144/${i}.dat dctcp ${linkspeed}
#done

#PERMUTATION
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-512/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-512/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > dctcp_debug -endtime ${endtime}
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate permutation-512/${i}.dat dctcp ${linkspeed}"
#    python process_data.py dctcp_debug dctcp_rate permutation-512/${i}.dat dctcp ${linkspeed}
#done

#DC Workloads
#for ((i=0;i<=4;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate dc_workload_100G/log_flows_fattree_load-${i}.csv dctcp ${linkspeed}"
#    python process_data.py dctcp_debug dctcp_rate dc_workload_100G/log_flows_fattree_load-${i}.csv dctcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py dc_workload_100G/log_flows_fattree_load-${i}.csv.dctcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py dc_workload_100G/log_flows_fattree_load-${i}.csv.dctcp ${shortflowsize} ${longflowsize}
#done

#Disaggregated Workloads
#for fname in bdb_nodes=512_flows=2000000_load=0.25.csv graphlab_nodes=512_flows=2000000_load=0.25.csv memcached_nodes=512_flows=2000000_load=0.25.csv terasort_hadoop_nodes=512_flows=2000000_load=0.25.csv terasort_spark_nodes=512_flows=2000000_load=0.25.csv ;
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate disaggregated_workload_100G/${fname} dctcp ${linkspeed}"
#    python process_data.py dctcp_debug dctcp_rate disaggregated_workload_100G/${fname} dctcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py disaggregated_workload_100G/${fname}.dctcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py disaggregated_workload_100G/${fname}.dctcp ${shortflowsize} ${longflowsize}
#done
#for fname in bdb_nodes=512_flows=2000000_load=0.10.csv graphlab_nodes=512_flows=2000000_load=0.10.csv memcached_nodes=512_flows=2000000_load=0.10.csv terasort_hadoop_nodes=512_flows=2000000_load=0.10.csv terasort_spark_nodes=512_flows=2000000_load=0.10.csv ;
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
#    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
#    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate disaggregated_workload_100G/${fname} dctcp ${linkspeed}"
#    python process_data.py dctcp_debug dctcp_rate disaggregated_workload_100G/${fname} dctcp ${linkspeed}
#    echo "Data cleaning: python extract_fct_tput.py disaggregated_workload_100G/${fname}.dctcp ${shortflowsize} ${longflowsize}"
#    python extract_fct_tput.py disaggregated_workload_100G/${fname}.dctcp ${shortflowsize} ${longflowsize}
#done

#ALL-TO-ALL-144-ADITYA
for i in 20 40 60 80
do
    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i all-to-all-144-aditya/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i all-to-all-144-aditya/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
    cp dctcp_debug all-to-all-144-aditya/trace-${i}.txt.csv.dctcp.debug
    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate all-to-all-144-aditya/trace-${i}.txt.csv dctcp ${linkspeed}"
    python process_data.py dctcp_debug dctcp_rate all-to-all-144-aditya/trace-${i}.txt.csv dctcp ${linkspeed}
    echo "Data cleaning: python extract_fct_tput.py all-to-all-144-aditya/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py all-to-all-144-aditya/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}
done

#ALL-TO-ALL-144-dctcp
for i in 20 40 60 80
do
    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i all-to-all-144-dctcp/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i all-to-all-144-dctcp/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
    cp dctcp_debug all-to-all-144-dctcp/trace-${i}.txt.csv.dctcp.debug
    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate all-to-all-144-dctcp/trace-${i}.txt.csv dctcp ${linkspeed}"
    python process_data.py dctcp_debug dctcp_rate all-to-all-144-dctcp/trace-${i}.txt.csv dctcp ${linkspeed}
    echo "Data cleaning: python extract_fct_tput.py all-to-all-144-dctcp/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py all-to-all-144-dctcp/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}
done

#ALL-TO-ALL-144-datamining
for i in 20 40 60 80
do
    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i all-to-all-144-datamining/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i all-to-all-144-datamining/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
    cp dctcp_debug all-to-all-144-datamining/trace-${i}.txt.csv.dctcp.debug
    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate all-to-all-144-datamining/trace-${i}.txt.csv dctcp ${linkspeed}"
    python process_data.py dctcp_debug dctcp_rate all-to-all-144-datamining/trace-${i}.txt.csv dctcp ${linkspeed}
    echo "Data cleaning: python extract_fct_tput.py all-to-all-144-datamining/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py all-to-all-144-datamining/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}
done

#permutation-144-ADITYA
for i in 20 40 60 80
do
    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-144-aditya/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-144-aditya/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
    cp dctcp_debug permutation-144-aditya/trace-${i}.txt.csv.dctcp.debug
    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate permutation-144-aditya/trace-${i}.txt.csv dctcp ${linkspeed}"
    python process_data.py dctcp_debug dctcp_rate permutation-144-aditya/trace-${i}.txt.csv dctcp ${linkspeed}
    echo "Data cleaning: python extract_fct_tput.py permutation-144-aditya/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py permutation-144-aditya/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}
done

#permutation-144-dctcp
for i in 20 40 60 80
do
    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-144-dctcp/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-144-dctcp/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
    cp dctcp_debug permutation-144-dctcp/trace-${i}.txt.csv.dctcp.debug
    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate permutation-144-dctcp/trace-${i}.txt.csv dctcp ${linkspeed}"
    python process_data.py dctcp_debug dctcp_rate permutation-144-dctcp/trace-${i}.txt.csv dctcp ${linkspeed}
    echo "Data cleaning: python extract_fct_tput.py permutation-144-dctcp/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py permutation-144-dctcp/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}
done

#permutation-144-datamining
for i in 20 40 60 80
do
    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-144-datamining/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart}
    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile -i permutation-144-datamining/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} > dctcp_debug
    cp dctcp_debug permutation-144-datamining/trace-${i}.txt.csv.dctcp.debug
    echo "Parsing the logfile: ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate"
    ../../parse_output dctcp_logfile -dctcp -show > dctcp_rate
    echo "Extracting FCT and Rates: python process_data.py dctcp_debug dctcp_rate permutation-144-datamining/trace-${i}.txt.csv dctcp ${linkspeed}"
    python process_data.py dctcp_debug dctcp_rate permutation-144-datamining/trace-${i}.txt.csv dctcp ${linkspeed}
    echo "Data cleaning: python extract_fct_tput.py permutation-144-datamining/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}"
    python extract_fct_tput.py permutation-144-datamining/trace-${i}.txt.csv.dctcp ${shortflowsize} ${longflowsize}
done
