

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
module  c_xor_lut 

# ( parameter   C_POLY        =  0   // 7    
)


  (     
            input 					clk      ,
            input					rst      ,
            input         eop    ,
            input					dval     ,
            input		[31:0] 		din      ,
            input		[31:0] 		cin      ,
            output  reg [31:0] 		cout ,
            output  reg [31:0]    cout_1         
              ) ;

//*******************
//DEFINE LOCAL PARAMETER
//*******************
//parameter(s)
parameter [0:12287] POLY = C_POLY ;


//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
  

initial begin
cout     ='b0 ;
cout_1   ='b0 ;
end


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

always @(posedge clk  ) begin
   if ( dval == 1'b1 ) begin
        cout <= cout_pre ;
    end
    else begin
       cout <= 32'h0 ; // 32'hffff_ffff ;
    end
end


always @(posedge clk  ) begin
 if ( eop == 1'b1 ) begin
    cout_1 <= 32'h0 ;
  end
    else if ( dval == 1'b1 ) begin
        cout_1 <= cout_pre ;
    end
    else begin
       cout_1 <= 32'h0 ; // 32'hffff_ffff ;
    end
end



//*********************
endmodule   