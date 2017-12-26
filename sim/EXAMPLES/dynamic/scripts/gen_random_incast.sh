#!/bin/bash

for (( i = 1; i < 512; i = i + 25 )); do python scripts/gen_random_incast.py 512 $i; done
