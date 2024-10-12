module datapath(	input clk, reset,
						input pcen, irwrite, regwrite,
						input alusrca, iord, memtoreg, regdst,
						input [1:0] alusrcb,
						input [1:0] pcsrc,
						input [2:0] alucontrol,
						output [3:0] op,
						output compare,
						output [15:0] adr, writedata,
						input [15:0] readdata,
						output [15:0]pc,
						output [15:0] r0,r1,r2,r3,r4,r5,r6,r7);
	wire [2:0] writereg, writeregjal;
	wire [15:0] pcnext;
	wire [15:0] instr, data, srca, srcb;
	wire [15:0] a;
	wire [15:0] aluresult, aluout;
	wire [15:0] signimm,signimmbr,signimmjal; //sign extended imm
	wire [15:0] signimmsh; //sign extended immediate left shifted by 1 or 0?
	wire [15:0] wd3, rd1, rd2, wd3jal;
	wire carry,zero;
	//op field to controller
	assign op = instr[15:12];
	//datapath
		//set up the new value replacements for 
			//pc
			//instr
			//read data
		
		flopenr #(16) prcreg(clk, reset, pcen, pcnext, pc);//pc = pcnext, pc always contains the new pc
		mux2 #(16) admux(pc,aluout,iord,adr);//choose between pc and alout for address based on i/o or read data memory selector
		flopenr #(16) instrreg(clk,reset,irwrite,readdata,instr); //instr = readdata
		flopr #(16) datareg(clk, reset, readdata,data); //data = readdata
		
		//register file
		mux2 #(3) regdstmux(instr[8:6],instr[5:3], regdst, writereg); //choose between rt and rd for the destination register
		mux2 #(3) regdstmuxjal(writereg, 3'b111, pcsrc[1], writeregjal); //choose between r7 and writereg for the destination register 
		
		
		mux2 #(16) wdmux(aluout, data, memtoreg, wd3);// choose the write-back data between aluout and the readdata(sw)
		mux2 #(16) wdmuxjal(wd3, aluresult, pcsrc[1], wd3jal);//choose the write-back data between aluresult, wd3 for wd3jal
		
		regfile regf(clk, pc, instr[1:0],alucontrol, carry,zero, regwrite,instr[11:9],instr[8:6], writeregjal, wd3jal, rd1, rd2, r0,r1,r2,r3,r4,r5,r6,r7); //instantiate the registerfile
		
		//signextend for branch and jal

		signext #(6) brse(instr[5:0],signimmbr);
		signext #(9) jlse(instr[8:0], signimmjal);
		mux2 #(16) slmux(signimmbr,signimmjal, pcsrc[1],signimm); 
		sl1 immsh(signimm, signimmsh);
		
		flopr #(16) areg(clk, reset, rd1, a);//a = rd1, i.e the first read port output
		flopr #(16) breg(clk, reset, rd2, writedata);//writedata = rd2, i.e the second read port output
		mux2 #(16) scramux(pc, a, alusrca, srca);//srca is between pc(when pc +2 is done ) and a
		mux4 #(16) srcbmux(writedata,16'b10, signimm,signimmsh, alusrcb, srcb);// srcb is between writedata, 2, signimm, signimmsh
		//alu
		alu alu(srca, srcb,alucontrol,compare, carry, aluresult, zero);
		flopr #(16) alureg(clk, reset, aluresult, aluout);// aluout = aluresult
		
		//finally deciding next pc
		
		mux3 #(16) pcmux(aluresult, aluout,aluout, pcsrc, pcnext);//00- normal, 01 -  aluresult from branch, 10 - aluresult from jal
	
endmodule
