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
