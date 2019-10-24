

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
module  lut_pipe_top_new   

# ( parameter   BUS_WIDTH    		 = 1024   ,
				BUS_WIDTH_MULTI_6    = 1026   ,
			    CMP_LAYER            = 4      ,      // C_XOR之前计算的层数，包含第一层
				LUT_NUM_LAYER_1      = 171 ,
				LUT_NUM_LAYER_2      = 29  ,
				LUT_NUM_LAYER_3      = 5   ,
				LUT_NUM_LAYER_4      = 1   ,
				LUT_NUM_LAYER_5      = 0   ,
				LUT_NUM_LAYER_6      = 0   ,
				LUT_NUM_LAYER_7      = 0   ,
				LUT_NUM_LAYER_8      = 0   ,				
				LUT_OUT_NUM_LAYER_1  = 174 ,
				LUT_OUT_NUM_LAYER_2  = 30  ,
				LUT_OUT_NUM_LAYER_3  = 6   ,
				LUT_OUT_NUM_LAYER_4  = 1   ,
				LUT_OUT_NUM_LAYER_5  = 0   ,
				LUT_OUT_NUM_LAYER_6  = 0   ,
				LUT_OUT_NUM_LAYER_7  = 0   ,
				LUT_OUT_NUM_LAYER_8  = 0    


  )
(     
            input				clk    ,
            input				rst    ,
            input	          	din_en ,
            input   [BUS_WIDTH-1:0]  	din    ,
            output  [31:0]      dout    

              ) ;

//*******************
//DEFINE LOCAL PARAMETER
//*******************
//parameter(s)








//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
   reg [BUS_WIDTH_MULTI_6-1:0] din_ff     ; 
   reg [15:0] din_en_ff     ;
//WIRES
  wire [LUT_OUT_NUM_LAYER_1*32-1:0] dout_layer_1 ;
  wire [LUT_OUT_NUM_LAYER_2*32-1:0] dout_layer_2 ;
  wire [LUT_OUT_NUM_LAYER_3*32-1:0] dout_layer_3 ;
  wire [LUT_OUT_NUM_LAYER_4*32-1:0] dout_layer_4 ;
  // wire [31:0] d_out ;
  wire [31:0] cout  ;



//*********************
//INSTANTCE MODULE
//*********************


  layer_1_new
    # (   .LUT_NUM_ONE_EQUATION (LUT_NUM_LAYER_1) ,  // 171 per equation, and thre are 32 equations		
    	  .LUT_OUT_NUM_ONE_EQUATION ( LUT_OUT_NUM_LAYER_1 )
        ) u_layer_1
( 
            .clk   ( clk )  ,   
            .rst   ( rst )  ,   
            .din   ( din_ff )  ,// 需要注意，凑成6的整数倍
            .dout  ( dout_layer_1 )			      

 ) ;

 layer_xor_new 
    # (   .LUT_NUM_ONE_EQUATION  (LUT_NUM_LAYER_2),
    	.LUT_OUT_NUM_ONE_EQUATION ( LUT_OUT_NUM_LAYER_2 )
 
        ) u_layer_2 
( 
            .clk  ( clk )  ,   
            .rst  ( rst )  ,   
            .din  ( dout_layer_1 )  ,
            .dout ( dout_layer_2 )       				      

 ) ;

 layer_xor_new 
    # (   .LUT_NUM_ONE_EQUATION  (LUT_NUM_LAYER_3),
    	  .LUT_OUT_NUM_ONE_EQUATION ( LUT_OUT_NUM_LAYER_3 )
 
        ) u_layer_3 
( 
            .clk  ( clk )  ,   
            .rst  ( rst )  ,   
            .din  ( dout_layer_2 )  ,
            .dout ( dout_layer_3 )       				      

 ) ;
 layer_xor_new 
    # (   .LUT_NUM_ONE_EQUATION  (LUT_NUM_LAYER_4),
          .LUT_OUT_NUM_ONE_EQUATION ( LUT_OUT_NUM_LAYER_4 )
        ) u_layer_4 
( 
            .clk  ( clk )  ,   
            .rst  ( rst )  ,   
            .din  ( dout_layer_3 )  ,
            .dout ( dout_layer_4 )       				      

 ) ;

c_xor_lut  u_c_xor_lut   (     
            .clk    ( clk )  ,
            .rst    ( rst )  ,
            .dval   ( din_en_ff[CMP_LAYER] )  ,
            .din    ( dout_layer_4 )  ,
            .cin    ( cout  )  ,
            .cout   ( cout  )      
              ) ;



assign dout = cout ;

//*********************
//MAIN CORE
//********************* 

always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		din_ff    <= 'd0 ;
	end
    else begin
       din_ff      <= din ; 
    end
end


always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		din_en_ff <= 'd0 ;
	end
    else begin
        din_en_ff <= { din_en_ff[14:0], din_en } ;
    end
end


//*********************
endmodule   







// genvar i;
// generate
//     for (i=0; i<32; i=i+1) begin : first_layer
// 		lut_layer_1 
// 		    # ( 
// 		           //  .NUM (i) ,
// 		            .POLY ( poly[i*10944 +: 10944] )  
// 		        )
// 		u_lut_layer_1  (     
// 		    .clk      ( clk      )  ,   
// 		    .rst      ( rst      )  ,   
// 		    .din      ( din_ff      )  ,
// 		    .dout 	  ( d_out[i] 	  )       
// 		              ) ;
//     end
// endgenerate