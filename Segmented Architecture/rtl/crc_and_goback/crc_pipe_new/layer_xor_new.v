
module layer_xor_new 
    # ( parameter  LUT_NUM_ONE_EQUATION    		= 0  , // 29 
                   LUT_OUT_NUM_ONE_EQUATION     = 0  , // 30 
                   BUS_WIDTH                    = LUT_NUM_ONE_EQUATION*32*6 
        )
( 
            input	            						clk      ,   
            input	            						rst      ,   
            input      [BUS_WIDTH-1:0]    				din      ,
            output reg [LUT_OUT_NUM_ONE_EQUATION*32-1:0]    dout 				      

 ) ;

wire [LUT_NUM_ONE_EQUATION*32-1:0]  dout_pre ;

genvar i,j;
generate
    for (i=0; i<32; i=i+1) begin : first_layer_1
    	for (j=0; j<LUT_NUM_ONE_EQUATION; j=j+1) begin : first_layer_2
    	   	LUT6 #(
		   	   .INIT(64'h6996966996696996)  // Specify LUT Contents
		   	) LUT6_inst (
		   	   .O(dout_pre[i*LUT_NUM_ONE_EQUATION+j]),   // LUT general output
		   	   .I0(din[i*LUT_NUM_ONE_EQUATION*6+j*6]), // LUT input
		   	   .I1(din[i*LUT_NUM_ONE_EQUATION*6+j*6+1]), // LUT input
		   	   .I2(din[i*LUT_NUM_ONE_EQUATION*6+j*6+2]), // LUT input
		   	   .I3(din[i*LUT_NUM_ONE_EQUATION*6+j*6+3]), // LUT input
		   	   .I4(din[i*LUT_NUM_ONE_EQUATION*6+j*6+4]), // LUT input
		   	   .I5(din[i*LUT_NUM_ONE_EQUATION*6+j*6+5])  // LUT input
		   	);
    	end
    end
endgenerate




integer m,n ;
always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		dout <= 'b0 ;
	end
    else begin
        for (m=0; m<32; m=m+1) begin 
            for (n=0; n<LUT_OUT_NUM_ONE_EQUATION; n=n+1) begin 
                if ( n<LUT_NUM_ONE_EQUATION ) begin
                    dout[m*LUT_OUT_NUM_ONE_EQUATION+n] <= dout_pre[m*LUT_NUM_ONE_EQUATION+n];
                end
                else begin
                    dout[m*LUT_OUT_NUM_ONE_EQUATION+n] <= 1'b0 ;
                end
            end
        end
    end
end

endmodule 

// always @(posedge clk or posedge rst) begin
//     if (rst == 1'b1) begin
//         dout <= 'b0 ;
//     end
//     else begin
//        dout <= dout_pre ; 
//     end
// end
