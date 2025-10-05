`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////


module TB;

	// Inputs
	reg [7:0] A;
	reg [7:0] B;

	// Outputs
	wire [15:0] P;

	// Instantiate the Unit Under Test (UUT)
	multiplier_using_RCA uut (
		.A(A), 
		.B(B), 
		.P(P)
	);

	initial begin
		// Initialize Inputs
		
		A = 10;
		B = 10 ;
		#3;
        A = 100;
        B = 200 ;
        #3;
		A = 120;
        B = 100 ;
        #3;
        A = 50 ;
        B = 200 ;
        #3;
        A = 80;
        B = 20 ;
         #3;
        A = 40;
        B = 60 ;
        #3;
		$stop ;
	end
      
endmodule

