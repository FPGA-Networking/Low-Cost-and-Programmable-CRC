

// **************************************************************
// COPYRIGHT(c)2015, Xidian University
// All rights reserved.
//
// IP LIB INDEX :  
// IP Name      :      
// File name    : 
// Module name  : 
// Full name    :  
//
// Author       : Liu-Huan 
// Email        : assasin9997@163.com 
// Data         : 
// Version      : V 1.0 
// 
// Abstract     : 
// Called by    :  
// 
// Modification history
// -----------------------------------------------------------------
// 
// 
//
// *****************************************************************

// *******************
// TIMESCALE
// ******************* 
`timescale 1ns/1ps 

// *******************
// INFORMATION
// *******************


//*******************
//DEFINE(s)
//*******************
//`define UDLY 1    //Unit delay, for non-blocking assignments in sequential logic



//*******************
//DEFINE MODULE PORT
//*******************
module  jtag_axi_icap_top   (     
               input	clk_n , 
               input  clk_p 

              ) ;

//*******************
//DEFINE LOCAL PARAMETER
//*******************
//parameter(s)
                                    
 

//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
 wire [5:0] lut_din ;
 wire      lut_dout ;

//WIRES

wire [31 : 0] m_axi_awaddr   ;
wire [2 : 0] m_axi_awprot    ;
wire m_axi_awvalid           ;
wire m_axi_awready           ;
wire [31 : 0] m_axi_wdata    ;
wire [3 : 0] m_axi_wstrb     ;
wire m_axi_wvalid            ;
wire m_axi_wready            ;
wire [1 : 0] m_axi_bresp     ;
wire m_axi_bvalid            ;
wire m_axi_bready            ;
wire [31 : 0] m_axi_araddr   ;
wire [2 : 0] m_axi_arprot    ;
wire m_axi_arvalid           ;
wire m_axi_arready           ;
wire [31 : 0] m_axi_rdata    ;
wire [1 : 0] m_axi_rresp     ;
wire m_axi_rvalid            ;
wire m_axi_rready            ;


wire rst_n ;

//*********************
//INSTANTCE MODULE
//*********************


  clk_wiz_0 u_clk_wiz_0
   (
    // Clock out ports
    .clk_out1(clk_buf),     // output clk_out1
   // Clock in ports
    .clk_in1_p(clk_p),    // input clk_in1_p
    .clk_in1_n(clk_n));    // input clk_in1_n

// BUFG BUFG_inst (
// .O(clk_buf), // 1-bit output: Clock output
// .I(clk) // 1-bit input: Clock input
// );



rst_vio u_rst_vio (
  .clk(clk_buf),                // input wire clk
  .probe_out0(rst_n)  // output wire [0 : 0] probe_out0
);



jtag_axi_0 u_jtag_axi_0 (
  .aclk(clk_buf),                    // input wire aclk
  .aresetn(rst_n),              // input wire aresetn
  .m_axi_awaddr(m_axi_awaddr),    // output wire [31 : 0] m_axi_awaddr
  .m_axi_awprot(m_axi_awprot),    // output wire [2 : 0] m_axi_awprot
  .m_axi_awvalid(m_axi_awvalid),  // output wire m_axi_awvalid
  .m_axi_awready(m_axi_awready),  // input wire m_axi_awready
  .m_axi_wdata(m_axi_wdata),      // output wire [31 : 0] m_axi_wdata
  .m_axi_wstrb(m_axi_wstrb),      // output wire [3 : 0] m_axi_wstrb
  .m_axi_wvalid(m_axi_wvalid),    // output wire m_axi_wvalid
  .m_axi_wready(m_axi_wready),    // input wire m_axi_wready
  .m_axi_bresp(m_axi_bresp),      // input wire [1 : 0] m_axi_bresp
  .m_axi_bvalid(m_axi_bvalid),    // input wire m_axi_bvalid
  .m_axi_bready(m_axi_bready),    // output wire m_axi_bready
  .m_axi_araddr(m_axi_araddr),    // output wire [31 : 0] m_axi_araddr
  .m_axi_arprot(m_axi_arprot),    // output wire [2 : 0] m_axi_arprot
  .m_axi_arvalid(m_axi_arvalid),  // output wire m_axi_arvalid
  .m_axi_arready(m_axi_arready),  // input wire m_axi_arready
  .m_axi_rdata(m_axi_rdata),      // input wire [31 : 0] m_axi_rdata
  .m_axi_rresp(m_axi_rresp),      // input wire [1 : 0] m_axi_rresp
  .m_axi_rvalid(m_axi_rvalid),    // input wire m_axi_rvalid
  .m_axi_rready(m_axi_rready)    // output wire m_axi_rready
);


axi_hwicap_0 u_axi_hwicap_0 (
	.icap_clk     (clk_buf),            // input wire icap_clk
	.eos_in       (),                // input wire eos_in
	.s_axi_aclk   (clk_buf),        // input wire s_axi_aclk
	.s_axi_aresetn(rst_n),  // input wire s_axi_aresetn
	.s_axi_awaddr (m_axi_awaddr),    // input wire [8 : 0] s_axi_awaddr
	.s_axi_awvalid(m_axi_awvalid),  // input wire s_axi_awvalid
	.s_axi_awready(m_axi_awready),  // output wire s_axi_awready
	.s_axi_wdata  (m_axi_wdata),      // input wire [31 : 0] s_axi_wdata
	.s_axi_wstrb  (m_axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
	.s_axi_wvalid (m_axi_wvalid),    // input wire s_axi_wvalid
	.s_axi_wready (m_axi_wready),    // output wire s_axi_wready
	.s_axi_bresp  (m_axi_bresp),      // output wire [1 : 0] s_axi_bresp
	.s_axi_bvalid (m_axi_bvalid),    // output wire s_axi_bvalid
	.s_axi_bready (m_axi_bready),    // input wire s_axi_bready
	.s_axi_araddr (m_axi_araddr),    // input wire [8 : 0] s_axi_araddr
	.s_axi_arvalid(m_axi_arvalid),  // input wire s_axi_arvalid
	.s_axi_arready(m_axi_arready),  // output wire s_axi_arready
	.s_axi_rdata  (m_axi_rdata),      // output wire [31 : 0] s_axi_rdata
	.s_axi_rresp  (m_axi_rresp),      // output wire [1 : 0] s_axi_rresp
	.s_axi_rvalid (m_axi_rvalid),    // output wire s_axi_rvalid
	.s_axi_rready (m_axi_rready),    // input wire s_axi_rready
	.ip2intc_irpt ()    // output wire ip2intc_irpt
);



cnt  cnt   (     
            .clk   ( clk_buf ) ,
            .rst   ( ~rst_n ) ,
            .cnt_o ( lut_din )           
              ) ;

xor_lut  u_xor_lut   (     
            .clk  ( clk_buf ) ,
            .rst  ( ~rst_n ) ,
            .din  ( lut_din ) ,
            .dout ( lut_dout )         
              ) ;

reg [63:0] dout_parell ;
reg [63:0] dout ;
wire rst ;
assign rst = ~rst_n ;
always @(posedge clk_buf or posedge rst) begin
	if (rst == 1'b1) begin
		dout_parell <= 'd0 ;
	end
    else begin
        dout_parell <= { dout_parell[62:0], lut_dout } ;
    end
end


always @(posedge clk_buf or posedge rst) begin
	if (rst == 1'b1) begin
		dout <= 'd0 ;
	end
    else if ( lut_din == 'd61 ) begin
        dout <= dout_parell ;
    end
end


ila_0 u_ila_0 (
  .clk(clk_buf), // input wire clk
  .probe0(lut_din), // input wire [5:0]  probe0  
  .probe1(lut_dout), // input wire [0:0]  probe1
  .probe2( dout )
);

//*********************
//MAIN CORE
//********************* 




//*********************
endmodule   