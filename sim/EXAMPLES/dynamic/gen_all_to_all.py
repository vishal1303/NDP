import numpy
import random
import sys

NUM_OF_NODES = int(sys.argv[1])
CLIQUE_SIZE = int(sys.argv[2])

host_list = []

ID = 0
f = open('all-to-all-'+str(NUM_OF_NODES)+'/'+str(CLIQUE_SIZE)+'.dat', 'w')

#A = list(numpy.random.permutation(NUM_OF_NODES))
#print A
#for k in range(NUM_OF_NODES):
#    f.write(str(ID)+','+str(A[k])+','+str(A[(k+1)%len(A)])+','+'900000'+',0')
#    f.write('\n')
#    ID += 1

for i in range(CLIQUE_SIZE):
    while (True):
        t = random.randint(0,NUM_OF_NODES-1)
        assert(t != NUM_OF_NODES)
        if (not (t in host_list)):
            host_list.append(t)
            break

time = [0.0,0.0009,0.0018,0.0027,0.0036,0.0045,0.0054,0.0063,0.0072,0.0081,0.0090]
for k in range(10):
    for j in host_list:
        #time += 0.0000012
        for i in host_list:
            if j != i:
                f.write(str(ID)+','+str(i)+','+str(j)+','+'25000'+','+str(time[k]))
                f.write('\n')
                ID += 1
f.close()
