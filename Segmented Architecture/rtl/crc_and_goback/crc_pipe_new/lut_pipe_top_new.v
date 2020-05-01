

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

# ( parameter   BUS_WIDTH    		 = 0 , // 1024
				BUS_WIDTH_MULTI_6        = 0 , // 1026
        MOD_WIDTH                = 0 ,
        LUT_POLY                 = 0 ,
        CRC_REG_INIT             = 0 ,
			  CMP_LAYER                = 0 , // 4       // C_XOR之前计算的层数，包含第一层
				LUT_NUM_LAYER_1          = 0 , // 171 
				LUT_NUM_LAYER_2          = 0 , // 29  
				LUT_NUM_LAYER_3          = 0 , // 5   
				LUT_NUM_LAYER_4          = 0 , // 1   
				LUT_NUM_LAYER_5          = 0 , // 0   
				LUT_NUM_LAYER_6          = 0 , // 0   
				LUT_NUM_LAYER_7          = 0 , // 0   
				LUT_NUM_LAYER_8          = 0 ,	// 0   			
				LUT_OUT_NUM_LAYER_1      = 0 , // 174 
				LUT_OUT_NUM_LAYER_2      = 0 , // 30  
				LUT_OUT_NUM_LAYER_3      = 0 , // 6   
				LUT_OUT_NUM_LAYER_4      = 0 , // 1   
				LUT_OUT_NUM_LAYER_5      = 0 , // 0   
				LUT_OUT_NUM_LAYER_6      = 0 , // 0   
				LUT_OUT_NUM_LAYER_7      = 0 , // 0   
				LUT_OUT_NUM_LAYER_8      = 0   // 0   
   

  )
(   

            input				clk    ,
            input				rst    ,
            // input       sop ,
            // input       eop ,
            // input	          	din_en ,
            // input   [BUS_WIDTH-1:0]  	din    ,
            // output  [31:0]      dout    

            input sop_in  ,
            input eop_in  ,
            input dval_in ,
            input [3:0] packet_num_in ,
            input [MOD_WIDTH-1:0] mod_in  ,
            input [BUS_WIDTH-1:0] din  ,
            
            
            output sop_out  ,
            output eop_out  ,
            output dval_out ,
            output [3:0] packet_num_out,
            output [MOD_WIDTH-1:0] mod_out ,
            output reg [31:0] dout    


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
  // wire [LUT_OUT_NUM_LAYER_4*32-1:0] dout_layer_4 ;
  // wire [LUT_OUT_NUM_LAYER_5*32-1:0] dout_layer_5 ;
  // wire [31:0] d_out ;
  // wire [31:0] cout  ;
  // wire [31:0] cout_1;



//*********************
//INSTANTCE MODULE
//*********************

// =====================================

reg [15:0] sop_ff ;
reg [15:0] eop_ff ;
reg [15:0] dval_ff;
reg [MOD_WIDTH:0]  mod_ff [7:0] ;
reg [3:0]  packet_num_ff [7:0] ;

integer i,j ;
always @(posedge clk ) begin
    // if (rst == 1'b1) begin
    //     for ( i=0; i<8; i=i+1 ) begin
    //         packet_num_ff[i] <= 'd0 ;
    //     end
    // end
    // else begin
        packet_num_ff[0] <= packet_num_in ; // {1'b1,{MOD_WIDTH{1'b0}}}-mod_in ; // 这里记得修改
        for ( j=1; j<8; j=j+1 )  begin
            packet_num_ff[j] <= packet_num_ff[j-1] ;
        end
    // end
end

always @(posedge clk ) begin
    // if (rst == 1'b1) begin
    //     for ( i=0; i<8; i=i+1 ) begin
    //         mod_ff[i] <= 'd0 ;
    //     end
    // end
    // else begin
        mod_ff[0] <= mod_in ; // {1'b1,{MOD_WIDTH{1'b0}}}-mod_in ; // 这里记得修改
        for ( j=1; j<8; j=j+1 )  begin
            mod_ff[j] <= mod_ff[j-1] ;
        end
    // end
end

always @(posedge clk  ) begin
    // if (rst == 1'b1) begin
    //     sop_ff <= 'd0 ;
    // end
    // else begin
        sop_ff <= { sop_ff[14:0], sop_in } ;
    // end
end

always @(posedge clk  ) begin
    // if (rst == 1'b1) begin
    //     eop_ff <= 'd0 ;
    // end
    // else begin
        eop_ff <= { eop_ff[14:0], eop_in } ;
    // end
end

always @(posedge clk ) begin
    // if (rst == 1'b1) begin
    //     dval_ff <= 'd0 ;
    // end
    // else begin
        dval_ff <= { dval_ff[14:0], dval_in } ;
    // end
end

always @(posedge clk) begin
    // if (rst == 1'b1) begin
    //     din_ff    <= 'd0 ;
    // end
    // else begin
       din_ff      <= din ; 
    // end
end

// =====================================


assign sop_out    = sop_ff[CMP_LAYER+1] ;
assign eop_out    = eop_ff[CMP_LAYER+1] ;
assign dval_out   = dval_ff[CMP_LAYER+1] ;
assign mod_out    = mod_ff[CMP_LAYER+1] ;
assign packet_num_out = packet_num_ff[CMP_LAYER+1] ;








  layer_1_new
    # ( .LUT_NUM_ONE_EQUATION (LUT_NUM_LAYER_1) ,  // 171 per equation, and thre are 32 equations		
    	  .LUT_OUT_NUM_ONE_EQUATION ( LUT_OUT_NUM_LAYER_1 ),
        .LUT_POLY ( LUT_POLY )
        ) u_layer_1
( 
            .clk   ( clk )  ,   
            .rst   ( rst )  ,   
            .din   ( din_ff )  ,// 需要注意，凑成6的整数倍
            .dout  ( dout_layer_1 )			      

 ) ;

//  layer_xor_new 
//     # (   .LUT_NUM_ONE_EQUATION  (LUT_NUM_LAYER_2),
//     	.LUT_OUT_NUM_ONE_EQUATION ( LUT_OUT_NUM_LAYER_2 )
 
//         ) u_layer_2 
// ( 
//             .clk  ( clk )  ,   
//             .rst  ( rst )  ,   
//             .din  ( dout_layer_1 )  ,
//             .dout ( dout_layer_2 )       				      

//  ) ;

//  layer_xor_new 
//     # (   .LUT_NUM_ONE_EQUATION  (LUT_NUM_LAYER_3),
//     	  .LUT_OUT_NUM_ONE_EQUATION ( LUT_OUT_NUM_LAYER_3 )
 
//         ) u_layer_3 
// ( 
//             .clk  ( clk )  ,   
//             .rst  ( rst )  ,   
//             .din  ( dout_layer_2 )  ,
//             .dout ( dout_layer_3 )       				      

//  ) ;


layer_xor_rtl  
    # (  .INPUT_NUM_ONE_EQUATION   ( 13 )     ,  
         .OUTPUT_NUM_ONE_EQUATION  ( 1 )       
        )

    layer_xor_rtl
( 
            .clk  ( clk )     ,   
            .rst  ( rst )     ,   
            .din  ( dout_layer_1 )     ,
            .dout ( dout_layer_3 )                       

 ) ;


// ===================================================================

wire sop_used ;


assign sop_used  = sop_ff[CMP_LAYER]    ;



always @(posedge clk  ) begin
 
  if ( sop_used ) begin
    dout  <= dout_layer_3^CRC_REG_INIT ; // init value of crc_reg(32'hffffffff) is processed here ,it is 32'h6904BB59 for 64bit bus 
  end
  else begin
    dout  <= dout_layer_3 ;
  end
end










//*********************
//MAIN CORE
//********************* 







//*********************
endmodule   

//wire dval_used;
// wire eop_used ; 
// reg [LUT_OUT_NUM_LAYER_3*32-1:0] dout_layer_n ;
//assign dval_used = dval_ff[CMP_LAYER+1] ;
// assign eop_used = eop_ff[CMP_LAYER+1] ;  
// assign dout = cout ;

// c_xor_lut  u_c_xor_lut   (     
//             .clk    ( clk )  ,
//             .rst    ( rst )  ,
//             .eop    ( eop_ )  ,
//             .dval   ( dval_used )  ,
//             .din    ( dout_layer_n )  , // 6904BB59
//             .cin    ( cout_1  )  ,
//             .cout   ( cout  )  ,
//             .cout_1 ( cout_1 )    
//               ) ;


//  layer_xor_new 
//     # (   .LUT_NUM_ONE_EQUATION  (LUT_NUM_LAYER_4),
//           .LUT_OUT_NUM_ONE_EQUATION ( LUT_OUT_NUM_LAYER_4 )
//         ) u_layer_4 
// ( 
//             .clk  ( clk )  ,   
//             .rst  ( rst )  ,   
//             .din  ( dout_layer_3 )  ,
//             .dout ( dout_layer_4 )                             

//  ) ;

//  layer_xor_new 
//     # (   .LUT_NUM_ONE_EQUATION  (LUT_NUM_LAYER_5),
//           .LUT_OUT_NUM_ONE_EQUATION ( LUT_OUT_NUM_LAYER_5 )
//         ) u_layer_5 
// ( 
//             .clk  ( clk )  ,   
//             .rst  ( rst )  ,   
//             .din  ( dout_layer_4 )  ,
//             .dout ( dout_layer_5 )                    

//  ) ;

// wire [LUT_OUT_NUM_LAYER_3*32-1:0] dout_layer_n ;
// wire sop ;
//  assign sop = din_en_ff[CMP_LAYER]&(~din_en_ff[CMP_LAYER+1]) ;
//  assign dout_layer_n = (sop == 1'b1)?(dout_layer_3^32'h6904BB59):(dout_layer_3) ; // not 9ADD2096， is 6904BB59


// reg eop ;

// always @(posedge clk or posedge rst) begin
//   if (rst == 1'b1) begin
//         eop <= 1'b0 ;  
//   end
//   else if (din_en_ff[CMP_LAYER+1]&(~din_en_ff[CMP_LAYER])) begin
//     eop <= 1'b1 ;  
//   end
//     else begin
//         eop <= 1'b0 ;  
//     end
// end



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
// 
// 

// always @(posedge clk or posedge rst) begin
//  if (rst == 1'b1) begin
//      din_en_ff <= 'd0 ;
//  end
//     else begin
//         din_en_ff <= { din_en_ff[14:0], din_en } ;
//     end
// end