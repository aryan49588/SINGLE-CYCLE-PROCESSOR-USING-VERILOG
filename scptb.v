module testbench;
    reg clk;
    reg reset;
    reg [31:0] instruction;
    wire [31:0] result;
    wire zero;

    single_cycle_processor uut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .result(result),
        .zero(zero)
    );

    initial begin
        clk = 0;
        reset = 0;
        instruction = 32'b0;
        
        #5;
        reset = 1;
        #5;
        reset = 0;
		  instruction = 32'b00000001010010100100000000100000; 
		  #10;
		  
        #10;
		  instruction = 32'b10001101010010100000000000000100; 
		  
        #10;
		  instruction = 32'b10101101010010100000000000001000; 
		  
        #10;
		  instruction = 32'b00010001010010100000000000000010; 
		  
        #10;
		  

        instruction = 32'b10001101101011000000000000000100; 
		  
        #10;
		  
        instruction = 32'b00001000000000000000000000000100; 
        #10;
		  
        instruction = 32'b10001101101011000000000000000100; 
        #10;
		  
        instruction = 32'b10001101101011000000000000000100; 
        #10;
		  
        instruction = 32'b00000001101011000000000000000100; 
        #10;
		  
		  instruction = 32'b00000001010010100100000000100000; 
		  #10;
		  instruction = 32'b00000001010010100100000000100000; 
		  #10;
		  instruction = 32'b00000001010010100100000000100000; 
		  #10;
        
        
        $finish;
    end

    always #5 clk = ~clk;
endmodule
