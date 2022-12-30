/*
*********************************************************
* Design: 		Carry Look-Ahead Adder		*
* Model Name:		cla				*
* Modelling Style:	Structural Modelling		*
* Language:		Verilog				*
*********************************************************
* Description:						*
* This is an implementation of a Carry Look-Ahead	*
* Adder which has two 4-bit Input Ports "A" and "B"	*
* and a single bit input carry port "cin". It also	*
* has a 4-bit Output Port "S" and a single bit 		*
* output carry port "cout".				*
* 							*
* The carry look-ahead adder is very fast because	*
* the calculation of the next carry is independent	*
* of the previous carry and only depends on the 	*
* input carry.						*
*********************************************************
* This Project is developed by:				*
*	1. Vrushabh Damle				*
*	2. Debayan Mazumdar				*
*	3. Nishad Potdar				*
*********************************************************
*/
`default_nettype none
	
module cla (

//Definition of the Power Pins

`ifdef USE_POWER_PINS
	inout vccd1, //User area 1 1.8V Supply
	inout vssd1, //User area 1 digital ground
`endif

//Input Pins

input [3:0] A,
input [3:0] B, 
input cin,

//Output Pins

output [3:0] S,
output cout,
);

//Wire Declaration

wire [3:0] p,g;
wire c1, c2, c3; 
wire [9:0]t ;

//Instantiation of the Carry Propagator

genvar i ; 
 generate 
 for (i=0 ; i<4 ; i=i+1)
	begin : carry_propagator  
		xor cp (p[i], A[i], B[i]) ;
	end 
endgenerate

//Instantiation of the Carry Generator

genvar j ;
 generate 
 for (j=0 ; j<4 ; j=j+1)
	begin : carry_generator  
		and cg (g[j], A[j], B[j]) ;
	end 
endgenerate

//Logical derivation of C1

and a1 (t[0], p[0],cin) ; 
or  o1 (c1, t[0], g[0]) ; 

//Logical derivation of C2

and a2 (t[1], p[1], p[0], cin) ;
and a3 (t[2], p[1], g[0]);
or  o2 (c2, g[1], t[1], t[2]);

//Logical derivation of C3

and a4 (t[3], p[2], p[1], p[0], cin) ;
and a5 (t[4], p[2], p[1], g[0]); 
and a6 (t[5], p[2], g[1]); 
or  o3 (c3, t[3], t[4], t[5], g[2]) ;

//Logical derivation of Cout
 
and a7 (t[6], p[3], p[2], p[1], p[0], cin) ;
and a8 (t[7], p[3], p[2], p[1], g[0]); 
and a9 (t[8], p[3], p[2], g[1]);
and a10 (t[9], p[3], g[2]); 
or  o4 (cout, t[6], t[7], t[8], t[9], g[3]) ;
		
//Logical derivation of the Sums

xor x1(S[0], p[0], cin) ;
xor x2(S[1], p[1], c1) ;
xor x3(S[2], p[2], c2) ;
xor x4(S[3], p[3], c3) ;
		
endmodule 

`default_nettype wire
