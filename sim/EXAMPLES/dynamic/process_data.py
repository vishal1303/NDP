import sys

fct_filename = sys.argv[1]
rate_filename = sys.argv[2]
infilename = sys.argv[3]
outfilename = sys.argv[3]+"."+sys.argv[4]

LINK_SPEED = float(sys.argv[5])

flows = {}
inp = open(infilename, "r")
for line in inp:
    tokens = line.split(',')
    flows[int(tokens[0].strip())] = [int(tokens[1].strip()), int(tokens[2].strip()), int(tokens[3].strip()), float(tokens[4].strip())]

out = open(outfilename, "w")

fct_file = open(fct_filename, "r")
for line in fct_file:
    tokens = line.split()
    if (len(tokens) > 2 and tokens[2] == "finished"):
        ID = int((tokens[1].split('-'))[1])
        #assert(ID in flows)
        if (ID in flows):
            finish_time = float(tokens[4])*1000 - float(flows[ID][3])*1000000 # end-start in us
            flowsize = int(flows[ID][2])*8 #in bits
            rate = flowsize/(finish_time*1000) #in Gbps
            out.write(str(ID)+","+str(flows[ID][0])+","+str(flows[ID][1])+","+str(flows[ID][2])+","+str(flows[ID][3])+","+str(finish_time)+ " us,"+str(rate)+ " Gbps")
            out.write("\n")
            del flows[ID]
fct_file.close()

rate_file = open(rate_filename, "r")
for line in rate_file:
    tokens = line.split()
    if (tokens[1] == "Mbps"):
        ID = int((tokens[5].split('_'))[4])
        rate = float(tokens[0])/1000
        #assert(rate <= LINK_SPEED)
        if ID in flows:
            out.write(str(ID)+","+str(flows[ID][0])+","+str(flows[ID][1])+","+str(flows[ID][2])+","+str(flows[ID][3])+","+str(-1)+ " us,"+str(rate)+ " Gbps")
            out.write("\n")
            del flows[ID]
rate_file.close()

out.close()

