module alu(input [15:0] A, B, 
				input [2:0] F, 
				output compare, 
				output carry, 
				output reg [15:0] Y, 
				output zero);
	
	assign zero = (Y==16'b0) && ( F< 3'b011);
	carry_generate cg(A,B,F, carry);
	always@(*)
		case(F)
			3'b001:Y <= ~(A&B);
			default:Y <= A+B;
		endcase
	assign compare = (Y==16'b0);
endmodule