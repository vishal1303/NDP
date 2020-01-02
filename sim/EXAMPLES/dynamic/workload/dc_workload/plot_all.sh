#!/bin/bash

declare -a workloads=("aditya" "dctcp")
declare -a protocols=("ndp" "dctcp" "dcqcn")

for workload in "${workloads[@]}"
do
    for protocol in "${protocols[@]}"
    do
        echo "python workload/dc_workload/plot/data_cleaning.py ${workload} ${protocol}"
        python workload/dc_workload/plot/data_cleaning.py ${workload} ${protocol}
        echo "python workload/dc_workload/plot/load_sensitivity.py ${workload} ${protocol}"
        python workload/dc_workload/plot/load_sensitivity.py ${workload} ${protocol}
        echo "python workload/dc_workload/plot/bandwidth_sensitivity.py ${workload} ${protocol}"
        python workload/dc_workload/plot/bandwidth_sensitivity.py ${workload} ${protocol}
        echo "python workload/dc_workload/plot/delay_sensitivity.py ${workload} ${protocol}"
        python workload/dc_workload/plot/delay_sensitivity.py ${workload} ${protocol}
    done
done
