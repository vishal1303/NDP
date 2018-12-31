import numpy
import sys

NUM_OF_NODES = int(sys.argv[1])

A = list(numpy.random.permutation(NUM_OF_NODES))
print A
f = open('permutation-'+str(NUM_OF_NODES)+'/'+str(NUM_OF_NODES)+'.dat', 'w')
ID = 0
for k in range(NUM_OF_NODES):
    f.write(str(ID)+','+str(A[k])+','+str(A[(k+1)%len(A)])+','+'1000000000'+',0')
    f.write('\n')
    ID += 1
f.close()
