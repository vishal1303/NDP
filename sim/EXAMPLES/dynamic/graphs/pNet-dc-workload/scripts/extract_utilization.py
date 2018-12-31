import sys

directory = sys.argv[1]

protocols = ["pNet", "fastpass", "phost", "pfabric"]

out = open(directory+'/'+'all.utilization', "w")

count = 0
for protocol in protocols:
    f = open(directory+'/'+protocol+'.utilization', "r")
    line_num = 0
    for line in f:
        if count == 0:
            count = 1
            out.write(line.strip())
            out.write('\n')
        if line_num == 1:
            out.write(line.strip())
            out.write('\n')
        line_num += 1
    f.close()
out.close()
