#!/bin/bash

dir="1:1"
linkspeed=10 #in Gbps
pktsize=1500 #in bytes
propagationdelay_per_hop=200 #200 ns per hop
shortflow=102400 #in bytes
longflow=1000000 #in bytes

echo "python data_cleaning.py ${dir}/all-to-all-144-aditya/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}"
python data_cleaning.py ${dir}/all-to-all-144-aditya/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}
echo "python slowdown.py ${dir}/all-to-all-144-aditya/"
python slowdown.py ${dir}/all-to-all-144-aditya/
echo "python utilization.py ${dir}/all-to-all-144-aditya"
python utilization.py ${dir}/all-to-all-144-aditya

echo "python data_cleaning.py ${dir}/all-to-all-144-dctcp/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}"
python data_cleaning.py ${dir}/all-to-all-144-dctcp/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}
echo "python slowdown.py ${dir}/all-to-all-144-dctcp/"
python slowdown.py ${dir}/all-to-all-144-dctcp/
echo "python utilization.py ${dir}/all-to-all-144-dctcp"
python utilization.py ${dir}/all-to-all-144-dctcp

echo "python data_cleaning.py ${dir}/all-to-all-144-datamining/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}"
python data_cleaning.py ${dir}/all-to-all-144-datamining/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}
echo "python slowdown.py ${dir}/all-to-all-144-datamining/"
python slowdown.py ${dir}/all-to-all-144-datamining/
echo "python utilization.py ${dir}/all-to-all-144-datamining"
python utilization.py ${dir}/all-to-all-144-datamining

#echo "python data_cleaning.py permutation-144-aditya/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}"
#python data_cleaning.py permutation-144-aditya/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}
#echo "python slowdown.py permutation-144-aditya/"
#python slowdown.py permutation-144-aditya/
#echo "python utilization.py permutation-144-aditya"
#python utilization.py permutation-144-aditya
#
#echo "python data_cleaning.py permutation-144-dctcp/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}"
#python data_cleaning.py permutation-144-dctcp/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}
#echo "python slowdown.py permutation-144-dctcp/"
#python slowdown.py permutation-144-dctcp/
#echo "python utilization.py permutation-144-dctcp"
#python utilization.py permutation-144-dctcp
#
#echo "python data_cleaning.py permutation-144-datamining/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}"
#python data_cleaning.py permutation-144-datamining/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay_per_hop} ${linkspeed}
#echo "python slowdown.py permutation-144-datamining/"
#python slowdown.py permutation-144-datamining/
#echo "python utilization.py permutation-144-datamining"
#python utilization.py permutation-144-datamining
