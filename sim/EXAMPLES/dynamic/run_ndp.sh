#!/bin/bash

no_of_nodes=144
linkspeed=10
cwnd=35
queuesize=12
pktsize=1500

endtime=0.05 #in sec
flowsfinish=2059200000 #stop experiment after these many flows have finished
flowsstart=1000000 #stop experiment after these many flows have started

shortflowsize=1 #in bytes
longflowsize=1 #in bytes

propagationdelay=800 #200ns per hop

#BAD-CASES
for i in PERMUTATION DCTCP DCQCN NDP ;
do
    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i bad-cases-ndp/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm
    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i bad-cases-ndp/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm > ndp_debug
    cp ndp_debug bad-cases-ndp/${i}.debug
    #echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
    #../../parse_output ndp_logfile -ndp -show > ndp_rate
    #echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate incast-144/${i}.dat ndp ${linkspeed}"
    #python process_data.py ndp_debug ndp_rate incast-144/${i}.dat ndp ${linkspeed}
done

#for ((i=16;i<=16;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > ndp_debug -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate all-to-all-144/${i}.dat ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate all-to-all-144/${i}.dat ndp ${linkspeed}
#    echo "Data cleaning: python data_cleaning.py all-to-all-144/${i}.dat.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}"
#    python data_cleaning.py all-to-all-144/${i}.dat.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}
#done

#TEST
#for ((i=0;i<=0;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i test/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i test/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate test/${i}.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate test/${i}.csv ndp ${linkspeed}
#    echo "Data cleaning: python data_cleaning.py test/${i}.csv.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}"
#    python data_cleaning.py test/${i}.csv.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}
#done

#PERM SHORT FLOWS
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i perm-shortflows-512/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i perm-shortflows-512/${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate perm-shortflows-512/${i}.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate perm-shortflows-512/${i}.csv ndp ${linkspeed}
#    echo "Data cleaning: python data_cleaning.py perm-shortflows-512/${i}.csv.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}"
#    python data_cleaning.py perm-shortflows-512/${i}.csv.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}
#done

#PREDICTABILITY
#for i in 0.9 0.5 0;
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i predictability/${i}.csv.new -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i predictability/${i}.csv.new -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data_1.py ndp_debug ndp_rate predictability/${i}.csv.new ndp ${linkspeed} 511 0"
#    python process_data_1.py ndp_debug ndp_rate predictability/${i}.csv.new ndp ${linkspeed} 511 0
#    echo "Data cleaning: python data_cleaning.py predictability/${i}.csv.new.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}"
#    python data_cleaning.py predictability/${i}.csv.new.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}
#done

#INCAST
#for ((i=501;i<=501;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i incast-512/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} --numflowsstart ${flowsstart} -strat perm -numflowsfinish ${i}
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i incast-512/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} --numflowsstart ${flowsstart} -strat perm -numflowsfinish ${i} > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate incast-512/${i}.dat ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate incast-512/${i}.dat ndp ${linkspeed}
#done

#PERMUTATION
#for ((i=144;i<=144;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} --numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > ndp_debug -endtime ${endtime} --numflowsstart ${flowsstart} -strat perm
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate permutation-144/${i}.dat ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate permutation-144/${i}.dat ndp ${linkspeed}
#done

#ALL-TO-ALL
#for ((i=16;i<=16;i=i+1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144/${i}.dat -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > ndp_debug -endtime ${endtime} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate all-to-all-144/${i}.dat ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate all-to-all-144/${i}.dat ndp ${linkspeed}
#    echo "Data cleaning: python data_cleaning.py all-to-all-144/${i}.dat.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}"
#    python data_cleaning.py all-to-all-144/${i}.dat.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}
#done

#DC Workloads
#for ((i=4;i>=0;i=i-1));
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i dc_workload_100G/log_flows_fattree_load-${i}.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate dc_workload_100G/log_flows_fattree_load-${i}.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate dc_workload_100G/log_flows_fattree_load-${i}.csv ndp ${linkspeed}
#    echo "Data cleaning: python data_cleaning.py dc_workload_100G/log_flows_fattree_load-${i}.csv.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}"
#    python data_cleaning.py dc_workload_100G/log_flows_fattree_load-${i}.csv.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}
#done

#Disaggregated Workloads
#for fname in bdb_nodes=512_flows=2000000_load=0.25.csv graphlab_nodes=512_flows=2000000_load=0.25.csv memcached_nodes=512_flows=2000000_load=0.25.csv terasort_hadoop_nodes=512_flows=2000000_load=0.25.csv terasort_spark_nodes=512_flows=2000000_load=0.25.csv ;
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} --numflowsstart ${flowsstart} -strat perm > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate disaggregated_workload_100G/${fname} ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate disaggregated_workload_100G/${fname} ndp ${linkspeed}
#    echo "Data cleaning: python data_cleaning.py disaggregated_workload_100G/${fname}.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}"
#    python data_cleaning.py disaggregated_workload_100G/${fname}.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}
#done
#for fname in bdb_nodes=512_flows=2000000_load=0.10.csv graphlab_nodes=512_flows=2000000_load=0.10.csv memcached_nodes=512_flows=2000000_load=0.10.csv terasort_hadoop_nodes=512_flows=2000000_load=0.10.csv terasort_spark_nodes=512_flows=2000000_load=0.10.csv ;
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish}
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i disaggregated_workload_100G/${fname} -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} > ndp_debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate disaggregated_workload_100G/${fname} ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate disaggregated_workload_100G/${fname} ndp ${linkspeed}
#    echo "Data cleaning: python data_cleaning.py disaggregated_workload_100G/${fname}.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}"
#    python data_cleaning.py disaggregated_workload_100G/${fname}.ndp ${shortflowsize} ${longflowsize} ${pktsize} ${propagationdelay} ${linkspeed}
#done

#ALL-TO-ALL-144-ADITYA
#for i in 20 40 60 80
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144-aditya/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144-aditya/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm > ndp_debug
#    cp ndp_debug all-to-all-144-aditya/trace-${i}.txt.csv.ndp.debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate all-to-all-144-aditya/trace-${i}.txt.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate all-to-all-144-aditya/trace-${i}.txt.csv ndp ${linkspeed}
#done
#
##ALL-TO-ALL-144-DCTCP
#for i in 20 40 60 80
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144-dctcp/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144-dctcp/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm > ndp_debug
#    cp ndp_debug all-to-all-144-dctcp/trace-${i}.txt.csv.ndp.debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate all-to-all-144-dctcp/trace-${i}.txt.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate all-to-all-144-dctcp/trace-${i}.txt.csv ndp ${linkspeed}
#done
#
##ALL-TO-ALL-144-DATAMINING
#for i in 20 40 60 80
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144-datamining/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i all-to-all-144-datamining/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm > ndp_debug
#    cp ndp_debug all-to-all-144-datamining/trace-${i}.txt.csv.ndp.debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate all-to-all-144-datamining/trace-${i}.txt.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate all-to-all-144-datamining/trace-${i}.txt.csv ndp ${linkspeed}
#done
#
##permutation-144-ADITYA
#for i in 20 40 60 80
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144-aditya/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144-aditya/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm > ndp_debug
#    cp ndp_debug permutation-144-aditya/trace-${i}.txt.csv.ndp.debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate permutation-144-aditya/trace-${i}.txt.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate permutation-144-aditya/trace-${i}.txt.csv ndp ${linkspeed}
#done
#
##permutation-144-DCTCP
#for i in 20 40 60 80
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144-dctcp/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144-dctcp/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm > ndp_debug
#    cp ndp_debug permutation-144-dctcp/trace-${i}.txt.csv.ndp.debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate permutation-144-dctcp/trace-${i}.txt.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate permutation-144-dctcp/trace-${i}.txt.csv ndp ${linkspeed}
#done
#
##permutation-144-DATAMINING
#for i in 20 40 60 80
#do
#    echo ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144-datamining/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm
#    ../../datacenter/htsim_ndp_dynamic -o ndp_logfile -i permutation-144-datamining/trace-${i}.txt.csv -nodes ${no_of_nodes} -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -numflowsfinish ${flowsfinish} -numflowsstart ${flowsstart} -strat perm > ndp_debug
#    cp ndp_debug permutation-144-datamining/trace-${i}.txt.csv.ndp.debug
#    echo "Parsing the logfile: ../../parse_output ndp_logfile -ndp -show > ndp_rate"
#    ../../parse_output ndp_logfile -ndp -show > ndp_rate
#    echo "Extracting FCT and Rates: python process_data.py ndp_debug ndp_rate permutation-144-datamining/trace-${i}.txt.csv ndp ${linkspeed}"
#    python process_data.py ndp_debug ndp_rate permutation-144-datamining/trace-${i}.txt.csv ndp ${linkspeed}
#done
