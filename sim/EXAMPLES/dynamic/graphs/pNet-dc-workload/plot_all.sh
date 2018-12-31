#!/bin/bash

#ALL-TO-ALL
echo "python scripts/plot_utilization.py all-to-all-144-aditya/"
python scripts/plot_utilization.py all-to-all-144-aditya/
echo "python scripts/plot_utilization.py all-to-all-144-dctcp/"
python scripts/plot_utilization.py all-to-all-144-dctcp/
echo "python scripts/plot_utilization.py all-to-all-144-datamining/"
python scripts/plot_utilization.py all-to-all-144-datamining/

echo "python scripts/plot_slowdown.py all-to-all-144-aditya/"
python scripts/plot_slowdown.py all-to-all-144-aditya/
echo "python scripts/plot_slowdown.py all-to-all-144-dctcp/"
python scripts/plot_slowdown.py all-to-all-144-dctcp/
echo "python scripts/plot_slowdown.py all-to-all-144-datamining/"
python scripts/plot_slowdown.py all-to-all-144-datamining/

#PERMUTATION
echo "python scripts/plot_utilization.py permutation-144-aditya/"
python scripts/plot_utilization.py permutation-144-aditya/
echo "python scripts/plot_utilization.py permutation-144-dctcp/"
python scripts/plot_utilization.py permutation-144-dctcp/
echo "python scripts/plot_utilization.py permutation-144-datamining/"
python scripts/plot_utilization.py permutation-144-datamining/

echo "python scripts/plot_slowdown.py permutation-144-aditya/"
python scripts/plot_slowdown.py permutation-144-aditya/
echo "python scripts/plot_slowdown.py permutation-144-dctcp/"
python scripts/plot_slowdown.py permutation-144-dctcp/
echo "python scripts/plot_slowdown.py permutation-144-datamining/"
python scripts/plot_slowdown.py permutation-144-datamining/
