module maindec(input clk, reset,
					input [3:0] op,
					output pcwrite, memwrite, irwrite, regwrite,
					output alusrca, branch, iord, memtoreg, regdst,
					output [1:0] alusrcb,
					output [1:0] pcsrc,
					output reg [4:0] state);
	//FSM
	parameter FETCH =5'b00000; 
	parameter DECODE=5'b00001;
	parameter MEMADR=5'b00010; 
	parameter MEMRD=5'b00011;
	parameter MEMWB=5'b00100;
	parameter MEMWR=5'b00101;
	parameter EXECUTE=5'b00110;
	parameter ALUWRITEBACK=5'b00111;
	parameter BRANCH=5'b01000;
	parameter JALRW=5'b01001;
	parameter JALPC=5'b01010;
	
	//opcodes
	parameter LW = 4'b1010;
	parameter SW = 4'b1001;
	parameter ADD = 4'b0000;
	parameter BEQ = 4'b1011;
	parameter NDU = 4'b0010;
	parameter JAL = 4'b1101;
	
	reg [4:0] nextstate;
	reg [12:0] controls;
	
	//state reg
	always @(posedge clk or posedge reset)
		if(reset) state <= FETCH;
		else state <= nextstate;
	//next state logic
	
	always @(*)
		case(state)
			FETCH: nextstate <=DECODE;
			DECODE: case(op)
				LW: nextstate <=MEMADR;
				SW: nextstate <=MEMADR;
				ADD: nextstate <=EXECUTE;
				NDU: nextstate <=EXECUTE;
				BEQ: nextstate <= BRANCH;
				JAL: nextstate <=JALRW;
				default: nextstate <=FETCH;
				endcase
			MEMADR: case(op)
				LW: nextstate <=MEMRD;
				SW: nextstate <=MEMWR;
				default: nextstate <=FETCH;
				endcase
			MEMRD: nextstate <=MEMWB;
			MEMWB: nextstate <=FETCH;
			MEMWR: nextstate <=FETCH;
			EXECUTE: nextstate <=ALUWRITEBACK;
			ALUWRITEBACK: nextstate <=FETCH;
			BRANCH: nextstate <=FETCH;
			JALRW: nextstate <=JALPC;
			JALPC: nextstate <=FETCH;
			default: nextstate <=FETCH;
		endcase
	//output control signals logic. we don't need aluop because the mapping for op to alucontrol is 1 to 1
	assign {pcwrite, memwrite, irwrite, regwrite,
				alusrca, branch, iord, memtoreg, regdst, 
				alusrcb, pcsrc} = controls;
	
	always @(*)
		case(state)
			FETCH:  			controls   <=   13'b1010_00000_0100;  
			DECODE:  		controls   <=   13'b0000_00000_1100;  
			MEMADR:  		controls   <=   13'b0000_10000_1000;  
			MEMRD:   		controls   <=   13'b0000_00100_0000;  
			MEMWB:   		controls   <=   13'b0001_00010_0000;  
			MEMWR:   		controls   <=   13'b0100_00100_0000;  
			EXECUTE:   		controls   <=   13'b0000_10000_0000;  
			ALUWRITEBACK:  controls   <=   13'b0001_00001_0000;  
			BRANCH:   		controls   <=   13'b0000_11000_0001;  
			JALRW: 			controls   <= 	 13'b0001_00000_0010;
			JALPC:   		controls   <=   13'b1000_00000_0010;   
			default:   		controls   <=   13'b0000_xxxxx_xxxx; 
		endcase
endmodule
