module  mips(input clk, reset,
					output [15:0] adr, writedata,
					output memwrite,
					input [15:0] readdata,
					output [15:0] pc,
					output [4:0] state,
					output [15:0] r0,r1,r2,r3,r4,r5,r6,r7);
					
	wire zero, pcen, irwrite, regwrite, alusrca, iord, memtoreg, regdst;
	wire [1:0] alusrcb;
	wire [1:0] pcsrc;
	wire [1:0] alucontrol;
	wire [3:0] op;
	wire compare;
	controller c(clk, reset, op, compare, pcen, memwrite, irwrite, regwrite, alusrca, iord, memtoreg, regdst, alusrcb, pcsrc, alucontrol,state);

	//NEEDS TO BE CHECKED FOR PORTS
	datapath dp(clk, reset,
					pcen, irwrite, regwrite,
					alusrca, iord, memtoreg, regdst,
					alusrcb, pcsrc, alucontrol,
					op, compare,
					adr, writedata, readdata,
					pc,r0,r1,r2,r3,r4,r5,r6,r7);
	
endmodule