`timescale 1ns/1ps 


module merge_layer 

# ( parameter   SEG_IN = 0 , // 64 for 64seg in first layer 
    parameter  [1023:0]   AHEAD_POLY = 0 ,
                SEG_OUT=SEG_IN/2




  )

    ( 

        input                             clk  ,
        input                             rst  ,

        input    [SEG_IN-1:0]             in_sop        ,
        input    [SEG_IN-1:0]             in_eop        ,
        input    [SEG_IN-1:0]             in_dval       ,
        input    [4*SEG_IN-1:0]           in_packet_num ,
        input    [12*SEG_IN-1:0]          in_zero_num   ,
        input    [32*SEG_IN-1:0]          in_dout       ,

        output   [SEG_OUT-1:0]            out_sop        ,
        output   [SEG_OUT-1:0]            out_eop        ,
        output   [SEG_OUT-1:0]            out_dval       ,
        output   [4*SEG_OUT-1:0]          out_packet_num ,
        output   [12*SEG_OUT-1:0]         out_zero_num   ,
        output   [32*SEG_OUT-1:0]         out_dout      



 ) ;


reg           temp_sop        ;
reg           temp_eop        ;
wire           temp_dval       ; // reg           temp_dval       ;
reg  [3:0]    temp_packet_num ;
reg  [11:0]   temp_zero_num   ;
wire  [31:0]   temp_dout       ; //reg  [31:0]   temp_dout       ;




















merge_element first_merge_element // 对应SEG_OUT-1 层

( 

        . clk  ( clk ) ,
        . rst  ( rst ) ,

        .        sop_out_up  ( temp_sop        ) ,
        .        eop_out_up  ( temp_eop        ) ,
        .       dval_out_up  ( temp_dval       ) ,
        . packet_num_out_up  ( temp_packet_num ) ,
        .   zero_num_out_up  ( temp_zero_num   ) ,
        .       dout_out_up  ( temp_dout       ) ,


        .        sop_out_mid  ( in_sop        [SEG_IN-1]           )  ,
        .        eop_out_mid  ( in_eop        [SEG_IN-1]           )  ,
        .       dval_out_mid  ( in_dval       [SEG_IN-1]           )  ,
        . packet_num_out_mid  ( in_packet_num [4 *(SEG_IN)-1 -: 4  ] )   ,
        .   zero_num_out_mid  ( in_zero_num   [12*(SEG_IN)-1 -: 12 ] )   ,
        .       dout_out_mid  ( in_dout       [32*(SEG_IN)-1 -: 32 ] )   ,

        .        sop_out_low  ( in_sop        [SEG_IN-2]           )   ,
        .        eop_out_low  ( in_eop        [SEG_IN-2]           )   ,
        .       dval_out_low  ( in_dval       [SEG_IN-2]           )   ,
        . packet_num_out_low  ( in_packet_num [4 *(SEG_IN-1)-1 -: 4  ] )   ,
        .   zero_num_out_low  ( in_zero_num   [12*(SEG_IN-1)-1 -: 12 ] )   ,
        .       dout_out_low  ( in_dout       [32*(SEG_IN-1)-1 -: 32 ] )   ,


        .merge_sop_out        ( out_sop       [SEG_OUT-1]          ) ,
        .merge_eop_out        ( out_eop       [SEG_OUT-1]          ) ,
        .merge_dval_out       ( out_dval      [SEG_OUT-1]          ) ,
        .merge_packet_num_out ( out_packet_num[4*SEG_OUT-1  -: 4  ]) ,
        .merge_zero_num_out   ( out_zero_num  [12*SEG_OUT-1 -: 12 ]) ,
        .merge_dout_out       ( out_dout      [32*SEG_OUT-1 -: 32 ]) 



 ) ;


// middle layer 

genvar i;
generate 
        for (i=1; i<SEG_OUT-1; i=i+1) begin : mid
merge_element middle_merge_element

( 

        . clk  ( clk ) ,
        . rst  ( rst ) ,

        .        sop_out_up  ( in_sop        [(i*2+2)]               ) ,
        .        eop_out_up  ( in_eop        [(i*2+2)]               ) ,
        .       dval_out_up  ( in_dval       [(i*2+2)]               ) ,
        . packet_num_out_up  ( in_packet_num [4 *(i*2+3)-1  -: 4 ] ) ,
        .   zero_num_out_up  ( in_zero_num   [12*(i*2+3)-1 -: 12 ] ) ,
        .       dout_out_up  ( in_dout       [32*(i*2+3)-1 -: 32 ] ) ,


        .        sop_out_mid  ( in_sop        [(i*2+1)]               )  ,
        .        eop_out_mid  ( in_eop        [(i*2+1)]               )  ,
        .       dval_out_mid  ( in_dval       [(i*2+1)]               )  ,
        . packet_num_out_mid  ( in_packet_num [4 *(i*2+2)-1  -: 4 ] )  ,
        .   zero_num_out_mid  ( in_zero_num   [12*(i*2+2)-1 -: 12 ] )  ,
        .       dout_out_mid  ( in_dout       [32*(i*2+2)-1 -: 32 ] )  ,

        .        sop_out_low  ( in_sop        [i*2]                 )   ,
        .        eop_out_low  ( in_eop        [i*2]                 )   ,
        .       dval_out_low  ( in_dval       [i*2]                 )   ,
        . packet_num_out_low  ( in_packet_num [4 *(i*2+1)-1  -: 4 ]   )   ,
        .   zero_num_out_low  ( in_zero_num   [12*(i*2+1)-1 -: 12 ]   )   ,
        .       dout_out_low  ( in_dout       [32*(i*2+1)-1 -: 32 ]   )   ,


        .merge_sop_out        ( out_sop       [i]                   ) ,
        .merge_eop_out        ( out_eop       [i]                   ) ,
        .merge_dval_out       ( out_dval      [i]                   ) ,
        .merge_packet_num_out ( out_packet_num[4 *(i+1)-1 -: 4  ]       ) ,
        .merge_zero_num_out   ( out_zero_num  [12*(i+1)-1 -: 12 ]       ) ,
        .merge_dout_out       ( out_dout      [32*(i+1)-1 -: 32 ]       ) 

 ) ;

end


endgenerate






















merge_element last_merge_element // // 对应0 层

( 

        . clk  ( clk ) ,
        . rst  ( rst ) ,

        .        sop_out_up  ( in_sop        [2]              ) ,
        .        eop_out_up  ( in_eop        [2]              ) ,
        .       dval_out_up  ( in_dval       [2]              ) ,
        . packet_num_out_up  ( in_packet_num [4*3-1  -: 4  ]  ) ,
        .   zero_num_out_up  ( in_zero_num   [12*3-1 -: 12 ]  ) ,
        .       dout_out_up  ( in_dout       [32*3-1 -: 32 ]  ) ,


        .        sop_out_mid  ( in_sop        [1]               )  , // 最后一组
        .        eop_out_mid  ( in_eop        [1]               )  ,
        .       dval_out_mid  ( in_dval       [1]               )  ,
        . packet_num_out_mid  ( in_packet_num [4*2-1  -: 4  ]   )  ,
        .   zero_num_out_mid  ( in_zero_num   [12*2-1 -: 12 ]   )  ,
        .       dout_out_mid  ( in_dout       [32*2-1 -: 32 ]   )  ,

        .        sop_out_low  ( in_sop        [0]              )   ,
        .        eop_out_low  ( in_eop        [0]              )   ,
        .       dval_out_low  ( in_dval       [0]              )   ,
        . packet_num_out_low  ( in_packet_num [4*1-1  -: 4  ]  )   ,
        .   zero_num_out_low  ( in_zero_num   [12*1-1 -: 12 ]  )   ,
        .       dout_out_low  ( in_dout       [32*1-1 -: 32 ]  )   ,


        .merge_sop_out        ( out_sop       [0]          ) ,
        .merge_eop_out        ( out_eop       [0]          ) ,
        .merge_dval_out       ( out_dval      [0]          ) ,
        .merge_packet_num_out ( out_packet_num[4*1-1  -: 4  ]) ,
        .merge_zero_num_out   ( out_zero_num  [12*1-1 -: 12 ]) ,
        .merge_dout_out       ( out_dout      [32*1-1 -: 32 ]) 



 ) ;









always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset
        temp_sop        <= 'b0 ;
        temp_eop        <= 'b0 ;
        // temp_dval       <= 'b0 ;
        temp_packet_num <= 'b0 ;
        temp_zero_num   <= 'b0 ;
        // temp_dout       <= 'b0 ;
    end
    else begin
        temp_sop        <= in_sop        [0]             ;
        temp_eop        <= in_eop        [0]             ;
        // temp_dval       <= in_dval       [0]             ;
        temp_packet_num <= in_packet_num [4*1-1  -: 4  ] ;
        temp_zero_num   <= in_zero_num   [12*1-1 -: 12 ] ;
        // temp_dout       <= in_dout       [32*1-1 -: 32 ] ;
    end
end



go_ahead_4096  

# ( .AHEAD_POLY (AHEAD_POLY) )

u_go_ahead_4096


 (    

        .clk       ( clk ) ,
        .rst       ( rst ) ,
        .crc_en_i  (in_dval)    ,
        .crc_i     (in_dout)    ,  
        .crc_en_o  (temp_dval)  ,
        .crc_o     (temp_dout)          


              ) ;





endmodule