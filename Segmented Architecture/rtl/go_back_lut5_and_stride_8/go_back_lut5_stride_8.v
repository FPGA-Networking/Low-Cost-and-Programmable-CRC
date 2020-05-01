


module go_back_lut_5_stride_8 
    # (   
        parameter                     MOD_WIDTH    =  12 ,
        parameter                     MOD_STAGE    =   0 ,  // 范围0-2  ,0是第一级               
        parameter  [0:16*64*16-1]     LUT_POLY     =   0         // [0:16*64*16-1]          

        )
( 
        input                               clk             ,
        input                               rst             ,
        input           [31:0]              crc             ,
        input                               crc_en          ,
        input           [MOD_WIDTH-1:0]     mod             ,
        output  /* reg */     [31:0]              crc_go_back     ,
        output  /* reg */                         crc_en_go_back  ,
        output  /* reg */     [MOD_WIDTH-1:0]     mod_go_back           

 ) ;



// parameter  [0:16*64*16-1] POLY  = { 16*16{64'h6996966996696996}  } ; // 1 equation（32bit） 对应16个LUT（2bit 1个），LUT可以复用，32个equation可以当16个用

 wire [16*2*16-1:0] temp ; 
 // reg [34:0] cin_merge [0:31] ;
 wire [31:0] cout_pre ;
 reg  [16*2*16-1:0]  xor_pre  ;


reg                crc_en_ff  ;
reg        [MOD_WIDTH-1:0]   mod_ff     ;
// reg       [31:0]   crc_ff     ;


reg                crc_en_ff_1  ;
reg        [MOD_WIDTH-1:0]   mod_ff_1     ;
// reg       [31:0]   crc_ff_1     ;






always @(posedge clk  ) begin
        crc_en_ff  <= crc_en ;
        mod_ff     <= mod ;
        // crc_ff     <= crc ;
end


always @(posedge clk  ) begin
        crc_en_ff_1  <= crc_en_ff ;
        case ( MOD_STAGE )
            0 : mod_ff_1 <= { 6'b0,mod_ff[5:0] } ;
            1 : mod_ff_1 <= { 9'b0,mod_ff[2:0] } ;
            2 : mod_ff_1 <= 12'b0 ;
        endcase // MOD_STAGE
        // crc_ff_1     <= crc_ff    ;
end

// integer k,n ;

// always @(posedge clk  ) begin
//   for ( k=0;k<32;k=k+1 ) begin
//       cin_merge[k] =  {3'b0, crc}  ;
//   end
// end




wire [2:0] mod_addr ;

assign mod_addr[0] = mod[3*(2-MOD_STAGE)+0] ;
assign mod_addr[1] = mod[3*(2-MOD_STAGE)+1] ;
assign mod_addr[2] = mod[3*(2-MOD_STAGE)+2] ;


genvar i,j;
generate
    for (i=0; i<16; i=i+1) begin : c_go_back_layer_1 // equation
        for (j=0; j<16; j=j+1) begin : c_go_back_layer_2 // 1个equation对应的16个LUT
(* DONT_TOUCH= "TRUE" *)            LUT6_2 #(
               .INIT(LUT_POLY[i*16*64+j*64 +: 64]) // Specify LUT Contents
            ) LUT6_2_inst (
               .O6(temp[i*16+j]), // 1-bit LUT6 output
               .O5(temp[i*16+j+16*16]), // 1-bit lower LUT5 output
               .I0(crc[j*2]  ), // 1-bit LUT input
               .I1(crc[j*2+1]), // 1-bit LUT input
               .I2(mod[3*(2-MOD_STAGE)+0]), // 1-bit LUT input
               .I3(mod[3*(2-MOD_STAGE)+1]), // 1-bit LUT input
               .I4(mod[3*(2-MOD_STAGE)+2]), // 1-bit LUT input
               .I5(1'b1)  // 1-bit LUT input (fast MUX select only available to O6 output)
            );
        end
    end
endgenerate



always @(posedge clk) begin

            xor_pre <= temp;

end


 layer_xor_rtl 
    # (            .INPUT_NUM_ONE_EQUATION    (16)  ,  
                   .OUTPUT_NUM_ONE_EQUATION   (1)    
        )
    u_layer_xor_rtl
( 
            .clk  ( clk )    ,   
            .rst  ( rst )    ,   
            .din  ( xor_pre )    ,
            .dout ( cout_pre )              

 ) ;



// genvar m;
// generate
//     for (m=0; m<32; m=m+1) begin : xor_1
//          layer_xor_rtl 
//             # (            .INPUT_NUM_ONE_EQUATION    (16)  ,  
//                            .OUTPUT_NUM_ONE_EQUATION   (1)    
//                 )
//             u_layer_xor_rtl
//         ( 
//                     .clk  ( clk )    ,   
//                     .rst  ( rst )    ,   
//                     .din  ( xor_pre[m*16+15 -: 16] )    ,
//                     .dout ( cout_pre[m] )              
        
//          ) ;
//     end
// endgenerate


// always @(posedge clk  ) begin
//   crc_go_back     <= cout_pre ;
//   crc_en_go_back  <= crc_en_ff_1 ;
//   mod_go_back     <= mod_ff_1 ;
// end

assign  crc_go_back     = cout_pre ;
assign  crc_en_go_back  = crc_en_ff_1 ;
assign  mod_go_back     = mod_ff_1 ;

endmodule 

