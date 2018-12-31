#!/bin/bash

declare -a traffic=("all-to-all-144" "permutation-144")
declare -a workload=("aditya" "dctcp" "datamining")

for i in "${traffic[@]}"
do
    for j in "${workload[@]}"
    do
        echo "scp vishal@128.84.155.243:~/git/pNet/simulation/experiments/$i-$j/pNet* $i-$j/"
        scp vishal@128.84.155.243:~/git/pNet/simulation/experiments/$i-$j/pNet* $i-$j/
    done
done

declare -a protocols=("fastpass" "phost" "pfabric")

for i in "${traffic[@]}"
do
    for j in "${workload[@]}"
    do
        for k in "${protocols[@]}"
        do
            echo "scp vishal@compute19.fractus.cs.cornell.edu:~/simulator/py/$i-$j/$k.* $i-$j/"
            scp vishal@compute19.fractus.cs.cornell.edu:~/simulator/py/$i-$j/$k.* $i-$j/
        done
    done
done
