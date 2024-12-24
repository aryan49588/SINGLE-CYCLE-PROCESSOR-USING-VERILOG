module tb_controller;

    reg clk;
    reg reset;
    reg [5:0] opcode;
    wire mem_read;
    wire mem_write;
    wire reg_write;
    wire alu_src;
    wire mem_to_reg;
    wire branch;
    wire jump;
    wire [1:0] alu_op;

    controller uut (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        reset = 0;
        opcode = 6'b000000;
        reset = 1;
        #10;
        reset = 0;
        #10;
        opcode = 6'b000000;
        #10;
        opcode = 6'b100011;
        #10;
        opcode = 6'b101011;
        #10;
        opcode = 6'b000100;
        #10;
        opcode = 6'b000010;
        #10;
        $finish;
    end

endmodule
