`timescale 1ns/1ps 

module c_xor_and_go_back_top

 # ( parameter   GO_BACK_STAGE            = 0 ,
                 PKT_NUM                  = 0 ,
                 GO_BACK_POLY             = 0 ,
                 C_POLY                   = 0
   )
( 
    input  clk   ,
    input  rst   ,

    input [PKT_NUM-1:0]     eop_in  ,
    input [PKT_NUM-1:0]     dval_in ,
    input [12*PKT_NUM-1:0]  mod_in  ,
    input [32*PKT_NUM-1:0]  din     ,
    
    output [PKT_NUM-1:0]     crc_en_out ,
    output [32*PKT_NUM-1:0] crc_out   


 ) ;







genvar i;
generate
        for (i=0; i<PKT_NUM; i=i+1) begin : multi_c_xor_go_back
            c_xor_and_go_back  
            
             # (              
                     .GO_BACK_STAGE ( GO_BACK_STAGE )    ,
                     .GO_BACK_POLY  ( GO_BACK_POLY  )    ,
                     .C_POLY        ( C_POLY ) 
               ) c_xor_and_go_back
            ( 
                        .clk ( clk )  ,
                        .rst ( rst )  ,
            
                        .eop_in  ( eop_in  [i]       ) ,
                        .dval_in ( dval_in [i]        ) ,
                        .mod_in  ( mod_in  [12*(i+1)-1 -: 12]            ) ,
                        .din     ( din     [32*(i+1)-1 -: 32]        ) ,
                                 
                        .crc_en_out  ( crc_en_out[i] ) ,
                        .crc_out     ( crc_out[32*(i+1)-1 -: 32]    )
            
            
             ) ;
        end
endgenerate


endmodule