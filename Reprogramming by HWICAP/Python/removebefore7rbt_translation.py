import sys,os;
f_read = open(os.path.dirname(os.path.realpath(__file__))+'\\bit.rbt', 'r')
f_write= open(os.path.dirname(os.path.realpath(__file__))+'\\hex.rbt', 'w')
a=f_read.readlines()
NUM=int(list(a[6].rstrip("\n").rsplit("\t"))[-1])//32+7
print(NUM)
b=list(range(0,NUM))

for i in range(0,NUM):
    if(i<7):
        f_write.writelines(a[i])
    else:
        b[i]='{:08x}'.format(int(a[i],2)) 
        f_write.writelines(b[i])
        f_write.writelines('\n')
f_read.close()
f_write.close()
