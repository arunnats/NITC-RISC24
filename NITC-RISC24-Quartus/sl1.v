module sl1(input [15:0]a , output [15:0] y);
	assign y = {a[14:0],1'b0}; 
endmodule
