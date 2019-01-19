#!/bin/bash

linkspeed=10 #in Gbps
pktsize=1500 #in bytes
propagationdelay=800 #200 ns per hop
shortflow=102400 #in bytes
longflow=1000000 #in bytes

echo "python data_cleaning.py all-to-all-144-aditya/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}"
python data_cleaning.py all-to-all-144-aditya/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}
echo "python slowdown.py all-to-all-144-aditya/"
python slowdown.py all-to-all-144-aditya/
echo "python utilization.py all-to-all-144-aditya"
python utilization.py all-to-all-144-aditya

echo "python data_cleaning.py all-to-all-144-dctcp/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}"
python data_cleaning.py all-to-all-144-dctcp/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}
echo "python slowdown.py all-to-all-144-dctcp/"
python slowdown.py all-to-all-144-dctcp/
echo "python utilization.py all-to-all-144-dctcp"
python utilization.py all-to-all-144-dctcp

echo "python data_cleaning.py all-to-all-144-datamining/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}"
python data_cleaning.py all-to-all-144-datamining/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}
echo "python slowdown.py all-to-all-144-datamining/"
python slowdown.py all-to-all-144-datamining/
echo "python utilization.py all-to-all-144-datamining"
python utilization.py all-to-all-144-datamining

echo "python data_cleaning.py permutation-144-aditya/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}"
python data_cleaning.py permutation-144-aditya/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}
echo "python slowdown.py permutation-144-aditya/"
python slowdown.py permutation-144-aditya/
echo "python utilization.py permutation-144-aditya"
python utilization.py permutation-144-aditya

echo "python data_cleaning.py permutation-144-dctcp/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}"
python data_cleaning.py permutation-144-dctcp/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}
echo "python slowdown.py permutation-144-dctcp/"
python slowdown.py permutation-144-dctcp/
echo "python utilization.py permutation-144-dctcp"
python utilization.py permutation-144-dctcp

echo "python data_cleaning.py permutation-144-datamining/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}"
python data_cleaning.py permutation-144-datamining/ ${shortflow} ${longflow} ${pktsize} ${propagationdelay} ${linkspeed}
echo "python slowdown.py permutation-144-datamining/"
python slowdown.py permutation-144-datamining/
echo "python utilization.py permutation-144-datamining"
python utilization.py permutation-144-datamining
