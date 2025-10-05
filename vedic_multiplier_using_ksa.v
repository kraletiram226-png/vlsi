module  tb ;
reg [7:0] A,B ;
wire [15:0] S ;

Vedic_multiplier8bit uut (A,B,S);

initial
begin
    A = 100 ;
    B = 100 ;
    #2 ;
    A = 130 ;
	B = 10 ;
    #2 ;
    A = 80 ;
    B = 30 ;
    #2 ;
    A = 50 ;
    B = 50 ;
    #2 ;
    $stop ;
end
endmodule

///8 BIT VEDIC MULTIPLIER
module Vedic_multiplier8bit(A,B,S);

input [7:0] A,B ;
output [15:0] S ;
wire [3:0] W1 ;
wire [7:0] W2,W3,W4,W5 ;

Vedic_multiplier4bit mult1(.A(A[3:0]), .B(B[3:0]), .S({W1,S[3:0]}));
Vedic_multiplier4bit mult2(.A(A[3:0]), .B(B[7:4]), .S(W2));
Vedic_multiplier4bit mult3(.A(A[7:4]), .B(B[3:0]), .S(W3));
Vedic_multiplier4bit mult4(.A(A[7:4]), .B(B[7:4]), .S(W4));

KSA8BIT Add1(.A(W3),.B(W2),.Cin(1'b0),.SUM(W5),.CARRY(Ca1));

KSA8BIT Add2(.A({W4[3:0],W1}),.B(W5),.Cin(1'b0),.SUM(S[11:4]),.CARRY(Cb1));

assign r1 = Ca1 || Cb1 ;

assign S[15:12] = W4[7:4] + r1 ;

endmodule 

///////////4 BIT MULTIPLIER///////////////
module Vedic_multiplier4bit(A,B,S);

input [3:0] A,B ;
output [7:0] S ;
wire [1:0] W1 ;
wire [3:0] W2,W3,W4,W5 ;

multiplier2bit mult1(.A(A[1:0]), .B(B[1:0]), .P({W1,S[1:0]}));
multiplier2bit mult2(.A(A[1:0]), .B(B[3:2]), .P(W2));
multiplier2bit mult3(.A(A[3:2]), .B(B[1:0]), .P(W3));
multiplier2bit mult4(.A(A[3:2]), .B(B[3:2]), .P(W4));

KSA4BIT Add1(.A(W3),.B(W2),.Cin(1'b0),.SUM(W5),.CARRY(Ca1));

KSA4BIT Add2(.A({W4[1:0],W1}),.B(W5),.Cin(1'b0),.SUM(S[5:2]),.CARRY(Cb1));

assign r1 = Ca1 || Cb1 ;

assign S[7:6] = W4[3:2] + r1 ;

endmodule 
/////////// 2 BIT MULTIPLIER ///////////////
module multiplier2bit(A,B,P);

input [1:0] A,B ;
output [3:0] P ;

assign  P[0] = A[0] && B[0] ;

half_adder ha1(.a(A[0] && B[1]), .b(A[1] && B[0]), .sum (P[1]), .carry(hc1));

half_adder ha2(.a(A[1] && B[1]), .b(hc1), .sum (P[2]), .carry(P[3]));

endmodule

//HALF ADDER

module half_adder(a,b,sum,carry) ;

input a,b ;
output sum,carry ;

assign sum = a ^ b ;
assign carry = a && b ;

endmodule




module KSA8BIT(A,B,Cin,SUM,CARRY);

input [7:0]A,B;
input Cin;
output [7:0]SUM;
output CARRY ;

KSA4BIT ksa1(.A(A[3:0]),.B(B[3:0]),.Cin(Cin),.SUM(SUM[3:0]),.CARRY(C1));
KSA4BIT  ksa2(.A(A[7:4]),.B(B[7:4]),.Cin(C1),.SUM(SUM[7:4]),.CARRY(CARRY));

endmodule 


module KSA4BIT (A,B,Cin,SUM,CARRY);

input [3:0]A,B;
input Cin;
output [3:0]SUM;
output CARRY ;

wire [3:0] p,g ;
assign g[0] = A[0] & B [0];
assign g[1] = A[1] & B [1];
assign g[2] = A[2] & B [2];
assign g[3] = A[3] & B [3];

assign p[0] = A[0] ^ B[0] ;
assign p[1] = A[1] ^ B[1] ;
assign p[2] = A[2] ^ B[2] ;
assign p[3] = A[3] ^ B[3] ;


gn sm1(.g2(g[0]),.p2(p[0]),.g1(Cin),.G(g0));
gp sm2(.g2(g[1]),.p2(p[1]),.g1(g[0]),.p1(p[0]),.G(g1),.P(p1));
gp sm3(.g2(g[2]),.p2(p[2]),.g1(g[1]),.p1(p[1]),.G(g2),.P(p2));
gp sm4(.g2(g[3]),.p2(p[3]),.g1(g[2]),.p1(p[2]),.G(g3),.P(p3));

gn sm5(.g2(g1),.p2(p1),.g1(Cin),.G(g10));
gn sm6(.g2(g2),.p2(p2),.g1(g1),.G(g11));
gp sm7(.g2(g3),.p2(p3),.g1(g2),.p1(p2),.G(g21),.P(p21));


gn sm8(.g2(g21),.p2(p21),.g1(Cin),.G(g20));

assign SUM [0] = p[0] ^ Cin ;
assign SUM [1] = p[1] ^ g0 ;
assign SUM [2] = p[2] ^ g10 ;
assign SUM [3] = p[3] ^ g11 ;

assign CARRY = (Cin&p21 ) ||g20 ;
endmodule

module gp(g2,p2,g1,p1,G,P);  
input  g1,p1,g2,p2;  
output G,P;  
assign G = ( g2 | (g1&p2));  
assign P = p1&p2;  
endmodule
module gn(g2,p2,g1,G);  
    
input  g1,g2,p2;  
output G ;  
  
assign G = g2 | (g1&p2);  
  
endmodule 