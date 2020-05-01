

// **************************************************************
// COPYRIGHT(c)2015, Xidian University
// All rights reserved.
//
// IP LIB INDEX :  
// IP Name      :      
// File name    : 
// Module name  : 
// Full name    :  
//
// Author       : Liu-Huan 
// Email        : assasin9997@163.com 
// Data         : 
// Version      : V 1.0 
// 
// Abstract     : 
// Called by    :  
// 
// Modification history
// -----------------------------------------------------------------
// 简单的go back pipe；相当于stride 1；
// 
//
// *****************************************************************

// *******************
// TIMESCALE
// ******************* 
`timescale 1ns/1ps 

// *******************
// INFORMATION
// *******************


//*******************
//DEFINE(s)
//*******************
//`define UDLY 1    //Unit delay, for non-blocking assignments in sequential logic



//*******************
//DEFINE MODULE PORT
//*******************
module  go_back_stage  

    # (
        parameter MOD_WIDTH      = 'b0 ,
        parameter [MOD_WIDTH-1:0]     MOD  = 'b0 ,
        parameter [0:12287] POLY = 'b0

      )
 (     
        input                   clk     ,
        input                   rst     ,
        input           [31:0]  crc     ,
        input                   crc_en  ,
        input           [MOD_WIDTH-1:0]   mod     ,
        output  reg     [31:0]  crc_go_back     ,
        output  reg             crc_en_go_back  ,
        output  reg     [MOD_WIDTH-1:0]   mod_go_back     
              ) ;

//*******************
//DEFINE LOCAL PARAMETER
//*******************
//parameter(s)
 

//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
 wire [191:0] temp ; 
 reg [35:0] cin_merge [0:31] ;
 wire [31:0] cout_pre ;



reg                crc_en_ff  ;
reg        [MOD_WIDTH-1:0]   mod_ff     ;
reg       [31:0]   crc_ff     ;


reg                crc_en_ff_1  ;
reg        [MOD_WIDTH-1:0]   mod_ff_1     ;
reg       [31:0]   crc_ff_1     ;

//WIRES
 

//*********************
//INSTANTCE MODULE
//*********************




//*********************
//MAIN CORE
//********************* 

always @(posedge clk  ) begin
    // if (rst == 1'b1) begin
    //     crc_en_ff  <= 'd0 ;
    //     mod_ff     <= 'd0 ;
    //     crc_ff     <= 'd0 ;
    // end
    // else begin
        crc_en_ff  <= crc_en ;
        mod_ff     <= mod ;
        crc_ff     <= crc ;
    // end
end


always @(posedge clk  ) begin
    // if (rst == 1'b1) begin
    //     crc_en_ff_1  <= 'd0 ;
    //     mod_ff_1     <= 'd0 ;
    //     crc_ff_1     <= 'd0 ;
    // end
    // else begin
        crc_en_ff_1  <= crc_en_ff ;
        mod_ff_1     <= mod_ff    ;
        crc_ff_1     <= crc_ff    ;
    // end
end


// genvar k;
// generate
//     for (k=0; k<32; k=k+1) begin : cin_mer
//         assign cin_merge[k] = {4'b0, crc}  ;
//     end
// endgenerate

integer k,n ;

always @(posedge clk  ) begin
    // if (rst == 1'b1) begin
    //     for ( n=0;n<32;n=n+1 ) begin
    //         cin_merge[n] = 36'b0  ;
    //     end
    // end
    // else begin
        for ( k=0;k<32;k=k+1 ) begin
            cin_merge[k] =  {4'b0, crc}  ;
        end
    // end
end



genvar i;
genvar j;
generate
    for (i=0; i<32; i=i+1) begin : c_go_back_layer_1
        for (j=0; j<6; j=j+1) begin : c_go_back_layer_2
            LUT6 #(
               .INIT(POLY[i*6*64+j*64 +: 64])  // Specify LUT Contents
            ) LUT6_inst (
               .O (temp[i*6+j]        ),   // LUT general output
               .I0(cin_merge[i][j*6]  ), // LUT input
               .I1(cin_merge[i][j*6+1]), // LUT input
               .I2(cin_merge[i][j*6+2]), // LUT input
               .I3(cin_merge[i][j*6+3]), // LUT input
               .I4(cin_merge[i][j*6+4]), // LUT input
               .I5(cin_merge[i][j*6+5])  // LUT input
            );  
        end
    end
endgenerate

genvar m;
generate
    for (m=0; m<32; m=m+1) begin : xor_1
        lut_xor  lut_xor   (     
                    .clk  ( clk )  ,
                    .rst  ( rst )  ,
                    .din  ( temp[m*6+5 -: 6] )  ,
                    .dout ( cout_pre[m] )        
                      ) ;
    end
endgenerate



always @(posedge clk  ) begin
    // if (rst == 1'b1) begin
    //     crc_go_back     <= 'd0 ;
    //     crc_en_go_back  <= 'd0 ;
    //     mod_go_back     <= 'd0 ;
    // end
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












//*********************
endmodule   