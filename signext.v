module signext #(parameter WIDTH = 6)
					(input [WIDTH-1:0]a, output [15:0]y);
	assign y = {{(15-WIDTH){a[WIDTH-1]}}, a};
endmodule