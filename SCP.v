module controller(
    input clk,           // Clock signal
    input reset,         // Reset signal
    input [5:0] opcode,  // 6-bit opcode from instruction
    output reg mem_read, // Memory read signal
    output reg mem_write, // Memory write signal
    output reg reg_write, // Register write signal
    output reg alu_src,   // ALU source signal
    output reg mem_to_reg, // Memory to register signal
    output reg branch,    // Branch signal
    output reg jump,      // Jump signal
    output reg [1:0] alu_op // ALU operation
);

    // State Encoding for FSM (if required)
    // Not needed in this simple example as it's a combinational process

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all control signals
            mem_read <= 0;
            mem_write <= 0;
            reg_write <= 0;
            alu_src <= 0;
            mem_to_reg <= 0;
            branch <= 0;
            jump <= 0;
            alu_op <= 2'b00;
        end else begin
            case (opcode)
                6'b000000: begin  // R-type instruction (add, sub, etc.)
                    mem_read <= 0;
                    mem_write <= 0;
                    reg_write <= 1;
                    alu_src <= 0;
                    mem_to_reg <= 0;
                    branch <= 0;
                    jump <= 0;
                    alu_op <= 2'b10; 
                end

                6'b100011: begin  // LW (load word)
                    mem_read <= 1;
                    mem_write <= 0;
                    reg_write <= 1;
                    alu_src <= 1;  
                    mem_to_reg <= 1; 
                    branch <= 0;
                    jump <= 0;
                    alu_op <= 2'b00; 
                end

                6'b101011: begin  // SW (store word)
                    mem_read <= 0;
                    mem_write <= 1;
                    reg_write <= 0;
                    alu_src <= 1;
                    mem_to_reg <= 0;
                    branch <= 0;
                    jump <= 0;
                    alu_op <= 2'b00; 
                end

                6'b000100: begin  
                    mem_read <= 0;
                    mem_write <= 0;
                    reg_write <= 0;
                    alu_src <= 0;
                    mem_to_reg <= 0;
                    branch <= 1;  
                    jump <= 0;
                    alu_op <= 2'b01; 
                end

                6'b000010: begin  // JUMP
                    mem_read <= 0;
                    mem_write <= 0;
                    reg_write <= 0;
                    alu_src <= 0;
                    mem_to_reg <= 0;
                    branch <= 0;
                    jump <= 1; 
                    alu_op <= 2'b00; 
                end

                default: begin
                    mem_read <= 0;
                    mem_write <= 0;
                    reg_write <= 0;
                    alu_src <= 0;
                    mem_to_reg <= 0;
                    branch <= 0;
                    jump <= 0;
                    alu_op <= 2'b00;
                end
            endcase
        end
    end
endmodule


module datapath (
    input clk, reset,
    input mem_read, mem_write, reg_write, alu_src, mem_to_reg, branch, jump,
    input [1:0] alu_op,
    input [31:0] instruction, // 32-bit instruction input
    output [31:0] result, // Final result
    output zero // Zero flag from ALU
);
    wire [5:0] opcode = instruction[31:26];
    wire [5:0] rs = instruction[25:21], rt = instruction[20:16], rd = instruction[15:11];
    wire [15:0] imm = instruction[15:0];
    wire [31:0] reg_data1, reg_data2, alu_result, memory_data, reg_write_data;

    // Register File (32 registers)
    reg [31:0] registers [31:0];
    assign reg_data1 = registers[rs];
    assign reg_data2 = registers[rt];

    // ALU
    alu alu_unit (
        .A(reg_data1),
        .B(alu_src ? imm : reg_data2),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(zero)
    );

    // Data Memory (256 words of 32-bit data)
    reg [31:0] data_memory [255:0];
    assign memory_data = data_memory[alu_result[7:0]];

    // Write-back Logic: ALU or Memory to Register
    assign reg_write_data = mem_to_reg ? memory_data : alu_result;

    // Declare an integer outside of always block
    integer i;

    // Register Write and Memory Write Operations
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers to 0
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0;  // Reset all registers
            end
        end else begin
            // Register write-back from ALU or memory
            if (reg_write) begin
                if (opcode == 6'b000000) begin  // R-type instructions
                    registers[rd] <= reg_write_data;
                end else if (opcode == 6'b100011) begin  // LW instruction
                    registers[rt] <= reg_write_data;
                end
            end
            // Memory write (only for SW instruction)
            if (mem_write) begin
                data_memory[alu_result[7:0]] <= reg_data2;
            end
        end
    end

    assign result = reg_write_data;  // Final output from ALU or memory

endmodule

module alu (
    input [31:0] A, B,
    input [1:0] alu_op,
    output reg [31:0] result,
    output reg zero
);
    always @(*) begin
        case (alu_op)
            2'b00: result = A + B; // ADD
            2'b01: result = A - B; // SUB
            2'b10: result = A & B; // AND
            2'b11: result = A | B; // OR
            default: result = 32'b0; // Default
        endcase
        zero = (result == 0); // Zero flag
    end
endmodule


module single_cycle_processor (
    input clk, reset,
    input [31:0] instruction, // Instruction input
    output [31:0] result, // Result of computation
    output zero // Zero flag from ALU
);
    // Control Signals
    wire mem_read, mem_write, reg_write, alu_src, mem_to_reg, branch, jump;
    wire [1:0] alu_op;

    // Instantiate Controller
    controller ctrl (
        .clk(clk),
        .reset(reset),
        .opcode(instruction[31:26]),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    // Instantiate Datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op),
        .instruction(instruction),
        .result(result),
        .zero(zero)
    );
endmodule
     
     