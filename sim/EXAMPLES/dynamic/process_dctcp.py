import sys

LINK_SPEED = 10 #in Gbps

fct_filename = sys.argv[1]
rate_filename = sys.argv[2]
infilename = sys.argv[3]
outfilename = sys.argv[3]+".dctcp.out"

flows = {}
inp = open(infilename, "r")
for line in inp:
    tokens = line.split(',')
    flows[tokens[0]] = [tokens[1].strip(), tokens[2].strip(), tokens[3].strip(), tokens[4].strip()]

out = open(outfilename, "w")

fct_file = open(fct_filename, "r")
for line in fct_file:
    tokens = line.split()
    if (len(tokens) > 2 and tokens[2] == "finished"):
        ID = (tokens[1].split('-'))[1]
        assert(ID in flows)
        finish_time = float(tokens[4])*1000 - float(flows[ID][3])*1000000 # end-start in us
        flowsize = int(flows[ID][2])*8 #in bits
        rate = flowsize/(finish_time*1000) #in Gbps
        out.write(ID+","+flows[ID][0]+","+flows[ID][1]+","+flows[ID][2]+","+flows[ID][3]+","+str(finish_time)+ " us,"+str(rate)+ " Gbps")
        out.write("\n")
        del flows[ID]
fct_file.close()

rate_file = open(rate_filename, "r")
for line in rate_file:
    tokens = line.split()
    if (tokens[1] == "Mbps"):
        ID = (tokens[5].split('_'))[4]
        rate = float(tokens[0])/1000
        if ID in flows:
            out.write(ID+","+flows[ID][0]+","+flows[ID][1]+","+flows[ID][2]+","+flows[ID][3]+","+str(-1)+ " us,"+str(rate)+ " Gbps")
            out.write("\n")
            del flows[ID]
rate_file.close()

out.close()

