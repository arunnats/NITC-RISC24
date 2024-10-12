module regfile(input clk,
					input pc,
					input [1:0]IR_CZ,
					input [2:0]F,
					input inc,inz,
					input we3,
					input [2:0] ra1, ra2, wa3,
					input [15:0] wd3,
					output [15:0] rd1, rd2,
					output [15:0] r0,r1,r2,r3,r4,r5,r6,r7);
			
	reg [15:0] rf[0:7];
	assign r0 = rf[0];
	assign r1 = rf[1];
	assign r2 = rf[2];
	assign r3 = rf[3];
	assign r4 = rf[4];
	assign r5 = rf[5];
	assign r6 = rf[6];
	assign r7 = rf[7];
	
	reg C,Z;
	wire czwe3;
	assign czwe3 = we3 & ~((IR_CZ == 2'b10 &&  C != 1) || (IR_CZ[1:0] == 2'b01 && Z != 1));
	//using the previous values and the adc and ndc knowledge, we can decide to write in 
	//we3 = we3 & (adc ndz combinational logic)
	//we write for all opcodes, except when (adc and c !=1 or ndz and z!=1)
	//after we have written in, then we can change the value of C and Z
	
	always @(posedge clk)
		begin
			//first we write into the register file based on previous C and Z values
			if(czwe3) rf[wa3] =wd3;

			//if regwrite is active, that means we are in aluwb or memwb
			//we only change the carry when we are in an add instruction, so F = 000 from the alu decoder
			//we change the zero whenever the operation is anything other than BEQ, JAL or SW, so whenever F = Alucontrol < 011
			
			if(we3 && F == 3'b000) C = inc;
			if(we3 && F < 3'b011) Z = inz;
			rf[0] = pc;//rf[0] must always contain pc
		end
	assign rd1 = (ra1 != 0) ? rf[ra1]: 16'b0;
	assign rd2 = (ra2 !=0 ) ? rf[ra2]: 16'b0;
endmodule

