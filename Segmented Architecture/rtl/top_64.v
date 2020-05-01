

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
module  top_64 

# ( parameter   
                SEG_NUM              = 64   ,
                BUS_WIDTH            = 64   ,
                BUS_WIDTH_MULTI_6    = 65   ,
                MOD_WIDTH            = 12   ,    // clogb2(BUS_WIDTH/8)
                CMP_LAYER            = 2    ,  //3  ,      // C_XOR之前计算的层数，包含第一层
                GO_BACK_STAGE        = 3  , // stride=1时，这个值等于9；stride=8时，这个值等于3
                LUT_NUM_LAYER_1      = 13 ,
                LUT_NUM_LAYER_2      = 3  ,
                LUT_NUM_LAYER_3      = 1  ,
                LUT_NUM_LAYER_4      = 0  ,
                LUT_NUM_LAYER_5      = 0  ,
                LUT_NUM_LAYER_6      = 0  ,
                LUT_NUM_LAYER_7      = 0  ,
                LUT_NUM_LAYER_8      = 0  ,                
                LUT_OUT_NUM_LAYER_1  = 13 ,
                LUT_OUT_NUM_LAYER_2  = 6  ,
                LUT_OUT_NUM_LAYER_3  = 1  ,
                LUT_OUT_NUM_LAYER_4  = 0  ,
                LUT_OUT_NUM_LAYER_5  = 0  ,
                LUT_OUT_NUM_LAYER_6  = 0  ,
                LUT_OUT_NUM_LAYER_7  = 0  ,
                LUT_OUT_NUM_LAYER_8  = 0  ,
                PKT_NUM              =  SEG_NUM*BUS_WIDTH/512   
        )

  (     
            input	clk 	,
            input	rst 	,

            input  [SEG_NUM-1:0]            seg_sop        ,
            input  [SEG_NUM-1:0]            seg_eop        ,
            input  [SEG_NUM-1:0]            seg_dval       ,
            input  [SEG_NUM*4-1:0]          seg_packet_num ,
            input  [SEG_NUM*12-1:0]         seg_zero_num   ,
            input  [SEG_NUM*BUS_WIDTH-1:0]  seg_dout       ,

            output [PKT_NUM-1:0]    crc_en_out ,
            output [32*PKT_NUM-1:0] crc_out

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
 wire [31:0] crc_net ; // 网站生成的CRC函数
 wire [31:0] crc_my  ; // 我生成的CRC函数
 wire [31:0] crc_pipe;






 wire [PKT_NUM-1:0]    crc_en_out_pre_reverse ;
 wire [32*PKT_NUM-1:0] crc_out_pre_reverse ;


//*********************
//INSTANTCE MODULE
//*********************

function integer clogb2 (input integer bit_depth);
begin
for(clogb2=0; bit_depth>1; clogb2=clogb2+1)
bit_depth = bit_depth>>1;
end
endfunction


//*********************
//MAIN CORE
//********************* 




go_back_top  
# (     
    .SEG_NUM             ( SEG_NUM             )  ,
    .BUS_WIDTH           ( BUS_WIDTH           )  ,
    .BUS_WIDTH_MULTI_6   ( BUS_WIDTH_MULTI_6   )  ,
    .MOD_WIDTH           ( MOD_WIDTH           )  ,
    .CMP_LAYER           ( CMP_LAYER           ),      // C_XOR之前计算的层数，包含第一层
    .GO_BACK_STAGE       ( GO_BACK_STAGE       ),
    .LUT_NUM_LAYER_1     ( LUT_NUM_LAYER_1     ),
    .LUT_NUM_LAYER_2     ( LUT_NUM_LAYER_2     ),
    .LUT_NUM_LAYER_3     ( LUT_NUM_LAYER_3     ),
    .LUT_NUM_LAYER_4     ( LUT_NUM_LAYER_4     ),
    .LUT_NUM_LAYER_5     ( LUT_NUM_LAYER_5     ),
    .LUT_NUM_LAYER_6     ( LUT_NUM_LAYER_6     ),
    .LUT_NUM_LAYER_7     ( LUT_NUM_LAYER_7     ),
    .LUT_NUM_LAYER_8     ( LUT_NUM_LAYER_8     ),                
    .LUT_OUT_NUM_LAYER_1 ( LUT_OUT_NUM_LAYER_1 ),
    .LUT_OUT_NUM_LAYER_2 ( LUT_OUT_NUM_LAYER_2 ),
    .LUT_OUT_NUM_LAYER_3 ( LUT_OUT_NUM_LAYER_3 ),
    .LUT_OUT_NUM_LAYER_4 ( LUT_OUT_NUM_LAYER_4 ),
    .LUT_OUT_NUM_LAYER_5 ( LUT_OUT_NUM_LAYER_5 ),
    .LUT_OUT_NUM_LAYER_6 ( LUT_OUT_NUM_LAYER_6 ),
    .LUT_OUT_NUM_LAYER_7 ( LUT_OUT_NUM_LAYER_7 ),
    .LUT_OUT_NUM_LAYER_8 ( LUT_OUT_NUM_LAYER_8 ),
    .PKT_NUM (PKT_NUM)   
        )

u_go_back_top   (     
        .clk     ( clk )  ,
        .rst     ( rst )  ,
        .seg_sop        ( seg_sop        ) ,
        .seg_eop        ( seg_eop        ) ,
        .seg_dval       ( seg_dval       ) ,
        .seg_packet_num ( seg_packet_num ) ,
        .seg_zero_num   ( seg_zero_num   ) ,
        .seg_dout       ( seg_dout       ) ,  
        .crc_en  ( crc_en_out_pre_reverse )  ,
        .crc     ( crc_out_pre_reverse    )     


              ) ;


// no reverse
// assign crc_en_out = crc_en_out_pre_reverse  ;
// assign crc_out    = crc_out_pre_reverse     ;



genvar i;
generate
        for (i=0; i<PKT_NUM; i=i+1) begin : multi_reverse
            reverse_crc  u_reverse_crc   (     
                        .clk        ( clk ) ,
                        .rst        ( rst ) ,
                        .crc_en_in  ( crc_en_out_pre_reverse[i]            )  ,
                        .crc_in     (    crc_out_pre_reverse[32*(i+1)-1 -:32 ] )  ,
                        .crc_en_out ( crc_en_out[i]            )  ,
                        .crc_out    (    crc_out[32*(i+1)-1 -:32 ] )            
                          ) ;
        end
endgenerate

//*********************
endmodule   