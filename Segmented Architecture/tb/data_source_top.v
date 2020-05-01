
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
module  data_source_top   (     
            input                  clk     , // 156.25*64 Mhz
            input                  clk_out , // 156.25Mhz
            // output reg  [15:0]     frm_len ,
            // output reg             sop     ,
            // output reg             eop     ,
            // output reg             dval    ,
            // output reg [2:0]       mod     ,
            // output reg [63:0]      dout       
            output              out_sop     ,
            output              out_eop     ,
            output              out_dval    ,
            output  [2:0]       out_mod     ,
            output  [63:0]      out_dout    ,  



            output reg [63:0]      out_seg_sop     ,
            output reg [63:0]      out_seg_eop     ,
            output reg [63:0]      out_seg_dval    ,
            output reg [255:0]     out_seg_packet_num , // 4bit*64seg
            output reg [767:0]     out_seg_zero_num, // 12bit*64seg the bytes from eop(in a certain segment) to the end of the beat(some segment are treated as zeros); 单位是字节
            output reg [4095:0]    out_seg_dout // 4096 bits with 64 seg        
              ) ;

//*******************
//DEFINE LOCAL PARAMETER
//*******************
//parameter(s)
                                    
 

//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
reg  [15:0]     frm_len ; //  
reg             sop     ; //  
reg             eop     ; //  
reg             dval    ; //  
reg [2:0]       mod     ; //  
reg [63:0]      dout    ; // with input reverse 


reg  [15:0]     no_reverse_frm_len ;
reg             no_reverse_sop     ;
reg             no_reverse_eop     ;
reg             no_reverse_dval    ;
reg [2:0]       no_reverse_mod     ;
reg [63:0]      no_reverse_dout    ; // with no input reverse 

//WIRES
 

//*********************
//INSTANTCE MODULE
//*********************
// 字节逆序函数
function [7:0] reverse_8b;
  input [7:0]   data;
  integer        i;
    begin
        for (i = 0; i < 8; i = i + 1) begin
            reverse_8b[i] = data[7 - i];
        end
    end
endfunction



//*********************
//MAIN CORE
//********************* 
reg [15:0] time_cnt ;    
reg [31:0] cnt ;

initial begin
    time_cnt = 'd0 ;
    cnt      = 'd0 ;
end


always @(posedge clk) begin

    if ( time_cnt == 'd1000 ) begin
        time_cnt <= time_cnt ;
    end
    else begin
        time_cnt <= time_cnt+1'b1 ;
    end
end

always @(posedge clk) begin

    if ( time_cnt >'d900 ) begin
        if ( cnt == 'd32767 ) begin // 8192*4-1
            cnt <= 'd0 ;
        end
        else begin
           cnt <= cnt+1'b1 ; 
        end
    end
    else begin
        cnt <= 'd0 ;
    end
end


wire              w_64_sop  ;
wire              w_64_eop  ;
wire              w_64_dval ;
wire  [2:0]       w_64_mod  ;
wire  [63:0]      w_64_dout ;

wire              w_65_sop  ;
wire              w_65_eop  ;
wire              w_65_dval ;
wire  [2:0]       w_65_mod  ;
wire  [63:0]      w_65_dout ;

wire              w_1518_sop  ;
wire              w_1518_eop  ;
wire              w_1518_dval ;
wire  [2:0]       w_1518_mod  ;
wire  [63:0]      w_1518_dout ;

wire              random_sop  ;
wire              random_eop  ;
wire              random_dval ;
wire  [2:0]       random_mod  ;
wire  [63:0]      random_dout ;



// data_source_64  u_data_source_64   (     
//             .clk   ( clk )    ,
//             .sop   ( w_64_sop  )    ,
//             .eop   ( w_64_eop  )    ,
//             .dval  ( w_64_dval )    ,
//             .mod   ( w_64_mod  )    ,
//             .dout  ( w_64_dout )         
//               ) ;

data_source_512  u_data_source_512   (     
            .clk   ( clk )    ,
            .sop   ( w_64_sop  )    ,
            .eop   ( w_64_eop  )    ,
            .dval  ( w_64_dval )    ,
            .mod   ( w_64_mod  )    ,
            .dout  ( w_64_dout )         
              ) ;

data_source_65  u_data_source_65   (     
            .clk   ( clk )    ,
            .sop   ( w_65_sop  )    ,
            .eop   ( w_65_eop  )    ,
            .dval  ( w_65_dval )    ,
            .mod   ( w_65_mod  )    ,
            .dout  ( w_65_dout )         
              ) ;

data_source_1518  u_data_source_1518  (     
            .clk   ( clk )    ,
            .sop   ( w_1518_sop  )    ,
            .eop   ( w_1518_eop  )    ,
            .dval  ( w_1518_dval )    ,
            .mod   ( w_1518_mod  )    ,
            .dout  ( w_1518_dout )         
              ) ;

data_source_random  u_data_source_random   (     
            .clk   ( clk )    ,
            .sop   ( random_sop  )    ,
            .eop   ( random_eop  )    ,
            .dval  ( random_dval )    ,
            .mod   ( random_mod  )    ,
            .dout  ( random_dout )         
              ) ;

initial begin
    frm_len = 'b0 ;
    sop     = 'b0 ;
    eop     = 'b0 ;
    dval    = 'b0 ;
    mod     = 'b0 ;
    dout    = 'b0 ;
    
    no_reverse_frm_len = 'b0 ;
    no_reverse_sop     = 'b0 ;
    no_reverse_eop     = 'b0 ;
    no_reverse_dval    = 'b0 ;
    no_reverse_mod     = 'b0 ;
    no_reverse_dout    = 'b0 ;


end

always @(posedge clk ) begin
    if (  cnt<'d8192  ) begin
        no_reverse_frm_len  <= 'd64 ;
        no_reverse_sop      <= w_64_sop  ;
        no_reverse_eop      <= w_64_eop  ;
        no_reverse_dval     <= w_64_dval ;
        no_reverse_mod      <= w_64_mod  ;
        no_reverse_dout     <= w_64_dout ;
    end
    else if (  cnt<'d16384  ) begin
        no_reverse_frm_len  <= 'd65 ;
        no_reverse_sop      <= w_65_sop  ;
        no_reverse_eop      <= w_65_eop  ;
        no_reverse_dval     <= w_65_dval ;
        no_reverse_mod      <= w_65_mod  ;
        no_reverse_dout     <= w_65_dout ;
    end
    else if (  cnt<'d24576  ) begin
        no_reverse_frm_len  <= 'd1518 ;
        no_reverse_sop      <= w_1518_sop  ;
        no_reverse_eop      <= w_1518_eop  ;
        no_reverse_dval     <= w_1518_dval ;
        no_reverse_mod      <= w_1518_mod  ;
        no_reverse_dout     <= w_1518_dout ;
    end
    else if (  cnt<'d32768  ) begin
        no_reverse_frm_len  <= 'd0 ;
        no_reverse_sop      <= random_sop  ;
        no_reverse_eop      <= random_eop  ;
        no_reverse_dval     <= random_dval ;
        no_reverse_mod      <= random_mod  ;
        no_reverse_dout     <= random_dout ;
    end
    else begin
        no_reverse_frm_len  <= 'd0 ;
        no_reverse_sop      <= 'd0 ;
        no_reverse_eop      <= 'd0 ;
        no_reverse_dval     <= 'd0 ;
        no_reverse_mod      <= 'd0 ;
        no_reverse_dout     <= 'd0 ;
    end
end

// ======================= input reverse ===================



always @(posedge clk ) begin
    // if (rst) begin
    //     frm_len   <= 'b0 ;
    //     sop       <= 'b0 ;
    //     eop       <= 'b0 ;
    //     dval      <= 'b0 ;
    //     mod       <= 'b0 ;
    //     dout      <= 'b0 ;
    // end
    // else begin
        frm_len   <= no_reverse_frm_len;
        sop       <= no_reverse_sop    ;
        eop       <= no_reverse_eop    ;
        dval      <= no_reverse_dval   ;
        mod       <= no_reverse_mod    ;     
        dout       <= /*din ;*/

        {       reverse_8b(no_reverse_dout[63:56]),  
                reverse_8b(no_reverse_dout[55:48]),  
                reverse_8b(no_reverse_dout[47:40]),
                reverse_8b(no_reverse_dout[39:32]),
                reverse_8b(no_reverse_dout[31:24]),
                reverse_8b(no_reverse_dout[23:16]),
                reverse_8b(no_reverse_dout[15:8]),
                reverse_8b(no_reverse_dout[7:0])
        }  ;        
    // end
end

assign out_sop  = sop   ;
assign out_eop  = eop   ;
assign out_dval = dval  ;
assign out_mod  = mod   ;
assign out_dout = dout  ;









// ========= the following is the segmented data(convert from the non-segmented data)==============

reg seg_en = 'b0 ;
always @(posedge clk ) begin
    if ( no_reverse_sop == 1'b1 ) begin
        seg_en <= 1'b1 ;
    end
    else begin
        seg_en <= seg_en ;
    end
end











reg [63:0]      seg_sop = 'd0    ;
reg [63:0]      seg_eop = 'd0    ;
reg [63:0]      seg_dval = 'd0   ;
reg [255:0]     seg_packet_num = 'd0 ; // 4bit*64seg
reg [767:0]     seg_zero_num = 'd0; // 12bit*64seg the bytes from eo(in a certain segment) to the end of the beat(some segment are treated aszeros); 单位是字节
reg [4095:0]    seg_dout = 'd0; // 4096 bits with 64 seg  

reg [3:0] eop_cnt = 'd0 ;   
// reg [3:0] seg_pkt_num = 'd0 ;

parameter SEG_NUM = 64 ; // 4096bit bus with 64 seg
parameter MAX_PKT_NUM = 9 ; // 一拍最多9个包，因为1个包最短512bit
reg [7:0] seg_cnt = SEG_NUM-1 ; //  在这里8字节为一段，一拍（beat）传输64段(模拟总线位宽4096bits)


always @( posedge clk ) begin
    if ( seg_en == 1'b1 ) begin
        if ( seg_cnt == 0 )
            seg_cnt <= SEG_NUM-1 ;
        else 
            seg_cnt <=seg_cnt-1'b1 ;    
    end
    else begin
        seg_cnt <= SEG_NUM-1 ;
    end
end

// 

always @(posedge clk ) begin
    if ( seg_en == 1'b1 ) begin
        // for ( i=0; i<64; i=i+1 ) begin
            
            
            
            seg_dout[seg_cnt*64+63 -: 64] <= dout ;
            seg_sop [seg_cnt] <= sop     ;
            seg_eop [seg_cnt] <= eop     ;
            seg_dval[seg_cnt] <= dval    ;






            if (eop == 1'b1) begin
                if ( mod == 0 )
                    seg_zero_num[seg_cnt*12+11 -: 12] <= seg_cnt*8 ;
                else
                    seg_zero_num[seg_cnt*12+11 -: 12] <= seg_cnt*8+(8-mod) ;
            end 
            else begin
                seg_zero_num[seg_cnt*12+11 -: 12] <= 'b0 ;
            end

            if ( eop == 1'b1 && eop_cnt == 'd7 ) begin
                eop_cnt <= 'd0 ;
            end
            else if ( eop == 1'b1 ) begin
                eop_cnt <= eop_cnt+1'b1 ;
            end
            else begin
                eop_cnt <= eop_cnt ;
            end

            seg_packet_num[seg_cnt*4+3 -: 4] <= eop_cnt%8+1 ; // eop_cnt%9+1 ;
            // if ( eop == 1'b1 ) begin
            //     seg_packet_num[seg_cnt*4+3 -: 4] <= eop_cnt%9+1+1 ;
            // end
            // else begin
            //     seg_packet_num[seg_cnt*4+3 -: 4] <= eop_cnt%9+1 ;
            // end
            // // seg_pkt_num <= eop_cnt%9+1 ;
            // if (sop == 1'b1) begin
            //   seg_packet_num[seg_cnt*4+3 -: 4] <= eop_cnt%9+1 ; // from 1 to 9
            // end
            // else begin
                
            // end
            // else begin
                
            // end
            

            



            
        // end
    end    
    else begin
        // for ( i=0; i<64; i=i+1 ) begin
            seg_dout[seg_cnt*64+63 -: 64] <= 'b0 ;
            seg_sop [seg_cnt] <= 'b0 ;
            seg_eop [seg_cnt] <= 'b0 ;
            seg_dval[seg_cnt] <= 'b0 ;
            seg_zero_num    <= 'b0 ;               
            seg_packet_num  <= 'b0 ;               

        // end
    end
end


reg [5:0] clk_64_156_cnt = 'b0 ; // 
always @(posedge clk ) begin
    clk_64_156_cnt <= clk_64_156_cnt + 1'b1 ;
end


always @(negedge clk ) begin
    if ( clk_64_156_cnt == 'd10 ) begin
        out_seg_sop        <= seg_sop           ;
        out_seg_eop        <= seg_eop           ;
        out_seg_dval       <= seg_dval          ;
        out_seg_packet_num <= seg_packet_num    ;
        out_seg_zero_num   <= seg_zero_num      ;
        out_seg_dout       <= seg_dout          ;
    end
    else begin
        out_seg_sop        <= out_seg_sop        ;
        out_seg_eop        <= out_seg_eop        ;
        out_seg_dval       <= out_seg_dval       ;
        out_seg_packet_num <= out_seg_packet_num ;
        out_seg_zero_num   <= out_seg_zero_num   ;
        out_seg_dout       <= out_seg_dout       ;
    end
end



reg            see_seg_sop[0:63]   ;
reg            see_seg_eop[0:63]   ;
reg            see_seg_dval[0:63]  ;
reg [3:0]      see_seg_packet_num[0:63] ; // 4bit*64seg
reg [11:0]     see_seg_zero_num[0:63] ; // 12bit*64seg the bytes from eo(in a certain segment) to the end of the beat(some segment are treated aszeros); 单位是字节
reg [63:0]     see_seg_dout[0:63]  ; // 4096 bits with 64 seg  


integer i ;

always @(*) begin

    for ( i=0; i<64; i=i+1 ) begin
               see_seg_sop[i] <=         seg_sop[i]   ;       
               see_seg_eop[i] <=         seg_eop[i]   ;       
              see_seg_dval[i] <=        seg_dval[i]   ;      
        see_seg_packet_num[i] <=  seg_packet_num[i*4+3 -: 4]     ;
          see_seg_zero_num[i] <=    seg_zero_num[i*12+11 -: 12]  ;  
              see_seg_dout[i] <=        seg_dout[i*64+63 -: 64]  ;      
    end


end


reg            out_see_seg_sop[0:63]   ;
reg            out_see_seg_eop[0:63]   ;
reg            out_see_seg_dval[0:63]  ;
reg [3:0]      out_see_seg_packet_num[0:63] ; // 4bit*64seg
reg [11:0]     out_see_seg_zero_num[0:63] ; // 12bit*64seg the bytes from eo(in a certain segment) to the end of the beat(some segment are treated aszeros); 单位是字节
reg [63:0]     out_see_seg_dout[0:63]  ; // 4096 bits with 64 seg  


always @(*) begin

    for ( i=0; i<64; i=i+1 ) begin
               out_see_seg_sop[i] <=         out_seg_sop[i]   ;       
               out_see_seg_eop[i] <=         out_seg_eop[i]   ;       
              out_see_seg_dval[i] <=        out_seg_dval[i]   ;      
        out_see_seg_packet_num[i] <=  out_seg_packet_num[i*4+3 -: 4]     ;
          out_see_seg_zero_num[i] <=    out_seg_zero_num[i*12+11 -: 12]  ;  
              out_see_seg_dout[i] <=        out_seg_dout[i*64+63 -: 64]  ;      
    end


end







//*********************
endmodule   


// if (eop == 1'b1) begin
//                 if (seg_packet_num[seg_cnt*4+3 -: 4] == MAX_PKT_NUM-1'b1 ) begin
//                     seg_packet_num[seg_cnt*4+3 -: 4] <= 'b0 ;
//                 end
//                 else begin
//                     seg_packet_num[seg_cnt*4+3 -: 4] <= seg_packet_num[seg_cnt*4+3 -: 4]+1'b1 ;
//                 end    
//             end 
//             else begin
//                 seg_packet_num[seg_cnt*4+3 -: 4] <= 'b0 ;
//             end