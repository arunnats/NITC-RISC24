module controller(input clk, reset,
						input [3:0] op,
						input compare,
						output pcen, memwrite, irwrite, regwrite,
						output alusrca, iord, memtoreg, regdst,
						output [1:0] alusrcb,
						output [1:0] pcsrc,
						output [2:0] alucontrol,
						output [4:0] state);
	wire branch, pcwrite;
	//main decoder and alu decoder
	maindec md(clk, reset, op,
				pcwrite, memwrite, irwrite, regwrite,
				alusrca, branch, iord, memtoreg, regdst,
				alusrcb, pcsrc, state );
	aludec ad(op,alucontrol);
	assign pcen = pcwrite | ( branch & compare );
endmodule