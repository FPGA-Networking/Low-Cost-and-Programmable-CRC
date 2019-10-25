

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
module  cnt   (     
            input	clk ,
            input	rst ,
            output  reg [5:0] cnt_o         
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
 

//*********************
//INSTANTCE MODULE
//*********************




//*********************
//MAIN CORE
//********************* 

always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		cnt_o <= 'd0 ;
	end
    else begin
        cnt_o <= cnt_o-1'b1 ;
    end
end



//*********************
endmodule   