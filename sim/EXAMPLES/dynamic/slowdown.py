import sys
import os.path

dirname = sys.argv[1] # e.g. experiments/all-to-all-144

protocols = ['ndp', 'dctcp', 'dcqcn']

for protocol in protocols:
    f = [None for i in range(4)]
    d = {0:20, 1:40, 2:60, 3:80}
    for j in ["bin.mean", "bin.99", "all.mean", "all.99"]:
        file_not_exists = 0
        for i in range(4):
            filename = dirname+"/"+protocol+"-"+str(d[i])+".txt.out.slowdown."+j
            if (not os.path.isfile(filename)):
                print "Error: " + filename + " does not exist!"
                file_not_exists = 1
            else:
                f[i] = open(filename, "r")

        if file_not_exists:
            continue
        out = open(dirname+"/"+protocol+".slowdown."+j, "w")

        if (j == "all.mean" or j == "all.99"):
            for k in range(4):
                for line in f[k]:
                    out.write(str(d[k])+','+line.strip())
                    out.write('\n')
            continue

        slowdown = [["0" for j in range(4)] for i in range(4)]

        for i in range(4):
            for j in range(4):
                for line in f[j]:
                    tokens = line.split(",")
                    slowdown[i][j] = str(tokens[1])
                    break

        for j in range(4):
            f[j].close()

        out.write("arch " + "0.2 " + "0.4 " + "0.6 " + "0.8 ")
        out.write("\n")
        out.write("<=10KB ")
        for i in range(len(slowdown[0])):
            out.write(str.strip(slowdown[0][i]) + " ")
        out.write("\n")
        out.write("10KB-100KB ")
        for i in range(len(slowdown[1])):
            out.write(str.strip(slowdown[1][i]) + " ")
        out.write("\n")
        out.write("100KB-1MB ")
        for i in range(len(slowdown[2])):
            out.write(str.strip(slowdown[2][i]) + " ")
        out.write("\n")
        out.write(">1MB ")
        for i in range(len(slowdown[3])):
            out.write(str.strip(slowdown[3][i]) + " ")
        out.write("\n")

        #slowdown = [["0" for j in range(4)] for i in range(8)]

        #for i in range(8):
        #    for j in range(4):
        #        for line in f[j]:
        #            tokens = line.split(",")
        #            slowdown[i][j] = str(tokens[1])
        #            break

        #for j in range(4):
        #    f[j].close()

        #out.write("arch " + "0.2 " + "0.4 " + "0.6 " + "0.8 ")
        #out.write("\n")
        #out.write("<=10KB ")
        #for i in range(len(slowdown[0])):
        #    out.write(str.strip(slowdown[0][i]) + " ")
        #out.write("\n")
        #out.write("10KB-50KB ")
        #for i in range(len(slowdown[1])):
        #    out.write(str.strip(slowdown[1][i]) + " ")
        #out.write("\n")
        #out.write("50KB-100KB ")
        #for i in range(len(slowdown[2])):
        #    out.write(str.strip(slowdown[2][i]) + " ")
        #out.write("\n")
        #out.write("100KB-500KB ")
        #for i in range(len(slowdown[3])):
        #    out.write(str.strip(slowdown[3][i]) + " ")
        #out.write("\n")
        #out.write("500KB-1MB ")
        #for i in range(len(slowdown[4])):
        #    out.write(str.strip(slowdown[4][i]) + " ")
        #out.write("\n")
        #out.write("1MB-5MB ")
        #for i in range(len(slowdown[5])):
        #    out.write(str.strip(slowdown[5][i]) + " ")
        #out.write("\n")
        #out.write("5MB-10MB ")
        #for i in range(len(slowdown[6])):
        #    out.write(str.strip(slowdown[6][i]) + " ")
        #out.write("\n")
        #out.write(">10MB ")
        #for i in range(len(slowdown[7])):
        #    out.write(str.strip(slowdown[7][i]) + " ")
        #out.write("\n")

        out.close()
