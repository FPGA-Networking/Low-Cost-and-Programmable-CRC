`timescale 1ns/1ps 

module c_xor_and_go_back

 # ( parameter   MOD_WIDTH                = 12 ,
                 GO_BACK_STAGE            = 0  ,
                 GO_BACK_POLY             = 0  ,
                 C_POLY                   = 0  

 

   )
( 
			      input	clk   ,
			      input	rst   ,


            input eop_in  ,
            input dval_in ,
            input [MOD_WIDTH-1:0] mod_in  ,
            input [31:0] din  ,
            
            
            
            output        crc_en_out ,
            output [31:0] crc_out   


 ) ;





wire                dval_c_xor  ;
wire [MOD_WIDTH-1:0]   mod_c_xor  ;
wire [31:0]         dout_c_xor  ;


// wire crc_en_pre ;
// wire [31:0] crc_out_pre ;

c_xor_lut_top 
# ( .C_POLY(C_POLY) )
u_c_xor_lut_top
( 
            .clk     ( clk )  ,
            .rst     ( rst )  ,
            .eop_in  ( eop_in  )  ,
            .dval_in ( dval_in  )  ,
            .mod_in  ( mod_in  )  ,
            .din     ( din  )  ,
            .mod_out ( mod_c_xor )  ,
            .cout_en ( dval_c_xor )  ,
            .cout    ( dout_c_xor )  


 ) ;





  go_back_pipe 

# (     
                .GO_BACK_STAGE( GO_BACK_STAGE    ) ,
                .MOD_WIDTH    ( MOD_WIDTH  ) ,
                .GO_BACK_POLY ( GO_BACK_POLY )

) u_go_back_pipe

  (     
            .clk         ( clk        )  ,
            .rst         ( rst        )  ,
            .crc_in      ( dout_c_xor )  ,
            .crc_en_in   ( dval_c_xor )  ,
            .mod_in      ( mod_c_xor  )  ,
            .crc_out     ( crc_out    )  ,
            .crc_out_en  ( crc_en_out )      
               ) ;



// reverse_crc  u_reverse_crc   (     
//                 .clk         ( clk  )  ,
//                 .rst         ( rst  )  ,
//                 .crc_en_in   ( crc_en_pre  )  ,
//                 .crc_in      ( crc_out_pre  )  ,
//                 .crc_en_out  ( crc_en_out  )  ,
//                 .crc_out     ( crc_out  )            
//               ) ;




endmodule