
module layer_xor_rtl 
    # ( parameter  INPUT_NUM_ONE_EQUATION       = 0  , // 29 
                   OUTPUT_NUM_ONE_EQUATION     = 0  , // 30 
                   BUS_WIDTH                    = INPUT_NUM_ONE_EQUATION*32
        )
( 
            input	            						clk      ,   
            input	            						rst      ,   
            input      [BUS_WIDTH-1:0]    				din      ,
            output reg [OUTPUT_NUM_ONE_EQUATION*32-1:0]    dout 				      

 ) ;


parameter INPUT_NUM_ONE_SECTION = INPUT_NUM_ONE_EQUATION / OUTPUT_NUM_ONE_EQUATION ;

// wire [LUT_NUM_ONE_EQUATION*32-1:0]  dout_pre ;

// genvar i,j;
// generate
//     for (i=0; i<32; i=i+1) begin : first_layer_1
//     	for (j=0; j<LUT_NUM_ONE_EQUATION; j=j+1) begin : first_layer_2
//     	   	LUT6 #(
// 		   	   .INIT(64'h6996966996696996)  // Specify LUT Contents
// 		   	) LUT6_inst (
// 		   	   .O(dout_pre[i*LUT_NUM_ONE_EQUATION+j]),   // LUT general output
// 		   	   .I0(din[i*LUT_NUM_ONE_EQUATION*6+j*6]), // LUT input
// 		   	   .I1(din[i*LUT_NUM_ONE_EQUATION*6+j*6+1]), // LUT input
// 		   	   .I2(din[i*LUT_NUM_ONE_EQUATION*6+j*6+2]), // LUT input
// 		   	   .I3(din[i*LUT_NUM_ONE_EQUATION*6+j*6+3]), // LUT input
// 		   	   .I4(din[i*LUT_NUM_ONE_EQUATION*6+j*6+4]), // LUT input
// 		   	   .I5(din[i*LUT_NUM_ONE_EQUATION*6+j*6+5])  // LUT input
// 		   	);
//     	end
//     end
// endgenerate

wire [32*OUTPUT_NUM_ONE_EQUATION-1:0] temp_xor ;



genvar k,k1;
generate 
    for ( k1=0; k1<32; k1=k1+1) begin : xor_rtl_1  
        for (k=0; k<OUTPUT_NUM_ONE_EQUATION; k=k+1) begin : xor_rtl_2
            assign temp_xor [k1*OUTPUT_NUM_ONE_EQUATION+k] = ^din[k1*INPUT_NUM_ONE_EQUATION + INPUT_NUM_ONE_SECTION*(k+1)-1 -:  INPUT_NUM_ONE_SECTION];
        end
    end
endgenerate







integer m,n ;
always @(posedge clk  ) begin
	// if (rst == 1'b1) begin
	// 	dout <= 'b0 ;
	// end
 //    else begin
        for (m=0; m<32; m=m+1) begin 
            for (n=0; n<OUTPUT_NUM_ONE_EQUATION; n=n+1) begin 
                dout[m*OUTPUT_NUM_ONE_EQUATION+n] <= temp_xor[m*OUTPUT_NUM_ONE_EQUATION+n];
            end
        end
    // end
end

endmodule 


// 

// wire  [INPUT_NUM_ONE_EQUATION-1：0]  temp_xor    [31:0]    ;

// genvar k2,k3;
// generate 
//     for ( k2=0; k2<32; k2=k2+1) begin : xor_rtl_init_1
//         for  ( k3=0; k3<OUTPUT_NUM_ONE_EQUATION;k3=k3+1 ) begin :xor_rtl_init_2 
//             assign temp_xor  [k2][(INPUT_NUM_ONE_EQUATION/OUTPUT_NUM_ONE_EQUATION)*k3] = din[ INPUT_NUM_ONE_EQUATION*k2 +(INPUT_NUM_ONE_EQUATION/OUTPUT_NUM_ONE_EQUATION)*k3+ 0 ] ^ din[ INPUT_NUM_ONE_EQUATION*k2 +(INPUT_NUM_ONE_EQUATION/OUTPUT_NUM_ONE_EQUATION)*k3+ 1 ] ;
//         end 
//     end
// endgenerate


// genvar k,k1;
// generate 
//     for ( k1=0; k1<32; k1=k1+1) begin : xor_rtl_1  
//         for (k=1; k<BUS_WIDTH-1; k=k+1) begin : xor_rtl_2
//             assign temp_xor [k1][k] = temp_xor[k1][k-1] ^ din [INPUT_NUM_ONE_EQUATION*k1+k+1] ;
//         end
//     end
// endgenerate


