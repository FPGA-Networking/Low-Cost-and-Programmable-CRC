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
module  lut_xor   (     
            input 		clk   ,
            input 		rst   ,
            input [5:0] din   ,
            output reg  dout        
              ) ;

//*******************
//DEFINE LOCAL PARAMETER
//*******************
//parameter(s)
                                    
 

//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
  

//WIRES
  wire dout_pre ;

//*********************
//INSTANTCE MODULE
//*********************

   LUT6 #(
      .INIT(64'h6996966996696996)  // Specify LUT Contents
   ) LUT6_inst (
      .O(dout_pre),   // LUT general output
      .I0(din[0]), // LUT input
      .I1(din[1]), // LUT input
      .I2(din[2]), // LUT input
      .I3(din[3]), // LUT input
      .I4(din[4]), // LUT input
      .I5(din[5])  // LUT input
   );


//*********************
//MAIN CORE
//********************* 

always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		dout <= 'd0 ;
	end
    else begin
       dout <= dout_pre ; 
    end
end



//*********************
endmodule   