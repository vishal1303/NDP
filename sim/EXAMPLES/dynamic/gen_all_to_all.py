import numpy
import random
import sys

NUM_OF_NODES = int(sys.argv[1])
CLIQUE_SIZE = int(sys.argv[2])

host_list = []

ID = 0
f = open('all-to-all-'+str(NUM_OF_NODES)+'/'+str(CLIQUE_SIZE)+'.dat', 'w')

for i in range(CLIQUE_SIZE):
    while (True):
        t = random.randint(0,NUM_OF_NODES-1)
        assert(t != NUM_OF_NODES)
        if (not (t in host_list)):
            host_list.append(t)
            break

time = -0.008
for k in range(1):
    time += 0.008
    for j in host_list:
        #time += 0.0000012
        for i in host_list:
            if j != i:
                f.write(str(ID)+','+str(i)+','+str(j)+','+'20000'+','+str(time))
                f.write('\n')
                ID += 1
f.close()
