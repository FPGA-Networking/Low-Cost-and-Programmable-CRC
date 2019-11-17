#NUM = 956447

f_read = open('X:/project/TEST_2019/read_frames/jtag_axi_icap_lut_AX7103/py_code/txt/xor_bin.rbt', 'r')
f_write= open('X:/project/TEST_2019/read_frames/jtag_axi_icap_lut_AX7103/py_code/txt/xor_hex.txt', 'w')
a=f_read.readlines()

NUM = 0
for ite in a:
    NUM += 1

b=list(range(0,NUM-7))

for i in range(0,NUM):
	b[i]='{:08x}'.format(int(a[i+7],2)) 
	f_write.writelines(b[i])
	f_write.writelines('\n')
 	
 	

f_read.close()
f_write.close()







# for i in range(0,16):
# 	b=hex(int(a[i],2))
# 	c=b.zfill(16)
# 	print(c)
# 	





# a=16
# b="%03x" %a 
# print(b)




# # b=hex(int(a[1],2))
# # print(hex(int(a[1],2)))
# f_write.writelines(a)
# f_read.close()
# f_write.close()
# 
# 
# a=list(range(0,32768))
# for i in range(0,32768):
# 	b=i
# 	print(b)
# 	a[b]=b
	
	

