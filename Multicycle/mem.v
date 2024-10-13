module mem(input clk, we, input [15:0] a, wd, output [15:0] rd);

	reg[15:0] RAM[63:0];
	initial
		begin
			RAM[0] <= 16'b0000_001_010_100_0_00; //ADD
			RAM[1] <= 16'b0000_001_010_111_0_10;
			RAM[2] <= 16'b0000_001_011_101_0_00;
			RAM[3] <= 16'b0000_001_010_111_0_10;
		end
	assign rd = RAM[a[15:1]]; //word aligned
	
	always @(posedge clk)
		if (we) RAM[a[15:1]] <=wd;
endmodule