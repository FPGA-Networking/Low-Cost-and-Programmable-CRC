

// multi lut pipe for different segment
// 

`timescale 1ns/1ps 

module lut_pipe_multi

# ( parameter   
                D_LUT_POLY               = 0 ,
                D_CRC_REG_INIT           = 0 ,
                SEG_NUM                  = 0 ,
                BUS_WIDTH                = 0 , // 1024
                BUS_WIDTH_MULTI_6        = 0 , // 1026
                MOD_WIDTH                = 0 ,
                CMP_LAYER                = 0 , // 4       // C_XOR之前计算的层数，包含第一层
                LUT_NUM_LAYER_1          = 0 , // 171 
                LUT_NUM_LAYER_2          = 0 , // 29  
                LUT_NUM_LAYER_3          = 0 , // 5   
                LUT_NUM_LAYER_4          = 0 , // 1   
                LUT_NUM_LAYER_5          = 0 , // 0   
                LUT_NUM_LAYER_6          = 0 , // 0   
                LUT_NUM_LAYER_7          = 0 , // 0   
                LUT_NUM_LAYER_8          = 0 ,  // 0            
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


            input                           clk            ,
            input                           rst            ,
            input  [SEG_NUM-1:0]            seg_sop        ,
            input  [SEG_NUM-1:0]            seg_eop        ,
            input  [SEG_NUM-1:0]            seg_dval       ,
            input  [SEG_NUM*4-1:0]          seg_packet_num ,
            input  [SEG_NUM*12-1:0]         seg_zero_num   ,
            input  [SEG_NUM*BUS_WIDTH-1:0]  seg_dout       ,             
            
            output  [SEG_NUM-1:0]            sop_out        ,
            output  [SEG_NUM-1:0]            eop_out        ,
            output  [SEG_NUM-1:0]            dval_out       ,
            output  [SEG_NUM*4-1:0]          packet_num_out ,
            output  [SEG_NUM*12-1:0]         zero_num_out   ,
            output  [SEG_NUM*32-1:0]         dout_out         
 ) ;


// LUT_POLY 

// file for generate the parameter : =
parameter [0:SEG_NUM*LUT_NUM_LAYER_1*64*16-1]   LUT_POLY     = D_LUT_POLY     ;
parameter [0:SEG_NUM*32-1]                      CRC_REG_INIT = D_CRC_REG_INIT ;



genvar i,j;
generate
        for (i=0; i<SEG_NUM; i=i+1) begin : multi_seg_process
            lut_pipe_top_new #(
                .BUS_WIDTH            ( BUS_WIDTH           ) , // 1024
                .BUS_WIDTH_MULTI_6    ( BUS_WIDTH_MULTI_6   ) , // 1026
                .MOD_WIDTH            ( MOD_WIDTH           ) ,
                .LUT_POLY             ( LUT_POLY[i*LUT_NUM_LAYER_1*64*16:((i+1)*LUT_NUM_LAYER_1*64*16-1)]            ) ,
                .CRC_REG_INIT         ( CRC_REG_INIT[i*32:((i+1)*32-1)]        ) ,//(SEG_NUM-1-i)*32:((SEG_NUM-1-i+1)*32-1)   not [i*32:((i+1)*32-1)]  because 第一段数据对应的CRC_INT其实是需要插入64组0的，也就是最后一个CRC_INT
                .CMP_LAYER            ( CMP_LAYER           ) , // 4       // C_XOR之前计算的层数，包含第一层
                .LUT_NUM_LAYER_1      ( LUT_NUM_LAYER_1     ) , // 171 
                .LUT_NUM_LAYER_2      ( LUT_NUM_LAYER_2     ) , // 29  
                .LUT_NUM_LAYER_3      ( LUT_NUM_LAYER_3     ) , // 5   
                .LUT_NUM_LAYER_4      ( LUT_NUM_LAYER_4     ) , // 1   
                .LUT_NUM_LAYER_5      ( LUT_NUM_LAYER_5     ) , // 0   
                .LUT_NUM_LAYER_6      ( LUT_NUM_LAYER_6     ) , // 0   
                .LUT_NUM_LAYER_7      ( LUT_NUM_LAYER_7     ) , // 0   
                .LUT_NUM_LAYER_8      ( LUT_NUM_LAYER_8     ) , // 0            
                .LUT_OUT_NUM_LAYER_1  ( LUT_OUT_NUM_LAYER_1 ) , // 174 
                .LUT_OUT_NUM_LAYER_2  ( LUT_OUT_NUM_LAYER_2 ) , // 30  
                .LUT_OUT_NUM_LAYER_3  ( LUT_OUT_NUM_LAYER_3 ) , // 6   
                .LUT_OUT_NUM_LAYER_4  ( LUT_OUT_NUM_LAYER_4 ) , // 1   
                .LUT_OUT_NUM_LAYER_5  ( LUT_OUT_NUM_LAYER_5 ) , // 0   
                .LUT_OUT_NUM_LAYER_6  ( LUT_OUT_NUM_LAYER_6 ) , // 0   
                .LUT_OUT_NUM_LAYER_7  ( LUT_OUT_NUM_LAYER_7 ) , // 0   
                .LUT_OUT_NUM_LAYER_8  ( LUT_OUT_NUM_LAYER_8 )   // 0 
            ) u_lut_pipe_top_new (
                .clk(clk),
                .rst(rst),
                .sop_in             ( seg_sop [i]                                ), // seg_sop [SEG_NUM-1-i] 
                .eop_in             ( seg_eop [i]                                ), // seg_eop [SEG_NUM-1-i] 
                .dval_in            ( seg_dval[i]                                ), // seg_dval[SEG_NUM-1-i] 
                .packet_num_in      ( seg_packet_num[4*(i+1)-1:4*i]               ),//seg_packet_num[4*(SEG_NUM-i)-1:4*(SEG_NUM-1-i)]          
                .mod_in             ( seg_zero_num[12*(i+1)-1:12*i]               ),//seg_zero_num[12*(SEG_NUM-i)-1:12*(SEG_NUM-1-i)]          
                .din                ( seg_dout[BUS_WIDTH*(i+1)-1:BUS_WIDTH*i]     ),//seg_dout[BUS_WIDTH*(SEG_NUM-i)-1:BUS_WIDTH*(SEG_NUM-1-i)]
                
                .sop_out            ( sop_out  [i]                               )  ,
                .eop_out            ( eop_out  [i]                               )  , // eop_out  [SEG_NUM-1-i]
                .dval_out           ( dval_out [i]                                )  , // dval_out [SEG_NUM-1-i]
                .packet_num_out     ( packet_num_out[4*(i+1)-1:4*i]               ), // packet_num_out[4*(SEG_NUM-i)-1:4*(SEG_NUM-1-i)]          
                .mod_out            ( zero_num_out[12*(i+1)-1:12*i]               ), // zero_num_out[12*(SEG_NUM-i)-1:12*(SEG_NUM-1-i)]          
                .dout               ( dout_out[32*(i+1)-1:32*i]                  )  // dout_out[32*(SEG_NUM-i)-1:BUS_WIDTH*(32-1-i)]
            );
        end
endgenerate















// reg            out_see_seg_sop[0:63]   ;
// reg            out_see_seg_eop[0:63]   ;
// reg            out_see_seg_dval[0:63]  ;
// reg [3:0]      out_see_seg_packet_num[0:63] ; // 4bit*64seg
// reg [11:0]     out_see_seg_zero_num[0:63] ; // 12bit*64seg the bytes from eo(in a certain segment) to the end of the beat(some segment are treated aszeros); 单位是字节
// reg [63:0]     out_see_seg_dout[0:63]  ; // 4096 bits with 64 seg  

// integer k ;
// always @(*) begin

//     for ( k=0; k<64; k=k+1 ) begin
//                out_see_seg_sop[k] <=  seg_sop [k]                              ;
//                out_see_seg_eop[k] <=  seg_eop [k]                              ;
//               out_see_seg_dval[k] <=  seg_dval[k]                              ;
//         out_see_seg_packet_num[k] <=  seg_packet_num [k*4+3 -: 4   ] ;
//           out_see_seg_zero_num[k] <=  seg_zero_num   [k*12+11 -: 12] ;
//               out_see_seg_dout[k] <=  seg_dout       [(k+1)*BUS_WIDTH-1 -: BUS_WIDTH] ;
//     end


// end



// reg            out_see_crc_seg_eop[0:63]   ;
// reg            out_see_crc_seg_dval[0:63]  ;
// reg [31:0]     out_see_crc_seg_dout[0:63]  ; // 2048 bits with 64 seg  



// always @(*) begin

//     for ( k=0; k<64; k=k+1 ) begin
//                out_see_crc_seg_eop[k] <=  eop_out [k]                              ;
//               out_see_crc_seg_dval[k] <=  dval_out[k]                              ;
//               out_see_crc_seg_dout[k] <=  dout_out       [(k+1)*32-1 -: 32] ;
//     end


// end





endmodule


//
// .clk(clk),
// .rst(rst),
// .sop_in              ( seg_sop [i]                               ), //   seg_sop [SEG_NUM-1-i] 
// .eop_in              ( seg_eop [i]                               ), //   seg_eop [SEG_NUM-1-i] 
// .dval_in             ( seg_dval[i]                               ), //   seg_dval[SEG_NUM-1-i] 
// .packet_num_in       ( seg_packet_num[4*(i+1)-1:4*i]             ),//  seg_packet_num[4*(SEG_NUM-i)-1:4*(SEG_NUM-1-i)]          
// .mod_in              ( seg_zero_num[12*(i+1)-1:12*i]             ),//  seg_zero_num[12*(SEG_NUM-i)-1:12*(SEG_NUM-1-i)]          
// .din                 ( seg_dout[BUS_WIDTH*(i+1)-1:BUS_WIDTH*i]   ),//  seg_dout[BUS_WIDTH*(SEG_NUM-i)-1:BUS_WIDTH*(SEG_NUM-1-i)]
// .eop_out             ( eop_out  [i]                              ), //                     eop_out  [SEG_NUM-1-i]
// .dval_out            ( dval_out [i]                              ), //                     dval_out [SEG_NUM-1-i]
// .packet_num_out      ( packet_num_out[4*(i+1)-1:4*i]             ), // packet_num_out[4*(SEG_NUM-i)-1:4*(SEG_NUM-1-i)]          
// .mod_out             ( zero_num_out[12*(i+1)-1:12*i]             ), // zero_num_out[12*(SEG_NUM-i)-1:12*(SEG_NUM-1-i)]          
// .dout                ( dout_out[32*(i+1)-1:32*i]                 )  //               dout_out[32*(SEG_NUM-i)-1:32*(SEG_NUM-1-i)]
