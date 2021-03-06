import sys

filename = sys.argv[1]

f = open(filename, "r")

out = open("graphs/pNet-baseline-utilization/"+filename+".utilization", "w")

curr_time = -1
for line in f:
    tokens = line.split()
    if (len(tokens) >= 2 and tokens[0] == "*******************************"):
        t = float(tokens[3])/1000.0
        if (t != curr_time):
            out.write(str(t) + " " + tokens[18])
            out.write("\n")
            curr_time = t
f.close()
out.close()
