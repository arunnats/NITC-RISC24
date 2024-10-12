# NITC-RISC18 Multicycle Processor

## Objective
To develop a **16-bit multicycle processor**, **NITC-RISC18**, which features:
- 8 general-purpose registers (R0-R7)
- A **Condition Code register** to store carry and zero flags
- **R0** as the program counter (PC)
- **Word-addressable instruction and data memory**
- Support for three types of instructions

## Datapath Overview
The processor follows a modular approach with the following main components:

### Modules and their Uses:
- **test1**: Top-level module instantiating processors and memory.
- **mips**: Sets the instruction flow, instantiating both the controller and datapath.
- **mem**: Handles memory operations (both read and write). Memory is preloaded with hexadecimal values from `memfile.dat` using the `$readmemh` system call.
- **controller**: The core of the multicycle processor, processing clock, reset, and compare signals, and controlling the PC and memory operations.
- **maindec**: Sets all the finite state machine (FSM) states and control signals.
- **aludec**: Maps opcodes to ALU operations (addition, NAND, comparison, etc.).
- **datapath**: Fetches and decodes instructions, interacts with registers and memory, and updates the PC.
- **regfile**: A register file containing 8 registers with 16-bit capacity.
- **sl1**: Shifts 16-bit inputs for branch address calculation.
- **flopenr, flopr**: Flip-flops that handle state updates based on clock and reset signals.
- **signext**: Extends the input to 16 bits by replicating the most significant bit (MSB).
- **mux2, mux3, mux4**: 2x1, 3x1, and 4x1 multiplexors, respectively.
- **carry_generate**: Calculates the carry bit for ALU operations.
- **alu**: Performs ALU operations such as addition, NAND, and comparison.

## Processor States and Descriptions:
The processor operates through the following states, each handling a specific task in the instruction execution cycle:

| **State** | **Code** | **Description** |
| --------- | -------- | --------------- |
| FETCH     | 00000    | Fetch the instruction from memory. |
| DECODE    | 00001    | Decode the fetched instruction. |
| MEMADR    | 00010    | Calculate the memory address for load/store instructions. |
| MEMRD     | 00011    | Read data from memory for load instruction. |
| MEMWR     | 00100    | Write data to memory for store instruction. |
| EXECUTE   | 00101    | Perform ALU operations (Addition, NAND, etc.). |
| ALUWRITEBACK | 00110 | Write the result of the ALU operation to a register. |
| BRANCH    | 00111    | Compute the target address for a branch and update the PC. |
| JALRW     | 01000    | Store the return address of JAL. |
| JALPC     | 01001    | Update the PC to the target address. |

## Instruction Flow for Different Operations:

### **ADD**:
1. Instruction gets stored in the Instruction Register (IR).
2. Values of the registers are read into `A` and `B`.
3. The sum is written into the destination register (`Rc`).
4. The PC is incremented and stored for the next cycle.

### **ADC** (Add with Carry):
1. Instruction gets stored in IR.
2. Registers are read into `A` and `B`.
3. Carry and zero flags are used to store the sum into `Rc`.
4. PC is incremented for the next cycle.

### **NAND**:
1. Instruction gets stored in IR.
2. Registers are read into `A` and `B` for NAND.
3. NAND result is written into `Rc`.
4. PC is incremented for the next cycle.

### **LW** (Load Word):
1. Instruction gets stored in IR.
2. The memory address is calculated, and data is read from memory.
3. The result is stored in the register file.
4. PC is incremented.

### **SW** (Store Word):
1. Instruction gets stored in IR.
2. Memory address is calculated, and data is written to memory.
3. PC is incremented.

### **BEQ** (Branch on Equal):
1. Registers are compared, and if equal, the PC is updated with the branch target address.

### **JAL** (Jump and Link):
1. PC is stored in a register, and the PC is updated with the jump target address.

## How to Run

1. Clone the repository and set up the environment.
2. Load the required memory files (`memfile.dat`) and ensure that all modules are properly instantiated.
3. Simulate the processor using a hardware description language simulator (e.g., Verilog).

## Contributors
- Arun Natarajan
- Naila Fathima

