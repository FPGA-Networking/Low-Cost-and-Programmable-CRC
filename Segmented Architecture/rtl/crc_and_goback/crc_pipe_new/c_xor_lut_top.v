`timescale 1ns/1ps 

module c_xor_lut_top 

# ( parameter   MOD_WIDTH                = 12 ,
                C_POLY                   = 0
  
   

  )
( 
			      input	clk   ,
			      input	rst   ,
            // input sop_in  ,
            input eop_in  ,
            input dval_in ,
            input [MOD_WIDTH-1:0] mod_in  ,
            input [31:0] din  ,
            
            
           //  output reg sop_out  ,
           //  output reg eop_out  ,
           //  output reg dval_out ,
            
            output reg [MOD_WIDTH-1:0] mod_out ,
            output reg cout_en ,
            output [31:0] cout   


 ) ;


  // wire [31:0] cout  ;
  wire [31:0] cout_1;




c_xor_lut  
# ( .C_POLY ( C_POLY ) )
u_c_xor_lut   (     
            .clk    ( clk )  ,
            .rst    ( rst )  ,
            .eop    ( eop_in )  ,
            .dval   ( dval_in )  ,
            .din    ( din     )  , // 6904BB59
            .cin    ( cout_1  )  ,
            .cout   ( cout  )  ,
            .cout_1 ( cout_1 )    
              ) ;



always @(posedge clk  ) begin
	// if (rst == 1'b1) begin
	// 	mod_out <= 'b0 ;
	// 	cout_en <= 'b0 ;
	// end
 //    else begin
		mod_out <=  mod_in ;
		cout_en <=  eop_in ;
    // end
end












endmodule