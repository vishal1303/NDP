import sys
import numpy as np

filename = sys.argv[1]
short_flow = int(sys.argv[2]) #in bytes
long_flow = int(sys.argv[3]) #in bytes

inp = open(filename, "r")

sorted_fct = []
sorted_tput = []

for line in inp:
    tokens = line.split(',')
    flowsize = int(tokens[3])
    if (flowsize <= short_flow):
        if (float((tokens[5].split())[0]) != -1):
            sorted_fct.append(float((tokens[5].split())[0]))
    elif (flowsize >= long_flow):
        if (float((tokens[6].split())[0]) != 0):
            sorted_tput.append(float((tokens[6].split())[0]))
inp.close()

if (len(sorted_fct) == 0):
    sorted_fct.append(-1)
if (len(sorted_tput) == 0):
    sorted_tput.append(-1)

sorted_fct.sort()
f = np.array(sorted_fct)
sorted_tput.sort()
t = np.array(sorted_tput)

fct = open(filename+".fct", "w")
fct_cdf = open(filename+".fct.cdf", "w")
tput = open(filename+".tput", "w")
tput_cdf = open(filename+".tput.cdf", "w")

for i in sorted_fct:
    fct_cdf.write(str(i))
    fct_cdf.write("\n")
fct_cdf.close()

for i in sorted_tput:
    tput_cdf.write(str(i))
    tput_cdf.write("\n")
tput_cdf.close()

for i in xrange(0,101,5):
    fct.write(str(i) + " " + str(np.percentile(f,i)))
    fct.write("\n")
fct.write("99 " + str(np.percentile(f,99)) + "\n")
fct.write("99.9 " + str(np.percentile(f,99.9)) + "\n")
fct.write("avg " + str(sum(sorted_fct)/len(sorted_fct)))
fct.close()

for i in xrange(0,101,5):
    tput.write(str(i) + " " + str(np.percentile(t,i)))
    tput.write("\n")
tput.write("avg " + str(sum(sorted_tput)/len(sorted_tput)))
tput.close()
