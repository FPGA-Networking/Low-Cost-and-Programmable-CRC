

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
module  c_xor_lut   (     
            input 					clk      ,
            input					rst      ,
            input					dval     ,
            input		[31:0] 		din      ,
            input		[31:0] 		cin      ,
            output  reg [31:0] 		cout         
              ) ;

//*******************
//DEFINE LOCAL PARAMETER
//*******************
//parameter(s)
parameter [0:12287] POLY =
{
64'ha5a55a5aa5a55a5a,
64'h9696969696969696,
64'h9696696969699696,
64'hc3c3c3c33c3c3c3c,
64'h5aa55aa5a55aa55a,
64'hf0f0f0f0f0f0f0f0,
64'h6996966996696996,
64'h55aa55aa55aa55aa,
64'haa5555aaaa5555aa,
64'h6699669999669966,
64'h3c3cc3c3c3c33c3c,
64'h5a5a5a5a5a5a5a5a,
64'hcc33cc3333cc33cc,
64'h0f0ff0f00f0ff0f0,
64'h5a5a5a5a5a5a5a5a,
64'h0000ffffffff0000,
64'h0000000000000000,
64'h9696969696969696,
64'ha5a55a5aa5a55a5a,
64'haa55aa5555aa55aa,
64'h33cc33cc33cc33cc,
64'hffffffff00000000,
64'haaaaaaaaaaaaaaaa,
64'h3c3c3c3c3c3c3c3c,
64'hc33c3cc33cc3c33c,
64'ha5a55a5aa5a55a5a,
64'h33333333cccccccc,
64'hc3c3c3c33c3c3c3c,
64'h3cc33cc3c33cc33c,
64'hf0f0f0f0f0f0f0f0,
64'haa55aa5555aa55aa,
64'hf00ff00f0ff00ff0,
64'h6666999999996666,
64'h6699669999669966,
64'h0000ffffffff0000,
64'h5a5a5a5a5a5a5a5a,
64'h9999666699996666,
64'haa5555aaaa5555aa,
64'h6969696996969696,
64'h6969969669699696,
64'h55555555aaaaaaaa,
64'h9696969696969696,
64'h6666999999996666,
64'h5a5aa5a5a5a55a5a,
64'h55aaaa55aa5555aa,
64'h55aa55aa55aa55aa,
64'h9669966969966996,
64'h9696969696969696,
64'h6666999999996666,
64'hf00ff00f0ff00ff0,
64'hf0f0f0f0f0f0f0f0,
64'h5a5aa5a5a5a55a5a,
64'h6666999999996666,
64'h9696969696969696,
64'hc3c3c3c33c3c3c3c,
64'haa5555aaaa5555aa,
64'h55aa55aa55aa55aa,
64'hcc33cc3333cc33cc,
64'h6969696996969696,
64'h9696969696969696,
64'haa5555aaaa5555aa,
64'hf0f00f0f0f0ff0f0,
64'ha5a5a5a55a5a5a5a,
64'hcccc33333333cccc,
64'h33333333cccccccc,
64'h9696969696969696,
64'h6969696996969696,
64'h9669966969966996,
64'h0ff0f00ff00f0ff0,
64'h6666666666666666,
64'h00ff00ffff00ff00,
64'h9696969696969696,
64'h6699996666999966,
64'h00ffff0000ffff00,
64'hc33cc33cc33cc33c,
64'h55555555aaaaaaaa,
64'ha55a5aa55aa5a55a,
64'h9696969696969696,
64'h3c3cc3c3c3c33c3c,
64'h0000ffffffff0000,
64'hf00f0ff0f00f0ff0,
64'hcccccccccccccccc,
64'h9966669966999966,
64'h9696969696969696,
64'h5aa55aa5a55aa55a,
64'h55555555aaaaaaaa,
64'h55aaaa55aa5555aa,
64'hf0f0f0f0f0f0f0f0,
64'h3c3cc3c3c3c33c3c,
64'h9696969696969696,
64'h6699996666999966,
64'h6666666666666666,
64'h6666999999996666,
64'h55aa55aa55aa55aa,
64'hf00ff00f0ff00ff0,
64'h9696969696969696,
64'h9999999966666666,
64'haaaaaaaaaaaaaaaa,
64'h5555aaaa5555aaaa,
64'h5a5aa5a5a5a55a5a,
64'h5a5aa5a5a5a55a5a,
64'h9696969696969696,
64'h9696969696969696,
64'h6666666666666666,
64'h33333333cccccccc,
64'hcc33cc3333cc33cc,
64'h6699669999669966,
64'h9696969696969696,
64'h6996699669966996,
64'h3c3c3c3c3c3c3c3c,
64'hf0f0f0f0f0f0f0f0,
64'ha5a55a5aa5a55a5a,
64'h6969969669699696,
64'h9696969696969696,
64'h9669699696696996,
64'h0ff00ff00ff00ff0,
64'hff00ff00ff00ff00,
64'hcc33cc3333cc33cc,
64'h3cc33cc3c33cc33c,
64'h3c3c3c3c3c3c3c3c,
64'h6996966996696996,
64'h00ffff0000ffff00,
64'hffff0000ffff0000,
64'h0f0ff0f00f0ff0f0,
64'h5aa5a55a5aa5a55a,
64'h5a5a5a5a5a5a5a5a,
64'h6996966996696996,
64'haaaa55555555aaaa,
64'hffffffff00000000,
64'h00ff00ffff00ff00,
64'h33cccc33cc3333cc,
64'h3c3c3c3c3c3c3c3c,
64'h6699669999669966,
64'h0f0f0f0ff0f0f0f0,
64'h3c3cc3c3c3c33c3c,
64'h9696696969699696,
64'h00ffff0000ffff00,
64'h5a5a5a5a5a5a5a5a,
64'hcccccccccccccccc,
64'hc33cc33cc33cc33c,
64'hcc3333cccc3333cc,
64'h55aa55aa55aa55aa,
64'hf00f0ff0f00f0ff0,
64'h3c3c3c3c3c3c3c3c,
64'hf0f0f0f0f0f0f0f0,
64'hf00f0ff0f00f0ff0,
64'hf0f00f0f0f0ff0f0,
64'h3333cccc3333cccc,
64'hff0000ff00ffff00,
64'hf0f0f0f0f0f0f0f0,
64'h55aa55aa55aa55aa,
64'hff0000ff00ffff00,
64'h00ff00ffff00ff00,
64'ha5a5a5a55a5a5a5a,
64'h0000ffffffff0000,
64'h5a5a5a5a5a5a5a5a,
64'h9696969696969696,
64'h9696696969699696,
64'hc3c3c3c33c3c3c3c,
64'h5aa55aa5a55aa55a,
64'h0ff00ff00ff00ff0,
64'h9696969696969696,
64'hc33cc33cc33cc33c,
64'h3cc33cc3c33cc33c,
64'ha55aa55aa55aa55a,
64'h6699996666999966,
64'haa5555aaaa5555aa,
64'h3c3c3c3c3c3c3c3c,
64'h5aa5a55a5aa5a55a,
64'hf00f0ff0f00f0ff0,
64'h6699996666999966,
64'h3c3cc3c3c3c33c3c,
64'hcccc33333333cccc,
64'hf0f0f0f0f0f0f0f0,
64'h33cccc33cc3333cc,
64'hff0000ff00ffff00,
64'h3c3cc3c3c3c33c3c,
64'hf00ff00f0ff00ff0,
64'ha5a5a5a55a5a5a5a,
64'h5a5a5a5a5a5a5a5a,
64'h5a5aa5a5a5a55a5a,
64'haaaa55555555aaaa,
64'h5aa55aa5a55aa55a,
64'haa5555aaaa5555aa,
64'h9966996699669966,
64'h9696969696969696,
64'hcc33cc3333cc33cc,
64'h9999999966666666,
64'h6699996666999966,
64'h6666999999996666,
64'hc3c33c3cc3c33c3c,
64'h3c3c3c3c3c3c3c3c
};

//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
  

//WIRES
 // wire cin_and ; // 与上参数之后的值
 // 
 wire [191:0] temp ; 
 wire [35:0] cin_merge [0:31] ;
 wire [31:0] cout_pre ;

//*********************
//INSTANTCE MODULE
//*********************

genvar k;
generate
    for (k=0; k<32; k=k+1) begin : cin_mer
    	assign cin_merge[k] = {3'b0, din[k], cin}  ;
    end
endgenerate



genvar i;
genvar j;
generate
    for (i=0; i<32; i=i+1) begin : c_xor_layer_1
    	for (j=0; j<6; j=j+1) begin : c_xor_layer_2
   			LUT6 #(
   			   .INIT(POLY[i*6*64+j*64 +: 64])  // Specify LUT Contents
   			) LUT6_inst (
   			   .O(temp[i*6+j]),   // LUT general output
   			   .I0(cin_merge[i][j*6]), // LUT input
   			   .I1(cin_merge[i][j*6+1]), // LUT input
   			   .I2(cin_merge[i][j*6+2]), // LUT input
   			   .I3(cin_merge[i][j*6+3]), // LUT input
   			   .I4(cin_merge[i][j*6+4]), // LUT input
   			   .I5(cin_merge[i][j*6+5])  // LUT input
   			);	
    	end
    end
endgenerate




genvar m;
generate
    for (m=0; m<32; m=m+1) begin : xor_1
		// lut_xor  lut_xor   (     
		//             .clk  ( clk )  ,
		//             .rst  ( rst )  ,
		//             .din  ( temp[m*6+5 -: 6] )  ,
		//             .dout ( cout_pre[m] )        
		//               ) ;

   LUT6 #(
      .INIT(64'h6996966996696996)  // Specify LUT Contents
   ) LUT6_inst (
      .O(cout_pre[m] ),   // LUT general output
      .I0(temp[m*6  ]), // LUT input
      .I1(temp[m*6+1]), // LUT input
      .I2(temp[m*6+2]), // LUT input
      .I3(temp[m*6+3]), // LUT input
      .I4(temp[m*6+4]), // LUT input
      .I5(temp[m*6+5])  // LUT input
   ); 
    
    end
endgenerate




//*********************
//MAIN CORE
//********************* 

always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		cout <= 32'hffff_ffff ;
	end
    else if ( dval == 1'b1 ) begin
        cout <= cout_pre ;
    end
    else begin
       cout <= 32'hffff_ffff ;
    end
end




//*********************
endmodule   