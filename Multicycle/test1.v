module test1(	input clk, reset,
					output [15:0] pc,
					output [4:0] state,
					output [15:0] r0,r1,r2,r3,r4,r5,r6,r7,
					output [15:0] writedata, adr,
					output memwrite);

	wire [15:0] readdata;
	
	//instantiate processor and memory
	mips mips(clk, reset, adr, writedata, memwrite, readdata, pc, state, r0,r1,r2,r3,r4,r5,r6,r7);
	mem mem(clk, memwrite,adr, writedata, readdata);
				
endmodule 