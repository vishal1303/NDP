import numpy
import sys

NUM_OF_NODES = int(sys.argv[1])

f = open('incast-'+str(NUM_OF_NODES)+'/'+str(NUM_OF_NODES)+'.dat', 'w')
ID = 0
time = -0.011
for i in range(5):
    time += 0.011
    for k in range(NUM_OF_NODES-1):
        f.write(str(ID)+','+str(k)+','+str(NUM_OF_NODES-1)+','+'15000'+','+str(time))
        f.write('\n')
        ID += 1
f.close()
