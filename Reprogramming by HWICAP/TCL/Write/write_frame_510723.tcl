
# refer to xhwicap_device_write_frame.c

# SYNC
run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data FFFFFFFF ];  # XHI_DUMMY_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data AA995566 ];  # XHI_SYNC_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

# Reset CRC
run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 30008001 ]; # XHwIcap_Type1Write(XHI_CMD)

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 00000007 ]; # XHI_CMD_RCRC

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET


# ID register
run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 30018001 ]; # XHwIcap_Type1Write(XHI_IDCODE)

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 13631093 ]; # DeviceIdCode artix-7 100T

# FAR
run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 30002001 ]; # XHwIcap_Type1Write(XHI_FAR)

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 0040111C ]; # XHwIcap_SetupFar(Top, Block, HClkRow,  MajorFrame, MinorFrame)
# 000000_000_1_00000_0000100010_0011100
# 6bit(0)-pad        3bit(0)-block type       1bit(1)-top      5bit(0)-row addr     10bit(34)-column addr         7bit(28)-minor addr-the third frm
# 00000000010000000001000100011100  :  0040111C



# Setup CMD register - write configuration
run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 30008001 ]; # XHwIcap_Type1Write(XHI_CMD)

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 00000001 ]; # XHI_CMD_WCFG

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 20000000 ]; # XHI_NOOP_PACKET

# Setup Packet header
run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 300040CA ]; # XHwIcap_Type1Write(XHI_FDRI) | TotalWords;

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_010C -len 1 -data 00000001]; # Control reg 写操作

# write 202 zero words


set DATA_NUM 101
for { set loop_to_jtag 0}  {$loop_to_jtag < $DATA_NUM} {incr loop_to_jtag} {
	run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 00000000 ]; # write lut with zeros
}

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_010C -len 1 -data 00000001]; # Control reg 写操作

set DATA_NUM 101
for { set loop_to_jtag 0}  {$loop_to_jtag < $DATA_NUM} {incr loop_to_jtag} {
	run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_0100 -len 1 -data 00000000 ]; # write lut with zeros
}

run_hw_axi [create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -force -type WRITE  -address 0000_010C -len 1 -data 00000001]; # Control reg 写操作