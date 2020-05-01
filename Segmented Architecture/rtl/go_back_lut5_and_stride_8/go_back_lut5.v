


module go_back_lut_5 
    # (   
        parameter                     MOD_WIDTH    = 'b0 ,
        parameter [MOD_WIDTH-1:0]     MOD          = 'b0 ,
                                      LUT_NUM_ONE_EQUATION    		  = 7  // 171      // and thre are 32 equation
      // parameter  [0:7*64*16-1]  LUT_POLY                     = 0 ,                   

        )
( 
        input                               clk             ,
        input                               rst             ,
        input           [31:0]              crc             ,
        input                               crc_en          ,
        input           [MOD_WIDTH-1:0]     mod             ,
        output  reg     [31:0]              crc_go_back     ,
        output  reg                         crc_en_go_back  ,
        output  reg     [MOD_WIDTH-1:0]     mod_go_back   	      

 ) ;



parameter  [0:7*64*16-1] POLY  = { 7*16{64'h6996966996696996}  } ;

 wire [7*2*16-1:0] temp ; 
 reg [34:0] cin_merge [0:31] ;
 wire [31:0] cout_pre ;
reg  [7*2*16-1:0]  xor_pre  ;


reg                crc_en_ff  ;
reg        [MOD_WIDTH-1:0]   mod_ff     ;
reg       [31:0]   crc_ff     ;


reg                crc_en_ff_1  ;
reg        [MOD_WIDTH-1:0]   mod_ff_1     ;
reg       [31:0]   crc_ff_1     ;






always @(posedge clk  ) begin
        crc_en_ff  <= crc_en ;
        mod_ff     <= mod ;
        crc_ff     <= crc ;
end


always @(posedge clk  ) begin
        crc_en_ff_1  <= crc_en_ff ;
        mod_ff_1     <= mod_ff    ;
        crc_ff_1     <= crc_ff    ;
end

integer k,n ;

always @(posedge clk  ) begin
  for ( k=0;k<32;k=k+1 ) begin
      cin_merge[k] =  {3'b0, crc}  ;
  end
end











genvar i,j;
generate
    for (i=0; i<16; i=i+1) begin : c_go_back_layer_1
    	for (j=0; j<7; j=j+1) begin : c_go_back_layer_2
(* DONT_TOUCH= "TRUE" *)  			LUT6_2 #(
   			   .INIT(POLY[i*7*64+j*64 +: 64]) // Specify LUT Contents
   			) LUT6_2_inst (
   			   .O6(temp[i*7+j]), // 1-bit LUT6 output
   			   .O5(temp[i*7+j+16*7]), // 1-bit lower LUT5 output
   			   .I0(crc[j*5]  ), // 1-bit LUT input
   			   .I1(crc[j*5+1]), // 1-bit LUT input
   			   .I2(crc[j*5+2]), // 1-bit LUT input
   			   .I3(crc[j*5+3]), // 1-bit LUT input
   			   .I4(crc[j*5+4]), // 1-bit LUT input
   			   .I5(1'b1)  // 1-bit LUT input (fast MUX select only available to O6 output)
   			);
    	end
    end
endgenerate



always @(posedge clk) begin

            xor_pre <= temp;

end


 layer_xor_rtl 
    # (            .INPUT_NUM_ONE_EQUATION    (7)  ,  
                   .OUTPUT_NUM_ONE_EQUATION   (1)    
        )
    u_layer_xor_rtl
( 
            .clk  ( clk )    ,   
            .rst  ( rst )    ,   
            .din  ( xor_pre )    ,
            .dout ( cout_pre )              

 ) ;



always @(posedge clk  ) begin
     if ( crc_en_ff_1 == 1'b1 ) begin
        if ( mod_ff_1 == 'b0 ) begin
            crc_go_back     <= crc_ff_1 ;
            crc_en_go_back  <= crc_en_ff_1 ;
            mod_go_back     <= mod_ff_1 ;
        end
        else if ( mod_ff_1 >= MOD ) begin
            crc_go_back     <= cout_pre ;
            crc_en_go_back  <= crc_en_ff_1 ;
            mod_go_back     <= mod_ff_1-MOD ;
        end
        else begin
            crc_go_back     <= crc_ff_1 ;
            crc_en_go_back  <= crc_en_ff_1 ;
            mod_go_back     <= mod_ff_1 ;
        end
    end
    else begin
        crc_go_back     <= 'd0 ;
        crc_en_go_back  <= 'd0 ;
        mod_go_back     <= 'd0 ;
    end
end



endmodule 
