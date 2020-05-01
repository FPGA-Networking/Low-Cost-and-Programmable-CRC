

`timescale 1ns/1ps 


module merge_top 

# ( parameter   SEG_NUM      = 64 ,
    parameter   [1023:0]    AHEAD_POLY   = 0  ,
	parameter	PKT_NUM      = 8  // 8 packets





  )

( 

        input clk ,
        input rst ,


		input  [SEG_NUM-1:0]            lut_pipe_sop_out        ,
		input  [SEG_NUM-1:0]            lut_pipe_eop_out        ,
		input  [SEG_NUM-1:0]            lut_pipe_dval_out       ,
		input  [SEG_NUM*4-1:0]          lut_pipe_packet_num_out ,
		input  [SEG_NUM*12-1:0]         lut_pipe_zero_num_out   ,
		input  [SEG_NUM*32-1:0]         lut_pipe_dout_out       ,

		output   [PKT_NUM-1:0]          merge_sop_out        ,
		output   [PKT_NUM-1:0]          merge_eop_out        ,
		output   [PKT_NUM-1:0]          merge_dval_out       ,
		output   [4*PKT_NUM-1:0]        merge_packet_num_out ,
		output   [12*PKT_NUM-1:0]       merge_zero_num_out   ,
		output   [32*PKT_NUM-1:0]       merge_dout_out       



 ) ;


wire  [SEG_NUM/2-1:0]            layer_1_pipe_sop_out        ; // 32组
wire  [SEG_NUM/2-1:0]            layer_1_pipe_eop_out        ;
wire  [SEG_NUM/2-1:0]            layer_1_pipe_dval_out       ;
wire  [SEG_NUM/2*4-1:0]          layer_1_pipe_packet_num_out ;
wire  [SEG_NUM/2*12-1:0]         layer_1_pipe_zero_num_out   ;
wire  [SEG_NUM/2*32-1:0]         layer_1_pipe_dout_out       ;

wire  [SEG_NUM/4-1:0]            layer_2_pipe_sop_out        ; // 16组
wire  [SEG_NUM/4-1:0]            layer_2_pipe_eop_out        ;
wire  [SEG_NUM/4-1:0]            layer_2_pipe_dval_out       ;
wire  [SEG_NUM/4*4-1:0]          layer_2_pipe_packet_num_out ;
wire  [SEG_NUM/4*12-1:0]         layer_2_pipe_zero_num_out   ;
wire  [SEG_NUM/4*32-1:0]         layer_2_pipe_dout_out       ;

wire  [SEG_NUM/8-1:0]            layer_3_pipe_sop_out        ; // 8组
wire  [SEG_NUM/8-1:0]            layer_3_pipe_eop_out        ;
wire  [SEG_NUM/8-1:0]            layer_3_pipe_dval_out       ;
wire  [SEG_NUM/8*4-1:0]          layer_3_pipe_packet_num_out ;
wire  [SEG_NUM/8*12-1:0]         layer_3_pipe_zero_num_out   ;
wire  [SEG_NUM/8*32-1:0]         layer_3_pipe_dout_out       ;





merge_layer   // 32 elements

# (             
				.SEG_IN  (   SEG_NUM   ) , // 64
                .AHEAD_POLY ( AHEAD_POLY ),
                .SEG_OUT (   SEG_NUM/2 ) //32
  )

   U_1_merge_layer  ( 

        .clk            ( clk ) ,
        .rst            ( rst ) ,
        .in_sop         ( lut_pipe_sop_out        ) ,
        .in_eop         ( lut_pipe_eop_out        ) ,
        .in_dval        ( lut_pipe_dval_out       ) ,
        .in_packet_num  ( lut_pipe_packet_num_out ) ,
        .in_zero_num    ( lut_pipe_zero_num_out   ) ,
        .in_dout        ( lut_pipe_dout_out       ) ,
        .out_sop        ( layer_1_pipe_sop_out         ) ,
        .out_eop        ( layer_1_pipe_eop_out         ) ,
        .out_dval       ( layer_1_pipe_dval_out        ) ,
        .out_packet_num ( layer_1_pipe_packet_num_out  ) ,
        .out_zero_num   ( layer_1_pipe_zero_num_out    ) ,
        .out_dout       ( layer_1_pipe_dout_out        )  

 ) ;




merge_layer   // 16 elements

# (             
				.SEG_IN  ( SEG_NUM/2 ) , // 32
                .AHEAD_POLY ( AHEAD_POLY ),
                .SEG_OUT ( SEG_NUM/4 )   // 16
  )

   U_2_merge_layer  ( 

        .clk            ( clk ) ,
        .rst            ( rst ) ,
        .in_sop         ( layer_1_pipe_sop_out        ) ,
        .in_eop         ( layer_1_pipe_eop_out        ) ,
        .in_dval        ( layer_1_pipe_dval_out       ) ,
        .in_packet_num  ( layer_1_pipe_packet_num_out ) ,
        .in_zero_num    ( layer_1_pipe_zero_num_out   ) ,
        .in_dout        ( layer_1_pipe_dout_out       ) ,
        .out_sop        ( layer_2_pipe_sop_out        ) ,
        .out_eop        ( layer_2_pipe_eop_out        ) ,
        .out_dval       ( layer_2_pipe_dval_out       ) ,
        .out_packet_num ( layer_2_pipe_packet_num_out ) ,
        .out_zero_num   ( layer_2_pipe_zero_num_out   ) ,
        .out_dout       ( layer_2_pipe_dout_out       )  

 ) ;


merge_layer   // 8 elements

# (             
				.SEG_IN  (  SEG_NUM/4 ) , // 16
                .AHEAD_POLY ( AHEAD_POLY ),
                .SEG_OUT (  SEG_NUM/8 )   // 8
  )

   U_3_merge_layer  ( 

        .clk            ( clk ) ,
        .rst            ( rst ) ,
        .in_sop         ( layer_2_pipe_sop_out        ) ,
        .in_eop         ( layer_2_pipe_eop_out        ) ,
        .in_dval        ( layer_2_pipe_dval_out       ) ,
        .in_packet_num  ( layer_2_pipe_packet_num_out ) ,
        .in_zero_num    ( layer_2_pipe_zero_num_out   ) ,
        .in_dout        ( layer_2_pipe_dout_out       ) ,
        .out_sop        ( layer_3_pipe_sop_out        ) ,
        .out_eop        ( layer_3_pipe_eop_out        ) ,
        .out_dval       ( layer_3_pipe_dval_out       ) ,
        .out_packet_num ( layer_3_pipe_packet_num_out ) ,
        .out_zero_num   ( layer_3_pipe_zero_num_out   ) ,
        .out_dout       ( layer_3_pipe_dout_out       )  

 ) ;












merge_crossbar 

# ( 

    .SEG_NUM_IN  ( SEG_NUM/8 ) , // 8 in
    .PKT_NUM_OUT ( PKT_NUM )   // 8 out
  )

u_merge_crossbar    ( 

        .clk ( clk ) ,
        .rst ( rst ) ,

        .in_sop        ( layer_3_pipe_sop_out        ) ,
        .in_eop        ( layer_3_pipe_eop_out        ) ,
        .in_dval       ( layer_3_pipe_dval_out       ) ,
        .in_packet_num ( layer_3_pipe_packet_num_out ) ,
        .in_zero_num   ( layer_3_pipe_zero_num_out   ) ,
        .in_dout       ( layer_3_pipe_dout_out       ) ,

        .out_sop        ( merge_sop_out        ) ,
        .out_eop        ( merge_eop_out        ) ,
        .out_dval       ( merge_dval_out       ) ,
        .out_packet_num ( merge_packet_num_out ) ,
        .out_zero_num   ( merge_zero_num_out   ) ,
        .out_dout       ( merge_dout_out       )



 ) ;













// assign merge_sop_out        = layer_3_pipe_sop_out        ;
// assign merge_eop_out        = layer_3_pipe_eop_out        ;
// assign merge_dval_out       = layer_3_pipe_dval_out       ;
// assign merge_packet_num_out = layer_3_pipe_packet_num_out ;
// assign merge_zero_num_out   = layer_3_pipe_zero_num_out   ;
// assign merge_dout_out       = layer_3_pipe_dout_out       ;







endmodule 














// assign merge_dout_out = 
// out_see_seg_dout[0]^out_see_seg_dout[1]^out_see_seg_dout[2]^out_see_seg_dout[3]^out_see_seg_dout[4]^out_see_seg_dout[5]^out_see_seg_dout[6]^out_see_seg_dout[7]^out_see_seg_dout[8]^out_see_seg_dout[9]
// ^out_see_seg_dout[10]^out_see_seg_dout[11]^out_see_seg_dout[12]^out_see_seg_dout[13]^out_see_seg_dout[14]^out_see_seg_dout[15]^out_see_seg_dout[16]^out_see_seg_dout[17]^out_see_seg_dout[18]^out_see_seg_dout[19]
// ^out_see_seg_dout[20]^out_see_seg_dout[21]^out_see_seg_dout[22]^out_see_seg_dout[23]^out_see_seg_dout[24]^out_see_seg_dout[25]^out_see_seg_dout[26]^out_see_seg_dout[27]^out_see_seg_dout[28]^out_see_seg_dout[29]
// ^out_see_seg_dout[30]^out_see_seg_dout[31]^out_see_seg_dout[32]^out_see_seg_dout[33]^out_see_seg_dout[34]^out_see_seg_dout[35]^out_see_seg_dout[36]^out_see_seg_dout[37]^out_see_seg_dout[38]^out_see_seg_dout[39]
// ^out_see_seg_dout[40]^out_see_seg_dout[41]^out_see_seg_dout[42]^out_see_seg_dout[43]^out_see_seg_dout[44]^out_see_seg_dout[45]^out_see_seg_dout[46]^out_see_seg_dout[47]^out_see_seg_dout[48]^out_see_seg_dout[49]
// ^out_see_seg_dout[50]^out_see_seg_dout[51]^out_see_seg_dout[52]^out_see_seg_dout[53]^out_see_seg_dout[54]^out_see_seg_dout[55]^out_see_seg_dout[56]^out_see_seg_dout[57]^out_see_seg_dout[58]^out_see_seg_dout[59]
// ^out_see_seg_dout[60]^out_see_seg_dout[61]^out_see_seg_dout[62]^out_see_seg_dout[63] ;







// 原来的 

// assign merge_packet_num_out = 'b0 ;
// assign merge_zero_num_out = 'b0 ;

// assign merge_eop_out = |lut_pipe_eop_out ;
// assign merge_dval_out = |lut_pipe_dval_out ;






// reg [31:0]     out_see_seg_dout[0:63]  ; // 4096 bits with 64 seg 
// integer k ;
// always @(*) begin

//     for ( k=0; k<64; k=k+1 ) begin

//               out_see_seg_dout[k] <=  lut_pipe_dout_out       [(k+1)*32-1 -: 32] ;
//     end


// end

// assign merge_dout_out = 
// out_see_seg_dout[0]^out_see_seg_dout[1]^out_see_seg_dout[2]^out_see_seg_dout[3]^out_see_seg_dout[4]^out_see_seg_dout[5]^out_see_seg_dout[6]^out_see_seg_dout[7]^out_see_seg_dout[8]^out_see_seg_dout[9]
// ^out_see_seg_dout[10]^out_see_seg_dout[11]^out_see_seg_dout[12]^out_see_seg_dout[13]^out_see_seg_dout[14]^out_see_seg_dout[15]^out_see_seg_dout[16]^out_see_seg_dout[17]^out_see_seg_dout[18]^out_see_seg_dout[19]
// ^out_see_seg_dout[20]^out_see_seg_dout[21]^out_see_seg_dout[22]^out_see_seg_dout[23]^out_see_seg_dout[24]^out_see_seg_dout[25]^out_see_seg_dout[26]^out_see_seg_dout[27]^out_see_seg_dout[28]^out_see_seg_dout[29]
// ^out_see_seg_dout[30]^out_see_seg_dout[31]^out_see_seg_dout[32]^out_see_seg_dout[33]^out_see_seg_dout[34]^out_see_seg_dout[35]^out_see_seg_dout[36]^out_see_seg_dout[37]^out_see_seg_dout[38]^out_see_seg_dout[39]
// ^out_see_seg_dout[40]^out_see_seg_dout[41]^out_see_seg_dout[42]^out_see_seg_dout[43]^out_see_seg_dout[44]^out_see_seg_dout[45]^out_see_seg_dout[46]^out_see_seg_dout[47]^out_see_seg_dout[48]^out_see_seg_dout[49]
// ^out_see_seg_dout[50]^out_see_seg_dout[51]^out_see_seg_dout[52]^out_see_seg_dout[53]^out_see_seg_dout[54]^out_see_seg_dout[55]^out_see_seg_dout[56]^out_see_seg_dout[57]^out_see_seg_dout[58]^out_see_seg_dout[59]
// ^out_see_seg_dout[60]^out_see_seg_dout[61]^out_see_seg_dout[62]^out_see_seg_dout[63] ;




// integer i ;
// always @(*) begin

//     for ( k=0; k<64; k=k+1 ) begin

//               out_see_seg_dout[k] <=  lut_pipe_dout_out       [(k+1)*BUS_WIDTH-1 -: BUS_WIDTH] ;
//     end


// end



// genvar i ;

// generate
// for ((i=0; i<64; i=i+1))
// endgenerate

// reg [31:0]     out_see_lut_pipe_dout_out[0:63]  ; // 4096 bits with 64 seg  

// integer k ;
// always @(*) begin

//     for ( k=0; k<64; k=k+1 ) begin
   
//               out_see_lut_pipe_dout_out[k] <=  lut_pipe_dout_out       [(k+1)*31-1 -: 31] ;
//     end


// end