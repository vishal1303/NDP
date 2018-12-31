import numpy
import sys

NUM_OF_NODES = int(sys.argv[1])

A = list(numpy.random.permutation(NUM_OF_NODES))
print A
f = open('perm-incast-'+str(NUM_OF_NODES)+'/'+str(NUM_OF_NODES)+'.dat', 'w')
ID = 0
#for k in range(NUM_OF_NODES):
#    f.write(str(ID)+','+str(A[k])+','+str(A[(k+1)%len(A)])+','+'1000000000'+',0')
#    f.write('\n')
#    ID += 1
#for k in range(NUM_OF_NODES/2):
#    f.write(str(ID)+','+str(k)+','+str(NUM_OF_NODES-1)+','+'1000000000'+',0')
#    f.write('\n')
#    ID += 1
#for k in xrange(NUM_OF_NODES/2,NUM_OF_NODES,1):
#    f.write(str(ID)+','+str(k)+','+str(0)+','+'1000000000'+',0')
#    f.write('\n')
#    ID += 1

for i,j in zip([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15], [128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143]):
    f.write(str(ID)+','+str(i)+','+str(j)+','+'1000000000'+',0')
    f.write('\n')
    ID+=1
for k in xrange(16,128,1):
    f.write(str(ID)+','+str(k)+','+str(NUM_OF_NODES-1)+','+'1000000000'+',0.002')
    f.write('\n')
    ID += 1

f.close()
