`timescale 1ns/1ps 


module merge_crossbar

# ( 

    parameter   SEG_NUM_IN  = 64 , // 8 in
                PKT_NUM_OUT = 8   // 8 out
  )

    ( 

        input                             clk  ,
        input                             rst  ,

        input   [SEG_NUM_IN-1:0]          in_sop        ,
        input   [SEG_NUM_IN-1:0]          in_eop        ,
        input   [SEG_NUM_IN-1:0]          in_dval       ,
        input   [4*SEG_NUM_IN-1:0]        in_packet_num ,
        input   [12*SEG_NUM_IN-1:0]       in_zero_num   ,
        input   [32*SEG_NUM_IN-1:0]       in_dout       ,

        output   [PKT_NUM_OUT-1:0]        out_sop        ,
        output   [PKT_NUM_OUT-1:0]        out_eop        ,
        output   [PKT_NUM_OUT-1:0]        out_dval       ,
        output   [4*PKT_NUM_OUT-1:0]      out_packet_num ,
        output   [12*PKT_NUM_OUT-1:0]     out_zero_num   ,
        output   [32*PKT_NUM_OUT-1:0]     out_dout      



 ) ;
















genvar i;
generate 
        for (i=0; i<PKT_NUM_OUT; i=i+1) begin : crossbar_element
            parameter PKT_NUM_VALUE = i+1 ;

            merge_crossbar_element 
            # ( 
            
                            .SEG_NUM_IN     (SEG_NUM_IN), // ,
                            .PKT_NUM_VALUE  (PKT_NUM_VALUE) 
            
              )
            u_merge_crossbar_element ( 
                    // .PKT_NUM_VALUE  ( i+1 ) ,
                    .clk            ( clk ) ,
                    .rst            ( rst ) ,
                    .in_sop         ( in_sop        ) ,
                    .in_eop         ( in_eop        ) ,
                    .in_dval        ( in_dval       ) ,
                    .in_packet_num  ( in_packet_num ) ,
                    .in_zero_num    ( in_zero_num   ) ,
                    .in_dout        ( in_dout       ) ,
                    .out_sop        ( out_sop        [i]     ) ,
                    .out_eop        ( out_eop        [i]     ) ,
                    .out_dval       ( out_dval       [i]     ) ,
                    .out_packet_num ( out_packet_num [4 *(i+1)-1 -: 4  ]  ) ,
                    .out_zero_num   ( out_zero_num   [12*(i+1)-1 -: 12 ]  ) ,
                    .out_dout       ( out_dout       [32*(i+1)-1 -: 32 ]  )  
             ) ;
        end


endgenerate


endmodule