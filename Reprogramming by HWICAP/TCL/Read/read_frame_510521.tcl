

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data FFFFFFFF ];  # XHI_DUMMY_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data AA995566 ];  # XHI_SYNC_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 30008001 ]; # XHwIcap_Type1Write(XHI_CMD)

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 00000007 ]; # XHI_CMD_RCRC

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 30008001 ]; # XHwIcap_Type1Write(XHI_CMD)

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 00000004 ]; # XHI_CMD_RCFG

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 30002001 ]; # XHwIcap_Type1Write(XHI_FAR)

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 0040111A ]; # XHwIcap_SetupFar(Top, Block, HClkRow,  MajorFrame, MinorFrame)
# 000000_000_1_00000_0000100010_0011010
# 6bit(0)-pad        3bit(0)-block type       1bit(1)-top      5bit(0)-row addr     10bit(34)-column addr         7bit(26)-minor addr-the first frm
# 00000000010000000001000100011010  :  0040111A



run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 280060CA ]; # XHwIcap_Type1Read(XHI_FDRO)| TotalWords;

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_010C -len 1 -data 00000001]; # Control reg 写操作


# after 500 ; 其实不用延迟

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0108 -len 1 -data 000000CA] ; # Size reg，0xCA=202，0x65 = 101（10进制）

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_010C -len 1 -data 00000002] ; # Control reg 读操作

# 读 FIFO中的数据的数量
run_hw_axi [create_hw_axi_txn read_txn [get_hw_axis hw_axi_1] -force -type READ  -address 0000_0118 -len 1] 


set DATA_NUM 202
set data_from_jtag {} 
for { set loop_from_jtag 0}  {$loop_from_jtag < $DATA_NUM} {incr loop_from_jtag} {
   run_hw_axi [create_hw_axi_txn read_txn [get_hw_axis hw_axi_1] -force -type READ  -address 00000104   -len 1]
   append data_from_jtag [report_hw_axi_txn read_txn -w 4 -t x4]
}