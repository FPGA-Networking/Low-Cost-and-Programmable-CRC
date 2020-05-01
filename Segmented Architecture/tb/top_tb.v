

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
// Author       :  Liu-Huan
// Email        :  assasin9997@163.com
// Data         :  
// Version      :  V 1.0 
// 
// Abstract     :  
//
//
//
// Called by    :  
// 
// Modification history
// ---------------------------------------------------------------------
// 
//
// *********************************************************************

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
 module top_tb ;
//*******************
//DEFINE LOCAL PARAMETER
//*******************
//Parameter(s)
//
//

parameter CLK_PERIOD    =     6.4 ; // 156.25Mhz
parameter CLK_1_PERIOD  =     CLK_PERIOD/64 ;

    
//*****************    
//INNER SIGNAL DECLARATION
//*********************
//REGS    
 reg   clk ;
 reg clk_1 ; 
 reg   rst ;
    
wire         crc_en_function  ;
wire  [31:0] crc_function     ;

wire         crc_en_compute  ;
wire  [31:0] crc_compute     ;

wire [15:0]     frm_len ;
wire sop ;
wire eop ;
wire dval;
wire [2:0] mod ; 
wire [63:0] data ;

//WIRES   
 // wire  crc_en_1024      ;
 // wire  [31:0] crc_1024  ;
    
//*********************
//INSTANTCE MODULE
//*********************

//**************************************************************
//instance of module DEMO filename:demo.v
//**************************************************************

  
  
  
  
  
  
  
//*********************
//MAIN CORE
//*********************    
    
    
    
 initial begin 
    clk = 1'b0 ;
    clk_1 = 1'b0 ;
    rst = 1'b1 ;
    # 50
    rst = 1'b0 ;
 end 
 
 
 always # (CLK_PERIOD/2)  clk = ~clk ; // 100Mhz
 always # (CLK_1_PERIOD/2)  clk_1 = ~clk_1 ; // 64*100Mhz
 
// wire clk_2  ;


// assign #2.012 clk_2 =  clk ;




wire  [63:0]      out_seg_sop;
wire  [63:0]      out_seg_eop;
wire  [63:0]      out_seg_dval;
wire  [255:0]     out_seg_packet_num;
wire  [767:0]     out_seg_zero_num;
wire  [4095:0]    out_seg_dout;

wire              bit_64_sop    ;
wire              bit_64_eop    ;
wire              bit_64_dval   ;
wire  [2:0]       bit_64_mod    ;
wire  [63:0]      bit_64_dout   ;



data_source_top #(
    .SEG_NUM     ( 64 ),
    .MAX_PKT_NUM ( 9  ))
 u_data_source_top (
    .clk                     ( clk_1                  ), // 64*100Mhz
    .clk_out                 ( clk              ), // 100Mhz with latency


    .out_sop  ( bit_64_sop  ) ,
    .out_eop  ( bit_64_eop  ) ,
    .out_dval ( bit_64_dval ) ,
    .out_mod  ( bit_64_mod  ) ,
    .out_dout ( bit_64_dout ) ,    


    .out_seg_sop             ( out_seg_sop          ),
    .out_seg_eop             ( out_seg_eop          ),
    .out_seg_dval            ( out_seg_dval         ),
    .out_seg_packet_num      ( out_seg_packet_num   ),
    .out_seg_zero_num        ( out_seg_zero_num     ),
    .out_seg_dout            ( out_seg_dout         )
);


CRC_GEN_NEW U_CRC_GEN_NEW
  ( 
        .clk     ( clk_1 )     ,
        .rst     ( rst )     ,
        .dval    ( bit_64_dval )     ,
        .sop     ( bit_64_sop  )     ,
        .eop     ( bit_64_eop  )     ,
        .mod     ( bit_64_mod  )     ,
        .din     ( bit_64_dout  )     ,
        .crc_en  ( crc_en_function )     ,
        .crc     ( crc_function )
 )  ;




wire [8-1:0]    crc_en_out ;
wire [32*8-1:0] crc_out    ;

top_64  u_top_64   (     
            .clk    ( clk )     ,
            .rst    ( rst )     ,
        .seg_sop        ( out_seg_sop        ) ,
        .seg_eop        ( out_seg_eop        ) ,
        .seg_dval       ( out_seg_dval       ) ,
        .seg_packet_num ( out_seg_packet_num ) ,
        .seg_zero_num   ( out_seg_zero_num   ) ,
        .seg_dout       ( out_seg_dout       ) , 

            .crc_en_out  ( crc_en_out )  ,
            .crc_out     ( crc_out    )  

              ) ;

reg [15:0] error_cnt ;
always @(posedge clk_1 or posedge rst) begin
    if (rst == 1'b1) begin
        error_cnt <= 'b0 ;
    end
    else if (crc_en_compute == 1'b1 && crc_compute != 32'h1CDF4421 ) begin
        error_cnt <= error_cnt+1'b1 ;
    end
    else begin
        error_cnt <= error_cnt ;
    end
end

reg [31:0] crc_compute_cnt ;
reg [31:0] crc_function_cnt ;
reg [31:0] sop_cnt ;


always @(posedge clk_1 or posedge rst) begin
    if (rst == 1'b1) begin
        sop_cnt <= 'b0 ;
    end
    else if (bit_64_sop) begin
        sop_cnt <= sop_cnt+1'b1 ;
    end
    else begin
        sop_cnt <= sop_cnt ;
    end
end


always @(posedge clk_1 or posedge rst) begin
    if (rst == 1'b1) begin
        crc_compute_cnt <= 'b0 ;
    end
    else if (crc_en_compute) begin
        crc_compute_cnt <=crc_compute_cnt+1'b1 ;
    end
    else begin
        crc_compute_cnt <= crc_compute_cnt ;        
    end
end

always @(posedge clk_1 or posedge rst) begin
    if (rst == 1'b1) begin
        crc_function_cnt <= 'b0 ;
    end
    else if (crc_en_function) begin
        crc_function_cnt <=crc_function_cnt+1'b1 ;
    end
    else begin
        crc_function_cnt <= crc_function_cnt ;        
    end
end




// CRC_RESULT_SEE

reg crc_result_see [0:7] ;

integer i3, j3 ;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset
       for ( i3=0; i3<8; i3=i3+1 ) begin
           crc_result_see[i3] <= 1'b0 ;
       end
    end
    else begin
       for ( j3=0; j3<8; j3=j3+1 ) begin
           if ( crc_en_out[j3]==1'b1 && crc_out[32*(j3+1)-1 -: 32] != 32'h1CDF4421 ) begin
               crc_result_see[j3] <= 1'b1 ;
           end
           else begin
               crc_result_see[j3] <= 1'b0 ;
           end
       end
    end
end



reg [31:0] crc_out_cnt = 'b0 ;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        crc_out_cnt <= 'b0 ;
    end

    if ( |crc_en_out == 1'b1 ) begin
        crc_out_cnt <= crc_out_cnt + 1'b1 ;
    end

    else if ( crc_out_cnt == 'b0 ) begin
        crc_out_cnt <= 'b0 ;
    end

    else begin
        crc_out_cnt <= crc_out_cnt+1'b1 ;
    end
end


reg [31:0] data_4096_cnt = 'b0 ;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_4096_cnt <= 'b0 ;
    end

    if ( |out_seg_sop == 1'b1 ) begin
        data_4096_cnt <= data_4096_cnt + 1'b1 ;
    end

    else if ( data_4096_cnt == 'b0 ) begin
        data_4096_cnt <= 'b0 ;
    end

    else begin
        data_4096_cnt <= data_4096_cnt+1'b1 ;
    end
end


// wire [8-1:0]    crc_en_out ;
// wire [32*8-1:0] crc_out    ;



reg            see_seg_sop[0:63]   ;
reg            see_seg_eop[0:63]   ;
reg            see_seg_dval[0:63]  ;
reg [3:0]      see_seg_packet_num[0:63] ; // 4bit*64seg
reg [11:0]     see_seg_zero_num[0:63] ; // 12bit*64seg the bytes from eo(in a certain segment) to the end of the beat(some segment are treated aszeros); 单位是字节
reg [63:0]     see_seg_dout[0:63]  ; // 4096 bits with 64 seg  


integer i ;

always @(*) begin

    for ( i=0; i<64; i=i+1 ) begin
               see_seg_sop[i] <=         out_seg_sop[i]   ;       
               see_seg_eop[i] <=         out_seg_eop[i]   ;       
              see_seg_dval[i] <=        out_seg_dval[i]   ;      
        see_seg_packet_num[i] <=  out_seg_packet_num[i*4+3 -: 4]     ;
          see_seg_zero_num[i] <=    out_seg_zero_num[i*12+11 -: 12]  ;  
              see_seg_dout[i] <=        out_seg_dout[i*64+63 -: 64]  ;      
    end


end




//*********************     
endmodule
 
// CRC_GEN_NEW U_CRC_GEN_NEW
//   ( 
//         .clk     ( clk )     ,
//         .rst     ( rst )     ,
//         .dval    ( dval )     ,
//         .sop     ( sop  )     ,
//         .eop     ( eop  )     ,
//         .mod     ( mod  )     ,
//         .din     ( data  )     ,
//         .crc_en  ( crc_en )     ,
//         .crc     ( crc )
//  )  ;

// data_source_top  u_data_source_top   (     
//         .clk     ( clk ) ,
//         .clk_1   ( clk_1 ) ,
//         .frm_len ( frm_len ) ,
//         .sop     ( sop   ) ,
//         .eop     ( eop   ) ,
//         .dval    ( dval  ) ,
//         .mod     ( mod   ) ,
//         .dout    ( data  )      
//               ) ;