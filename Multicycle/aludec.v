module aludec( input [3:0] op,
					output reg [2:0] alucontrol);
	always@(*)
		case(op)
			4'b0000: alucontrol <=3'b000; //add
			4'b0010: alucontrol <=3'b001; //nand
			4'b1010: alucontrol <=3'b010; //lw
			4'b1001: alucontrol <=3'b011; //sw
			4'b1011: alucontrol <=3'b100; //beq
			4'b1101: alucontrol <=3'b101; //jal
			default: alucontrol <=3'bx;
		endcase
endmodule