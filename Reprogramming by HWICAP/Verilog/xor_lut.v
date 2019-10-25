

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
module  xor_lut   (     
            input           clk  ,
            input           rst  ,
            input   [5:0]   din  ,
            output  reg     dout         
              ) ;

//*******************
//DEFINE LOCAL PARAMETER
//*******************
//parameter(s)
                                    


//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
reg [5:0] din_ff ;

//WIRES
 wire  dout_pre ;

//*********************
//INSTANTCE MODULE
//*********************




//*********************
//MAIN CORE
//********************* 

always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		din_ff <= 'd0 ;
	end
    else begin
        din_ff <= din ;
    end
end

always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		dout <= 'd0 ;
	end
    else begin
        dout <= dout_pre ;
    end
end



 (* DONT_TOUCH= "TRUE" *) (*BEL="D6LUT",LOC="SLICE_X57Y53"*)    LUT6 #(
      .INIT(64'h0123_4567_89AB_CDEF)  // Specify LUT Contents // 0212_2232_4252_6272
   ) LUT6_inst_D_right (
      .O(dout_pre),   // LUT general output
      .I0(din_ff[0]), // LUT input
      .I1(din_ff[1]), // LUT input
      .I2(din_ff[2]), // LUT input
      .I3(din_ff[3]), // LUT input
      .I4(din_ff[4]), // LUT input
      .I5(din_ff[5])  // LUT input
   );

//*********************
endmodule   