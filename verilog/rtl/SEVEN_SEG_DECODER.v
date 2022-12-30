/*
*********************************************************
* Design			:Seven Segment Decoder				*
* Model Name		:SEVEN_SEG_DECODER					*
* Modelling Style	:Structural Modelling				*
* Language			:Verilog							*
*********************************************************
* Description:											*
* This is an implementation of BCD to Seven Segment 	*
* Decoder. The module takes 4 bit BCD input and converts*
* it into equivalent sevent bit output which can be used*
* to drive Seven Segment Displays. The design is made 	*
* Common Cathode Seven Segment Display.					*
*********************************************************
* This Project is developed by:							*
*	1. Vrushabh Damle	 								*
*	2. Debayan Mazumdar									*
*	3. Nishad Potdar									*
*********************************************************
*/
module SEVEN_SEG_DECODER
(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

input [3:0] i,          // i[0] = A | i[1] = B | i[2] = C | i[3] = D
output a,
output b, 
output c,
output d,
output e,
output f, 		
output g,  		
);
wire [16:0] t;    

//a = B + D + AC + A'C' 
xnor g1 (t[0], i[0], i[2]) ; 
or   g2 (a, i[1], i[3], t[0]) ; 

//b = C' + B'A' + BA 
xnor g3 (t[1], i[0], i[1]) ; 
not  g4 (t[2], i[2]) ; //C'
or   g5 (b, t[1], t[2]) ; 

//c = C + B' +A 
not  g6 (t[3], i[1]) ; //B'
or   g7 (c, i[2], t[3], i[0]) ; 

//d = C'A' + C'B + CB'A + D + BA'
not  g8 (t[4], i[0]) ;  //A'
and  g9 (t[5], i[1], t[4]) ; 
not  g10 (t[6], i[1]) ; 
and  g11 (t[7], i[2], t[6], i[0]) ; 
and  g12 (t[8], t[2], i[1]) ; 
and  g13 (t[9], t[2], t[4]) ; 
or   g14 (d, t[5], t[7], t[8], t[9], i[3]) ; 

//e = C'A' + BA' 
and  g15 (t[10], i[1], t[4]) ; 
and  g16 (t[11], t[2], t[4]) ; 
or   g17 (e, t[10], t[11]) ; 

//f = D + B'A' + CB' + CA' 
and  g18 (t[12], t[4], i[2]) ; 
and  g19 (t[13], t[3], i[2]) ; 
and  g20 (t[14], t[3], t[4]) ; 
or   g21 (f, i[3], t[12], t[13], t[14]) ; 

//g = D + CB' + C'B + BA' 
xor  g22 (t[15], i[2], i[1]) ; 
and  g23 (t[16], t[4], i[1]) ;
or   g24 (g, i[3], t[16], t[15]); 
endmodule 
