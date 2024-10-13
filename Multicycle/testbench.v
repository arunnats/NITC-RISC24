module testbench();

	reg clk,reset;
	wire [15:0] adr,writedata;
	wire memwrite;
	
	//dut instantiation
	Multicycle multicycle_processor(clk,reset,
						adr,writedata,memwrite);
	
	initial
	begin
		reset=1; #22;
		reset=0;
	end
	
	always
	begin
		clk=0;#10;
		clk=1;#10;
	end
	
	//check
	always@(negedge clk)
	begin
		if(memwrite)
		begin
			if(adr === 4 & writedata === 1)
			begin
				$display("Simulation succeeded!!");
				#100;
				$stop;
			end
		end
	end
	
endmodule
