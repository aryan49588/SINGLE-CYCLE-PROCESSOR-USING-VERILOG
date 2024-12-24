module controller_tb;
    // Inputs
    reg [6:0] op;
    reg [2:0] funct3;
    reg funct7b5;
    reg Zero;

    // Outputs
    wire [1:0] ResultSrc;
    wire MemWrite;
    wire PCSrc;
    wire ALUSrc;
    wire RegWrite;
    wire Jump;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;

    // Instantiate the controller module
    controller uut (
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .Zero(Zero),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );

    // Testbench logic
    initial begin
        $monitor("op=%b funct3=%b funct7b5=%b Zero=%b | ResultSrc=%b MemWrite=%b PCSrc=%b ALUSrc=%b RegWrite=%b Jump=%b ImmSrc=%b ALUControl=%b",
            op, funct3, funct7b5, Zero, ResultSrc, MemWrite, PCSrc, ALUSrc, RegWrite, Jump, ImmSrc, ALUControl);

        
        op = 7'b0110011; funct3 = 3'b000; funct7b5 = 1'b0; Zero = 1'b0; #10;

        
        op = 7'b0000011; funct3 = 3'b010; funct7b5 = 1'b0; Zero = 1'b0; #10;

        
        op = 7'b0100011; funct3 = 3'b010; funct7b5 = 1'b0; Zero = 1'b0; #10;

        
        op = 7'b1100011; funct3 = 3'b000; funct7b5 = 1'b0; Zero = 1'b1; #10;

        
        op = 7'b0010011; funct3 = 3'b000; funct7b5 = 1'b0; Zero = 1'b0; #10;

        op = 7'b1101111; funct3 = 3'b000; funct7b5 = 1'b0; Zero = 1'b0; #10;

        op = 7'b1111111; funct3 = 3'b111; funct7b5 = 1'b1; Zero = 1'b0; #10;

        $stop;
    end
endmodule
