module carry_generate(input [15:0] A,B,
							input [2:0] F,
							output carry);

reg tmp_carry;
reg [15:0] tmp_add;

always @(*)
	begin

	if(F == 3'b0)
		begin
			if(A[15] & B[15])
				begin
					tmp_carry = 1;
				end
			else if(~A[15] & ~B[15])
				begin
					tmp_carry = 0;
				end
			else if(A[15] ^ B[15])
				begin
					tmp_add = {1'b0,A[14:0]} + {1'b0,B[14:0]};
					tmp_carry = tmp_add[15];
				end
		end
	end

assign carry = tmp_carry;

endmodule