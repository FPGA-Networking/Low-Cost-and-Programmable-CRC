

`timescale 1ns/1ps 


module merge_crossbar_element
# ( 

    parameter   SEG_NUM_IN       = 0 ,
                PKT_NUM_VALUE    = 0 

  )


( 
        //input                  [3:0]    PKT_NUM_VALUE ,     

        input                             clk  ,
        input                             rst  ,

        input   [SEG_NUM_IN-1:0]              in_sop        ,
        input   [SEG_NUM_IN-1:0]              in_eop        ,
        input   [SEG_NUM_IN-1:0]              in_dval       ,
        input   [4*SEG_NUM_IN-1:0]            in_packet_num ,
        input   [12*SEG_NUM_IN-1:0]           in_zero_num   ,
        input   [32*SEG_NUM_IN-1:0]           in_dout       ,

        output   reg                          out_sop        ,
        output   reg                          out_eop        ,
        output   reg                          out_dval       ,
        output   reg [4-1:0]                  out_packet_num ,
        output   reg [12-1:0]                 out_zero_num   ,
        output   reg [32-1:0]                 out_dout       



 ) ;







reg               mask_sop        [0:SEG_NUM_IN-1]     ;
reg               mask_eop        [0:SEG_NUM_IN-1]     ;
reg               mask_dval       [0:SEG_NUM_IN-1]     ;
// reg  [4-1:0]      mask_packet_num [0:4*SEG_NUM_IN-1 ]  ;
reg  [12-1:0]     mask_zero_num   [0:SEG_NUM_IN-1]  ;
reg  [32-1:0]     mask_dout       [0:SEG_NUM_IN-1]  ;


integer i,j;
always @(posedge clk ) begin
    // if (rst) begin
    //     // reset
    //     for (i=0; i<SEG_NUM_IN; i=i+1) begin 
    //         mask_sop        [i] <= 'b0 ;
    //         mask_eop        [i] <= 'b0 ;
    //         mask_dval       [i] <= 'b0 ;
    //         // mask_packet_num [i] <= 'b0 ;
    //         mask_zero_num   [i] <= 'b0 ;
    //         mask_dout       [i] <= 'b0 ;
    //     end 
    // end
    // else begin
        for (j=0; j<SEG_NUM_IN; j=j+1) begin  
            if ( in_packet_num[ 4*(j+1)-1 -: 4 ] == PKT_NUM_VALUE ) begin
                mask_sop        [j] <= in_sop  [j]      ;
                mask_eop        [j] <= in_eop  [j]      ;
                mask_dval       [j] <= in_dval [j]      ;
               //  mask_packet_num [j] <= in_packet_num [4 *(j+1)-1  -: 4  ] ;
                mask_zero_num   [j] <= in_zero_num   [12*(j+1)-1  -: 12 ] ;
                mask_dout       [j] <= in_dout       [32*(j+1)-1  -: 32 ] ;
            end
            else begin
                mask_sop        [j] <= 'b0 ;
                mask_eop        [j] <= 'b0 ;
                mask_dval       [j] <= 'b0 ;
                // mask_packet_num [j] <= 'b0 ;
                mask_zero_num   [j] <= 'b0 ;
                mask_dout       [j] <= 'b0 ;
            end
        end 
    // end
end





wire               temp_sop        [0:SEG_NUM_IN-2]  ;
wire               temp_eop        [0:SEG_NUM_IN-2]  ;
wire               temp_dval       [0:SEG_NUM_IN-2]  ;
// wire  [4-1:0]      temp_packet_num [0:4*SEG_NUM_IN-2 ]  ;
wire  [12-1:0]     temp_zero_num   [0:12*SEG_NUM_IN-2]  ;
wire  [32-1:0]     temp_dout       [0:32*SEG_NUM_IN-2]  ;


assign temp_sop        [0] = mask_sop         [ 0 ] | mask_sop         [ 1 ] ;
assign temp_eop        [0] = mask_eop         [ 0 ] | mask_eop         [ 1 ] ;
assign temp_dval       [0] = mask_dval        [ 0 ] | mask_dval        [ 1 ] ;
// assign temp_packet_num [0] = mask_packet_num  [ 0 ] ^ mask_packet_num  [ 1 ] ;
assign temp_zero_num   [0] = mask_zero_num    [ 0 ] | mask_zero_num    [ 1 ] ;
assign temp_dout       [0] = mask_dout        [ 0 ] ^ mask_dout        [ 1 ] ;




genvar k;
generate 
    for (k=1; k<SEG_NUM_IN-1; k=k+1) begin : crossbar_element
        assign temp_sop        [k] = temp_sop        [k-1] | mask_sop        [k+1] ;
        assign temp_eop        [k] = temp_eop        [k-1] | mask_eop        [k+1] ;
        assign temp_dval       [k] = temp_dval       [k-1] | mask_dval       [k+1] ;
       //  assign temp_packet_num [k] = temp_packet_num [k-1] ^ mask_packet_num [k+1] ;
        assign temp_zero_num   [k] = temp_zero_num   [k-1] | mask_zero_num   [k+1] ;
        assign temp_dout       [k] = temp_dout       [k-1] ^ mask_dout       [k+1] ;
    end
endgenerate




 


  always @(posedge clk ) begin
      // if (rst) begin
      //     // reset
      //   out_sop        <= 'b0 ;
      //   out_eop        <= 'b0 ;
      //   out_dval       <= 'b0 ;
      //   out_packet_num <= 'b0 ;
      //   out_zero_num   <= 'b0 ;
      //   out_dout       <= 'b0 ;
      // end
      // else begin
        out_sop        <= temp_sop        [SEG_NUM_IN-2] ; 
        out_eop        <= temp_eop        [SEG_NUM_IN-2] ; 
        out_dval       <= temp_dval       [SEG_NUM_IN-2] ; 
        out_packet_num <= PKT_NUM_VALUE ; 
        out_zero_num   <= temp_zero_num   [SEG_NUM_IN-2] ; 
        out_dout       <= temp_dout       [SEG_NUM_IN-2] ; 
      // end
  end


























endmodule 







// 备份
// module merge_crossbar_element
// # ( 

//     parameter   SEG_NUM_IN       = 0 // ,
//                //  PKT_NUM_VALUE    = 0 

//   )


// ( 
//         input                  [3:0]    PKT_NUM_VALUE ,     

//         input                             clk  ,
//         input                             rst  ,

//         input   [SEG_NUM_IN-1:0]              in_sop        ,
//         input   [SEG_NUM_IN-1:0]              in_eop        ,
//         input   [SEG_NUM_IN-1:0]              in_dval       ,
//         input   [4*SEG_NUM_IN-1:0]            in_packet_num ,
//         input   [12*SEG_NUM_IN-1:0]           in_zero_num   ,
//         input   [32*SEG_NUM_IN-1:0]           in_dout       ,

//         output   reg                          out_sop        ,
//         output   reg                          out_eop        ,
//         output   reg                          out_dval       ,
//         output   reg [4-1:0]                  out_packet_num ,
//         output   reg [12-1:0]                 out_zero_num   ,
//         output   reg [32-1:0]                 out_dout       



//  ) ;





// reg               mask_sop        [0:SEG_NUM_IN-1]     ;
// reg               mask_eop        [0:SEG_NUM_IN-1]     ;
// reg               mask_dval       [0:SEG_NUM_IN-1]     ;
// // reg  [4-1:0]      mask_packet_num [0:4*SEG_NUM_IN-1 ]  ;
// reg  [12-1:0]     mask_zero_num   [0:SEG_NUM_IN-1]  ;
// reg  [32-1:0]     mask_dout       [0:SEG_NUM_IN-1]  ;


// integer i,j;
// always @(posedge clk or posedge rst) begin
//     if (rst) begin
//         // reset
//         for (i=0; i<SEG_NUM_IN; i=i+1) begin 
//             mask_sop        [i] <= 'b0 ;
//             mask_eop        [i] <= 'b0 ;
//             mask_dval       [i] <= 'b0 ;
//             // mask_packet_num [i] <= 'b0 ;
//             mask_zero_num   [i] <= 'b0 ;
//             mask_dout       [i] <= 'b0 ;
//         end 
//     end
//     else begin
//         for (j=0; j<SEG_NUM_IN; j=j+1) begin  
//             if ( in_packet_num[ 4*(j+1)-1 -: 4 ] == PKT_NUM_VALUE ) begin
//                 mask_sop        [j] <= in_sop  [j]      ;
//                 mask_eop        [j] <= in_eop  [j]      ;
//                 mask_dval       [j] <= in_dval [j]      ;
//                //  mask_packet_num [j] <= in_packet_num [4 *(j+1)-1  -: 4  ] ;
//                 mask_zero_num   [j] <= in_zero_num   [12*(j+1)-1  -: 12 ] ;
//                 mask_dout       [j] <= in_dout       [32*(j+1)-1  -: 32 ] ;
//             end
//             else begin
//                 mask_sop        [j] <= 'b0 ;
//                 mask_eop        [j] <= 'b0 ;
//                 mask_dval       [j] <= 'b0 ;
//                 // mask_packet_num [j] <= 'b0 ;
//                 mask_zero_num   [j] <= 'b0 ;
//                 mask_dout       [j] <= 'b0 ;
//             end
//         end 
//     end
// end





// wire               temp_sop        [0:SEG_NUM_IN-2]  ;
// wire               temp_eop        [0:SEG_NUM_IN-2]  ;
// wire               temp_dval       [0:SEG_NUM_IN-2]  ;
// // wire  [4-1:0]      temp_packet_num [0:4*SEG_NUM_IN-2 ]  ;
// wire  [12-1:0]     temp_zero_num   [0:12*SEG_NUM_IN-2]  ;
// wire  [32-1:0]     temp_dout       [0:32*SEG_NUM_IN-2]  ;


// assign temp_sop        [0] = mask_sop         [ 0 ] | mask_sop         [ 1 ] ;
// assign temp_eop        [0] = mask_eop         [ 0 ] | mask_eop         [ 1 ] ;
// assign temp_dval       [0] = mask_dval        [ 0 ] | mask_dval        [ 1 ] ;
// // assign temp_packet_num [0] = mask_packet_num  [ 0 ] ^ mask_packet_num  [ 1 ] ;
// assign temp_zero_num   [0] = mask_zero_num    [ 0 ] | mask_zero_num    [ 1 ] ;
// assign temp_dout       [0] = mask_dout        [ 0 ] ^ mask_dout        [ 1 ] ;




// genvar k;
// generate 
//     for (k=1; k<SEG_NUM_IN-1; k=k+1) begin : crossbar_element
//         assign temp_sop        [k] = temp_sop        [k-1] | mask_sop        [k+1] ;
//         assign temp_eop        [k] = temp_eop        [k-1] | mask_eop        [k+1] ;
//         assign temp_dval       [k] = temp_dval       [k-1] | mask_dval       [k+1] ;
//        //  assign temp_packet_num [k] = temp_packet_num [k-1] ^ mask_packet_num [k+1] ;
//         assign temp_zero_num   [k] = temp_zero_num   [k-1] | mask_zero_num   [k+1] ;
//         assign temp_dout       [k] = temp_dout       [k-1] ^ mask_dout       [k+1] ;
//     end
// endgenerate




 


//   always @(posedge clk or posedge rst) begin
//       if (rst) begin
//           // reset
//         out_sop        <= 'b0 ;
//         out_eop        <= 'b0 ;
//         out_dval       <= 'b0 ;
//         out_packet_num <= 'b0 ;
//         out_zero_num   <= 'b0 ;
//         out_dout       <= 'b0 ;
//       end
//       else begin
//         out_sop        <= temp_sop        [SEG_NUM_IN-2] ; 
//         out_eop        <= temp_eop        [SEG_NUM_IN-2] ; 
//         out_dval       <= temp_dval       [SEG_NUM_IN-2] ; 
//         out_packet_num <= PKT_NUM_VALUE ; 
//         out_zero_num   <= temp_zero_num   [SEG_NUM_IN-2] ; 
//         out_dout       <= temp_dout       [SEG_NUM_IN-2] ; 
//       end
//   end


// endmodule 



// 废弃=========================================================================================


// reg               mask_sop        [0:PKT_NUM_VALUE-1]  ;
// reg               mask_eop        [0:PKT_NUM_VALUE-1]  ;
// reg               mask_dval       [0:PKT_NUM_VALUE-1]  ;
// // reg  [4-1:0]      mask_packet_num [0:PKT_NUM_VALUE-1]  ;
// reg  [12-1:0]     mask_zero_num   [0:PKT_NUM_VALUE-1]  ;
// reg  [32-1:0]     mask_dout       [0:PKT_NUM_VALUE-1]  ;


// integer i,j;
// always @(posedge clk) begin
//     // if ( in_eop[PKT_NUM_VALUE-1] == 'b0 & PKT_NUM_VALUE != SEG_NUM_IN  ) begin
//     //     for (i=0; i<PKT_NUM_VALUE; i=i+1) begin 
//     //         mask_sop        [i] <= 'b0 ;
//     //         mask_eop        [i] <= 'b0 ;
//     //         mask_dval       [i] <= 'b0 ;
//     //         mask_packet_num [i] <= 'b0 ;
//     //         mask_zero_num   [i] <= 'b0 ;
//     //         mask_dout       [i] <= 'b0 ;
//     //     end 
//     // end
//     // else begin
//         for (j=0; j<PKT_NUM_VALUE; j=j+1) begin  
//             if ( in_packet_num[ 4*(j+1)-1 -: 4 ] == PKT_NUM_VALUE ) begin
//                 mask_sop        [j] <= in_sop  [j]      ;
//                 mask_eop        [j] <= in_eop  [j]      ;
//                 mask_dval       [j] <= in_dval [j]      ;
//                 // mask_packet_num [j] <= in_packet_num[ 4*PKT_NUM_VALUE-1 -: 4 ] ;
//                 mask_zero_num   [j] <= in_zero_num   [12*(j+1)-1  -: 12 ] ;
//                 mask_dout       [j] <= in_dout       [32*(j+1)-1  -: 32 ] ;
//             end
//             else begin
//                 mask_sop        [j] <= 'b0 ;
//                 mask_eop        [j] <= 'b0 ;
//                 mask_dval       [j] <= 'b0 ;
//                 // mask_packet_num [j] <= 'b0 ;
//                 mask_zero_num   [j] <= 'b0 ;
//                 mask_dout       [j] <= 'b0 ;
//             end
//         end 
//     // end
// end





// wire               temp_sop        [0:PKT_NUM_VALUE-1]  ;
// wire               temp_eop        [0:PKT_NUM_VALUE-1]  ;
// wire               temp_dval       [0:PKT_NUM_VALUE-1]  ;
// // wire  [4-1:0]      temp_packet_num [0:PKT_NUM_VALUE-1]  ;
// wire  [12-1:0]     temp_zero_num   [0:PKT_NUM_VALUE-1]  ;
// wire  [32-1:0]     temp_dout       [0:PKT_NUM_VALUE-1]  ;


// assign temp_sop        [0] = mask_sop         [ 0 ] ;
// assign temp_eop        [0] = mask_eop         [ 0 ] ;
// assign temp_dval       [0] = mask_dval        [ 0 ] ;
// // assign temp_packet_num [0] = mask_packet_num  [ 0 ] ;
// assign temp_zero_num   [0] = mask_zero_num    [ 0 ] ;
// assign temp_dout       [0] = mask_dout        [ 0 ] ;




// genvar k;
// generate 
//     for (k=1; k<PKT_NUM_VALUE; k=k+1) begin : crossbar_element
//         assign temp_sop        [k] = temp_sop        [k-1] | mask_sop        [k] ;
//         assign temp_eop        [k] = temp_eop        [k-1] | mask_eop        [k] ;
//         assign temp_dval       [k] = temp_dval       [k-1] | mask_dval       [k] ;
//         // assign temp_packet_num [k] = temp_packet_num [k-1] | mask_packet_num [k] ;
//         assign temp_zero_num   [k] = temp_zero_num   [k-1] | mask_zero_num   [k] ;
//         assign temp_dout       [k] = temp_dout       [k-1] ^ mask_dout       [k] ;
//     end
// endgenerate




 


//   always @(posedge clk or posedge rst) begin
//       if (rst) begin
//           // reset
//         out_sop        <= 'b0 ;
//         out_eop        <= 'b0 ;
//         out_dval       <= 'b0 ;
//         out_packet_num <= 'b0 ;
//         out_zero_num   <= 'b0 ;
//         out_dout       <= 'b0 ;
//       end
//       else begin
//         out_sop        <= temp_sop        [PKT_NUM_VALUE-1] ; 
//         out_eop        <= temp_eop        [PKT_NUM_VALUE-1] ; 
//         out_dval       <= temp_dval       [PKT_NUM_VALUE-1] ; 
//         out_packet_num <= PKT_NUM_VALUE ; 
//         out_zero_num   <= temp_zero_num   [PKT_NUM_VALUE-1] ; 
//         out_dout       <= temp_dout       [PKT_NUM_VALUE-1] ; 
//       end
//   end