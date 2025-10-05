module multiplier_using_RCA(A ,B,P);

input [7:0] A ,B ;


output [15:0] P ;

wire [3:0] W1 ,S2 ;
wire [7:0] W2,W3,W4 ,S1 ;

wire ca1 ,ca2 ;
//multiplier_4bit(A ,B,,P);
multiplier_4bit mul1(.A(A[3:0]) ,.B(B[3:0]),.P({W1,P[3:0]}));

multiplier_4bit mul2(.A(A[7:4]) ,.B(B[3:0]),.P(W2));

multiplier_4bit mul3(.A(A[3:0]) ,.B(B[7:4]),.P(W3));

multiplier_4bit mul4(.A(A[7:4]) ,.B(B[7:4]),.P(W4));

adder_8bit add1( .A(W2) , .B(W3), .Cin(1'b0) , .Sum(S1) , .Carry(ca1));
adder_8bit add2( .A(S1) , .B({4'd0,W1}), .Cin(1'b0) ,  .Sum({S2,P[7:4]}) , .Carry(ca2));
adder_8bit add3( .A({2'd0,ca1,ca2,S2}) , .B(W4), .Cin(1'b0) , .Sum(P[15:8]) , .Carry(Gc));

endmodule 


module   adder_8bit( A , B, Cin  , Sum , Carry);

input [7:0] A , B ;

input Cin   ;

output [7:0] Sum ; 

output  Carry ;

//adder_4bit( A , B, Cin , Sum , Carry);

adder_4bit ad1( .A(A[3:0]) , .B(B[3:0]), .Cin(Cin) , .Sum(Sum[3:0]) , .Carry(c1));

adder_4bit ad2( .A(A[7:4]) , .B(B[7:4]), .Cin(c1) , .Sum(Sum[7:4]) , .Carry(Carry));


endmodule 

///4BIT VEDIC MULTIPLIER
module multiplier_4bit(A,B,P);

input [3:0]A,B ;
output [7:0] P ;

wire [1:0] W1 ,S2 ;
wire [3:0] W2,W3,W4 ,S1 ;

wire ca1 ,ca2 ;

multiplier_2bit mul1(.A(A[1:0]) ,.B(B[1:0]),.P({W1,P[1:0]}));

multiplier_2bit mul2(.A(A[3:2]) ,.B(B[1:0]),.P(W2));

multiplier_2bit mul3(.A(A[1:0]) ,.B(B[3:2]),.P(W3));

multiplier_2bit mul4(.A(A[3:2]) ,.B(B[3:2]),.P(W4));

adder_4bit add1( .A(W2) , .B(W3), .Cin(1'b0) , .Sum(S1) , .Carry(ca1));
adder_4bit add2( .A(S1) , .B({2'b00,W1}), .Cin(1'b0) ,  .Sum({S2,P[3:2]}) , .Carry(ca2));
adder_4bit add3( .A({ca1,ca2,S2}) , .B(W4), .Cin(1'b0) ,  .Sum(P[7:4]) , .Carry(Gc));


endmodule

//////4BIT RCA

module adder_4bit(A,B,Cin,Sum,Carry);

input [3:0]A,B;
input Cin;
output [3:0]Sum;
output Carry ;

//full_adder(a,b,c,sum,carry) ;
full_adder fa1( .a(A[0]) , .b(B[0]) , .c(Cin) , .sum(Sum[0]) , .carry(C1) ) ;
full_adder fa2( .a(A[1]) , .b(B[1]) , .c(C1) , .sum(Sum[1]) , .carry(C2) ) ;
full_adder fa3( .a(A[2]) , .b(B[2]) , .c(C2) , .sum(Sum[2]) , .carry(C3) ) ;
full_adder fa4( .a(A[3]) , .b(B[3]) , .c(C3) , .sum(Sum[3]) , .carry(Carry) ) ;

endmodule
//FULL ADDER

module full_adder(a,b,c,sum,carry) ;

input a,b,c ;
output sum,carry ;

half_adder ha1(.a(a), .b(b), .sum (s1), .carry(hc1));
half_adder ha2(.a(s1), .b(c), .sum (sum), .carry(hc2));

assign carry = hc1|hc2 ;

endmodule

//2 BIT MULTIPLIER
module multiplier_2bit (A,B,P);

input [1:0] A,B ;//A[1],A[0]
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
