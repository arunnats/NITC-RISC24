module testbench();

    reg clk, reset;
    integer cycle_count = 0; // Cycle counter
    wire [15:0] adr, writedata, pc, r0, r1, r2, r3, r4, r5, r6, r7;
    wire [4:0] state;
    wire memwrite;

    // Instantiate NITC-RISC24
    NITCRisc24 uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .state(state),
        .r0(r0), .r1(r1), .r2(r2), .r3(r3),
        .r4(r4), .r5(r5), .r6(r6), .r7(r7),
        .writedata(writedata),
        .adr(adr),
        .memwrite(memwrite)
    );

    initial begin
        $dumpfile("waveform.vcd");  
        $dumpvars(0, testbench);   

        reset = 1; #22;
        reset = 0;
    end

    // Infinite clock generation
    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

    // Monitor state and register values at each clock cycle
    always @(posedge clk) begin
        cycle_count = cycle_count + 1;
        $display("Cycle %0d:", cycle_count);
        $display("FSM State: %s", get_state_name(state));
        $display("r0 = %h, r1 = %h, r2 = %h, r3 = %h", r0, r1, r2, r3);
        $display("r4 = %h, r5 = %h, r6 = %h, r7 = %h", r4, r5, r6, r7);
        $display("PC = %h, ADR = %h, WriteData = %h", pc, adr, writedata);
        
        if (cycle_count == 50) begin
            $stop;
        end
    end

    // Function to map state values to state names
    function [8*20:1] get_state_name(input [4:0] state);
        case (state)
            5'b00000: get_state_name = "FETCH";
            5'b00001: get_state_name = "DECODE";
            5'b00010: get_state_name = "MEMADR";
            5'b00011: get_state_name = "MEMRD";
            5'b00100: get_state_name = "MEMWB";
            5'b00101: get_state_name = "MEMWR";
            5'b00110: get_state_name = "EXECUTE";
            5'b00111: get_state_name = "ALUWRITEBACK";
            5'b01000: get_state_name = "BRANCH";
            5'b01001: get_state_name = "JALRW";
            5'b01010: get_state_name = "JALPC";
            default:  get_state_name = "UNKNOWN";
        endcase
    endfunction

endmodule
