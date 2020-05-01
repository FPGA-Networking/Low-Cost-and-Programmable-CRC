

`timescale 1ns/1ps 


module merge_element



( 

        input                           clk  ,
        input                           rst  ,

        input                          sop_out_up        ,
        input                          eop_out_up        ,
        input                         dval_out_up        ,
        input    [3:0]          packet_num_out_up        ,
        input    [11:0]           zero_num_out_up        ,
        input    [31:0]               dout_out_up        ,


        input                          sop_out_mid        ,
        input                          eop_out_mid        ,
        input                         dval_out_mid        ,
        input    [3:0]          packet_num_out_mid        ,
        input    [11:0]           zero_num_out_mid        ,
        input    [31:0]               dout_out_mid        ,

        input                          sop_out_low        ,
        input                          eop_out_low        ,
        input                         dval_out_low        ,
        input    [3:0]          packet_num_out_low        ,
        input    [11:0]           zero_num_out_low        ,
        input    [31:0]               dout_out_low        ,


        output reg                           merge_sop_out        ,
        output reg                           merge_eop_out        ,
        output reg                           merge_dval_out       ,
        output reg  [3:0]                    merge_packet_num_out ,
        output reg  [11:0]                   merge_zero_num_out   ,
        output reg  [31:0]                   merge_dout_out       



 ) ;


reg                             sop_pre             ;
reg                             eop_pre             ;
reg                             dval_pre            ;
reg    [3:0]                    packet_num_pre      ;
reg    [11:0]                   zero_num_pre        ;
reg    [31:0]                   dout_up_pre         ;
reg    [31:0]                   dout_mid_pre        ;
reg    [31:0]                   dout_low_pre        ;


always @(posedge clk  ) begin



        sop_pre        <= sop_out_up|sop_out_mid  ; // 上段是sop 或 中段是sop
        eop_pre        <= eop_out_mid|eop_out_low ; // 中段是eop 或 下段是eop
        dval_pre       <= dval_out_mid ;            // 上段有效，中段必然有效，因为一段小于32字节
        packet_num_pre <= packet_num_out_mid ;      // 包号就是中间段的包号
        zero_num_pre   <= zero_num_out_mid|zero_num_out_low ; // 和eop道理一样

end


always @(posedge clk ) begin


        dout_mid_pre <= dout_out_mid ;
        

end


always @(posedge clk ) begin


        if ( sop_out_up == 1'b1 )
            dout_up_pre <= dout_out_up ;
        else 
            dout_up_pre <= 'b0 ; 
        

end

always @(posedge clk ) begin


        if ( sop_out_low == 1'b1 )
            dout_low_pre <= 'b0 ;
        else 
            dout_low_pre <= dout_out_low ; 
        

end

always @(posedge clk ) begin

        merge_sop_out        <= sop_pre          ;
        merge_eop_out        <= eop_pre          ;
        merge_dval_out       <= dval_pre         ;
        merge_packet_num_out <= packet_num_pre   ;
        merge_zero_num_out   <= zero_num_pre     ;
        merge_dout_out       <= dout_up_pre ^dout_mid_pre^dout_low_pre     ;

end










endmodule 



// Design 1 =======================================================================


// reg                             sop_pre             ;
// reg                             eop_pre             ;
// reg                             dval_pre            ;
// reg    [3:0]                    packet_num_pre      ;
// reg    [11:0]                   zero_num_pre        ;
// reg    [31:0]                   dout_up_pre         ;
// reg    [31:0]                   dout_mid_pre        ;
// reg    [31:0]                   dout_low_pre        ;


// always @(posedge clk or posedge rst) begin
//     if (rst) begin

//         sop_pre        <= 'b0 ;
//         eop_pre        <= 'b0 ;
//         dval_pre       <= 'b0 ;
//         packet_num_pre <= 'b0 ;
//         zero_num_pre   <= 'b0 ;
        
//     end
//     else begin

//         sop_pre        <= sop_out_up|sop_out_mid  ; // 上段是sop 或 中段是sop
//         eop_pre        <= eop_out_mid|eop_out_low ; // 中段是eop 或 下段是eop
//         dval_pre       <= dval_out_mid ;            // 上段有效，中段必然有效，因为一段小于32字节
//         packet_num_pre <= packet_num_out_mid ;      // 包号就是中间段的包号
//         zero_num_pre   <= zero_num_out_mid|zero_num_out_low ; // 和eop道理一样

//     end
// end


// always @(posedge clk or posedge rst) begin
//     if (rst) begin

//         dout_mid_pre <= 'b0 ;
        
//     end
//     else begin

//         dout_mid_pre <= dout_out_mid ;
        
//     end
// end


// always @(posedge clk or posedge rst) begin
//     if (rst) begin

//         dout_up_pre <= 'b0 ;
        
//     end
//     else begin

//         if ( sop_out_up == 1'b1 )
//             dout_up_pre <= dout_out_up ;
//         else 
//             dout_up_pre <= 'b0 ; 
        
//     end
// end

// always @(posedge clk or posedge rst) begin
//     if (rst) begin

//         dout_low_pre <= 'b0 ;
        
//     end
//     else begin

//         if ( sop_out_low == 1'b1 )
//             dout_low_pre <= 'b0 ;
//         else 
//             dout_low_pre <= dout_out_low ; 
        
//     end
// end

// always @(posedge clk or posedge rst) begin
//     if (rst) begin
//         // reset
//         merge_sop_out        <= 'b0 ;
//         merge_eop_out        <= 'b0 ;
//         merge_dval_out       <= 'b0 ;
//         merge_packet_num_out <= 'b0 ;
//         merge_zero_num_out   <= 'b0 ;
//         merge_dout_out       <= 'b0 ;
//     end
//     else begin
//         merge_sop_out        <= sop_pre          ;
//         merge_eop_out        <= eop_pre          ;
//         merge_dval_out       <= dval_pre         ;
//         merge_packet_num_out <= packet_num_pre   ;
//         merge_zero_num_out   <= zero_num_pre     ;
//         merge_dout_out       <= dout_up_pre ^dout_mid_pre^dout_low_pre     ;
//     end
// end



// =============================================================================








// Design 2 ====================================================================
// always @(posedge clk or posedge rst) begin
//     if (rst) begin

//         merge_sop_out                    <= 'b0 ;
//         merge_eop_out                    <= 'b0 ;
//         merge_dval_out                   <= 'b0 ;
//         merge_packet_num_out             <= 'b0 ;
//         merge_zero_num_out               <= 'b0 ;
        
//     end
//     else begin

//         merge_sop_out           <= sop_out_up|sop_out_mid  ; // 上段是sop 或 中段是sop
//         merge_eop_out           <= eop_out_mid|eop_out_low ; // 中段是eop 或 下段是eop
//         merge_dval_out          <= dval_out_mid ;            // 上段有效，中段必然有效，因为一段小于32字节
//         merge_packet_num_out    <= packet_num_out_mid ;      // 包号就是中间段的包号
//         merge_zero_num_out      <= zero_num_out_mid|zero_num_out_low ; // 和eop道理一样

//     end
// end

// // sop_u sop_m sop_l 情况分析
// // 000：输出0
// // 001：输出0
// // 010：mid^low 
// // 100:up^mid^low
// // 101:up^mid 
// // 其他情况不会出现


// always @(posedge clk or posedge rst) begin
//     if (rst) begin
//         // reset
//         merge_dout_out       <= 'b0 ;
//     end
//     else if ( sop_out_up == 1'b1 && sop_out_low == 1'b1 ) begin
//         merge_dout_out       <= dout_out_up ^dout_out_mid     ;
//     end
//     else if ( sop_out_up == 1'b1 && sop_out_low == 1'b0 ) begin
//         merge_dout_out       <= dout_out_up ^dout_out_mid^dout_out_low     ;
//     end
//     else if ( dval_out_mid == 1'b1 && sop_out_low == 1'b0 ) begin
//         merge_dout_out       <= dout_out_mid^dout_out_low     ;
//     end
//     else if ( dval_out_mid == 1'b1 ) begin
//         merge_dout_out       <= dout_out_mid ;
//     end 
//     else begin
//         merge_dout_out       <=  'b0 ;
//     end
// end

// =============================================================================














// assign merge_dout_out = 
// out_see_seg_dout[0]^out_see_seg_dout[1]^out_see_seg_dout[2]^out_see_seg_dout[3]^out_see_seg_dout[4]^out_see_seg_dout[5]^out_see_seg_dout[6]^out_see_seg_dout[7]^out_see_seg_dout[8]^out_see_seg_dout[9]
// ^out_see_seg_dout[10]^out_see_seg_dout[11]^out_see_seg_dout[12]^out_see_seg_dout[13]^out_see_seg_dout[14]^out_see_seg_dout[15]^out_see_seg_dout[16]^out_see_seg_dout[17]^out_see_seg_dout[18]^out_see_seg_dout[19]
// ^out_see_seg_dout[20]^out_see_seg_dout[21]^out_see_seg_dout[22]^out_see_seg_dout[23]^out_see_seg_dout[24]^out_see_seg_dout[25]^out_see_seg_dout[26]^out_see_seg_dout[27]^out_see_seg_dout[28]^out_see_seg_dout[29]
// ^out_see_seg_dout[30]^out_see_seg_dout[31]^out_see_seg_dout[32]^out_see_seg_dout[33]^out_see_seg_dout[34]^out_see_seg_dout[35]^out_see_seg_dout[36]^out_see_seg_dout[37]^out_see_seg_dout[38]^out_see_seg_dout[39]
// ^out_see_seg_dout[40]^out_see_seg_dout[41]^out_see_seg_dout[42]^out_see_seg_dout[43]^out_see_seg_dout[44]^out_see_seg_dout[45]^out_see_seg_dout[46]^out_see_seg_dout[47]^out_see_seg_dout[48]^out_see_seg_dout[49]
// ^out_see_seg_dout[50]^out_see_seg_dout[51]^out_see_seg_dout[52]^out_see_seg_dout[53]^out_see_seg_dout[54]^out_see_seg_dout[55]^out_see_seg_dout[56]^out_see_seg_dout[57]^out_see_seg_dout[58]^out_see_seg_dout[59]
// ^out_see_seg_dout[60]^out_see_seg_dout[61]^out_see_seg_dout[62]^out_see_seg_dout[63] ;