# Low-Cost-and-Programmable-CRC

Two algorithms and a method are given here to implement a low-cost and high performance CRC. The ethernet CRC32 is used here, because it is the most used CRC. The design is developed by verilog and it is verified in VC709 FPGA board. More information can be founded in paper "Low-Cost and Programmable CRC Implementation based on FPGA".

## Parallel CRC implementation
The matlab codes are developed for the computation of matrix T^n and matrix W(l,n), which are used in equation (5) of paper "Low-Cost and Programmable CRC Implementation based on FPGA".

## Stride-by-5 algorithm
The stride-by-5 algorithm make full use of 5-inputs LUTs in Xilinx FPGAs. Matlab codes are developed for the initial value of LUTs. These matlab codes are based on the results of the previous matlab codes, which are used to compute T^n and W(l,n). Verilog codes for the stride-by-5 algorithm and the xor tree are developed, and they are verified on VC709 FPGA board.

## Pipelining go back algorithm
The algorithm is used to solve the final beat problem, which is descriped in the paper. The overhead can achieve an O(log(n)) overhead. Matlab codes are developed for the computation of matrix T^(-n). These computation are based on GF(2). Another matlab code is developed for the translation from matrix T^(-n) to the initial value of LUTs. Verilog codes are developed, and they are verified on VC709 FPGA board.

## Reprogramming by HWICAP
This method is least described in the paper but most described here. As far as we know, this is the
first open source code covering the whole procedure of programming a single LUT. A complete procedure is described in the document, and the code(including tcl, python and verilog) are given here.

## Test result
The synthesis result, which is present as a vivado synthesis report is given here. The LUTs consumption and frequency can be founded.
The board-level implementation result is given. Resaults in Spirent TestCenter are presented. Vio is presented in vivado hardware manager to show the "Error Frame Statistics Result" and "Error Frame Statistics Result".
