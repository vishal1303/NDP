#!/bin/sh

cwnd=35
queuesize=100
pktsize=1500

endtime=0.1 #in sec
flowsfinish=10 #stop experiment after these many flows have finished

#TEST
for ((i=0;i<=0;i=i+1));
do
    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile_${i} -i test/${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish}
    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile_${i} -i test/${i}.csv -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime} -numflowsfinish ${flowsfinish} > dctcp_fct_${i}
    echo "Parsing the logfile: ../../parse_output dctcp_logfile_${i} -dctcp -show > dctcp_rate_${i}"
    ../../parse_output dctcp_logfile_${i} -dctcp -show > dctcp_rate_${i}
    echo "Extracting FCT and Rates: python process_dctcp.py dctcp_fct_${i} dctcp_rate_${i} test/${i}.csv"
    python process_dctcp.py dctcp_fct_${i} dctcp_rate_${i} test/${i}.csv
done

#INCAST
#for ((i=201;i<=201;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile_${i} -i incast-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile_${i} -i incast-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > dctcp_fct_${i}
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile_${i} -dctcp -show > dctcp_rate_${i}"
#    ../../parse_output dctcp_logfile_${i} -dctcp -show > dctcp_rate_${i}
#    echo "Extracting FCT and Rates: python process_dctcp.py dctcp_fct_${i} dctcp_rate_${i} incast-512/${i}.dat"
#    python process_dctcp.py dctcp_fct_${i} dctcp_rate_${i} incast-512/${i}.dat
#done

#PERMUTATION
#for ((i=512;i<=512;i=i+1));
#do
#    echo ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile_${i} -i permutation-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} -endtime ${endtime}
#    ../../datacenter/htsim_dctcp_dynamic -o dctcp_logfile_${i} -i permutation-512/${i}.dat -nodes 65536 -cwnd ${cwnd} -pktsize ${pktsize} -queuesize ${queuesize} > dctcp_fct_${i} -endtime ${endtime}
#    echo "Parsing the logfile: ../../parse_output dctcp_logfile_${i} -dctcp -show > dctcp_rate_${i}"
#    ../../parse_output dctcp_logfile_${i} -dctcp -show > dctcp_rate_${i}
#    echo "Extracting FCT and Rates: python process_dctcp.py dctcp_fct_${i} dctcp_rate_${i} permutation-512/${i}.dat"
#    python process_dctcp.py dctcp_fct_${i} dctcp_rate_${i} permutation-512/${i}.dat
#done
