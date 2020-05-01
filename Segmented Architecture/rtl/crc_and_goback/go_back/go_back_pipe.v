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
// 
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
module  go_back_pipe 

# ( parameter   GO_BACK_STAGE        =  0 ,  // 7    
                MOD_WIDTH            =  0 ,   // 7 
                GO_BACK_POLY         =  0
)

  (     
            input                       clk          ,
            input                       rst          ,
            input    [31:0]             crc_in       ,
            input                       crc_en_in    ,
            input    [MOD_WIDTH-1:0]    mod_in       ,
            output   [31:0]             crc_out      ,
            output                      crc_out_en
              ) ;

//*******************
//DEFINE LOCAL PARAMETER
//*******************
//parameter(s)
                                     
 parameter [0:GO_BACK_STAGE*256*64-1] POLY = GO_BACK_POLY ;                          

                                  
 

//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
//  wire [31:0]     crc_go_back_0    ;
// wire         crc_en_go_back_0    ;
// wire [MOD_WIDTH-1:0]      mod_go_back_0    ;

//  wire [31:0]     crc_go_back_1    ;
// wire         crc_en_go_back_1    ;
// wire [MOD_WIDTH-1:0]      mod_go_back_1    ;

// wire [31:0]     crc_go_back_2    ;
// wire         crc_en_go_back_2    ;
// wire [MOD_WIDTH-1:0]      mod_go_back_2    ;

// wire [31:0]     crc_go_back_3    ;
// wire         crc_en_go_back_3    ;
// wire [MOD_WIDTH-1:0]      mod_go_back_3    ;

// wire [31:0]     crc_go_back_4    ;
// wire         crc_en_go_back_4    ;
// wire [MOD_WIDTH-1:0]      mod_go_back_4    ;

// wire [31:0]     crc_go_back_5    ;
// wire         crc_en_go_back_5    ;
// wire [MOD_WIDTH-1:0]      mod_go_back_5    ;

// wire [31:0]     crc_go_back_6    ;
// wire         crc_en_go_back_6    ;
// wire [MOD_WIDTH-1:0]      mod_go_back_6    ;

// wire [31:0]     crc_go_back_7    ;
// wire         crc_en_go_back_7    ;
// wire [MOD_WIDTH-1:0]      mod_go_back_7    ; 

//WIRES
 

//*********************
//INSTANTCE MODULE
//*********************


// Stride = 1;Simple Go Back Pipeline ;LUT6 is used  ==========================================


// wire [31:0]               crc_go_back    [0:GO_BACK_STAGE]  ;
// wire                      crc_en_go_back [0:GO_BACK_STAGE]  ;
// wire [MOD_WIDTH-1:0]      mod_go_back    [0:GO_BACK_STAGE]  ;



// assign  crc_go_back    [0] =  crc_in      ;
// assign  crc_en_go_back [0] =  crc_en_in   ;
// assign  mod_go_back    [0] =  mod_in      ;




// genvar i;
// generate 
//         for (i=0; i<GO_BACK_STAGE; i=i+1) begin : multi_go_back_stage
//             go_back_stage    // 8
//                 # ( 
//                         .MOD_WIDTH ( MOD_WIDTH ) ,
//                         .MOD ( 2**i ) , // 128-1
//                         .POLY ( POLY[i*32*64*6 +: 32*64*6] )  
//                     )
//             u_go_back_stage  (     
//                 .clk             ( clk )   ,
//                 .rst             ( rst )   ,
//                 .crc             (crc_go_back     [GO_BACK_STAGE-i-1] )   ,
//                 .crc_en          (crc_en_go_back  [GO_BACK_STAGE-i-1] )   ,
//                 .mod             (mod_go_back     [GO_BACK_STAGE-i-1] )   ,
//                 .crc_go_back     (crc_go_back     [GO_BACK_STAGE-i]   )   ,
//                 .crc_en_go_back  (crc_en_go_back  [GO_BACK_STAGE-i]   )   ,
//                 .mod_go_back     (mod_go_back     [GO_BACK_STAGE-i]   )           
//                           ) ;
//         end


// endgenerate

// assign  crc_out     =  crc_go_back     [GO_BACK_STAGE] ;
// assign  crc_out_en  =  crc_en_go_back  [GO_BACK_STAGE] ;







// Stride = 8; LUT5 is used  ==============================================================


 

wire [31:0]               crc_go_back    [0:GO_BACK_STAGE]  ;
wire                      crc_en_go_back [0:GO_BACK_STAGE]  ;
wire [MOD_WIDTH-1:0]      mod_go_back    [0:GO_BACK_STAGE]  ;



assign  crc_go_back    [0] =  crc_in      ;
assign  crc_en_go_back [0] =  crc_en_in   ;
assign  mod_go_back    [0] =  mod_in      ;

genvar i;
generate 
        for (i=0; i<GO_BACK_STAGE; i=i+1) begin : Stride8_multi_go_back_stage
            parameter MOD_STAGE = 2-i ;
            go_back_lut_5_stride_8  
                # (   
                    .MOD_WIDTH  ( MOD_WIDTH ) ,
                    .MOD_STAGE  ( MOD_STAGE ) ,  // 范围0-2                  
                    .LUT_POLY   ( POLY[(2-i)*256*64 +: 256*64] )                   
            
                    ) u_go_back_lut_5_stride_8
            ( 
                    .clk            ( clk ) ,
                    .rst            ( rst ) ,
                    .crc            ( crc_go_back     [GO_BACK_STAGE-i-1] ) ,
                    .crc_en         ( crc_en_go_back  [GO_BACK_STAGE-i-1] ) ,
                    .mod            ( mod_go_back     [GO_BACK_STAGE-i-1] ) ,
                    .crc_go_back    ( crc_go_back     [GO_BACK_STAGE-i]   ) ,
                    .crc_en_go_back ( crc_en_go_back  [GO_BACK_STAGE-i]   ) ,
                    .mod_go_back    ( mod_go_back     [GO_BACK_STAGE-i]   )       
            
             ) ;
        end

assign  crc_out     =  crc_go_back     [GO_BACK_STAGE] ;
assign  crc_out_en  =  crc_en_go_back  [GO_BACK_STAGE] ;









endgenerate









//*********************
//MAIN CORE
//********************* 





//*********************
endmodule   