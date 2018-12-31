import sys

directory = sys.argv[1]

protocols = ["pNet", "fastpass", "phost", "pfabric"]


for i in ["1", "2", "3", "4", "5", "6", "7", "8"]:
    out = open(directory+'/'+i+'.slowdown.mean', "w")
    num = int(i)

    count = 0
    for protocol in protocols:
        f = open(directory+'/'+protocol+'.slowdown.mean', "r")
        line_num = 0
        for line in f:
            if count == 0:
                count = 1
                out.write(line.strip())
                out.write('\n')
            if line_num == num:
                out.write(protocol + " ")
                tokens = line.split()
                for j in range(1, len(tokens)):
                    out.write(tokens[j] + " ")
                out.write('\n')
            line_num += 1
        f.close()
    out.close()
