#!/bin/bash

#ALL-TO-ALL
echo "python scripts/extract_utilization.py all-to-all-144-aditya/"
python scripts/extract_utilization.py all-to-all-144-aditya/
echo "python scripts/extract_utilization.py all-to-all-144-dctcp/"
python scripts/extract_utilization.py all-to-all-144-dctcp/
echo "python scripts/extract_utilization.py all-to-all-144-datamining/"
python scripts/extract_utilization.py all-to-all-144-datamining/

echo "python scripts/extract_slowdown.py all-to-all-144-aditya/"
python scripts/extract_slowdown.py all-to-all-144-aditya/
echo "python scripts/extract_slowdown.py all-to-all-144-dctcp/"
python scripts/extract_slowdown.py all-to-all-144-dctcp/
echo "python scripts/extract_slowdown.py all-to-all-144-datamining/"
python scripts/extract_slowdown.py all-to-all-144-datamining/

#PERMUTATION
echo "python scripts/extract_utilization.py permutation-144-aditya/"
python scripts/extract_utilization.py permutation-144-aditya/
echo "python scripts/extract_utilization.py permutation-144-dctcp/"
python scripts/extract_utilization.py permutation-144-dctcp/
echo "python scripts/extract_utilization.py permutation-144-datamining/"
python scripts/extract_utilization.py permutation-144-datamining/

echo "python scripts/extract_slowdown.py permutation-144-aditya/"
python scripts/extract_slowdown.py permutation-144-aditya/
echo "python scripts/extract_slowdown.py permutation-144-dctcp/"
python scripts/extract_slowdown.py permutation-144-dctcp/
echo "python scripts/extract_slowdown.py permutation-144-datamining/"
python scripts/extract_slowdown.py permutation-144-datamining/
