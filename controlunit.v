module maindec(input [6:0]op,
output [1:0]ResultSrc,
output MemWrite,
output Branch,ALUSrc,
output RegWrite,Jump,
output [1:0]ImmSrc,
output [1:0]ALUop
);
reg[10:0] controls;
assign{RegWrite, ImmSrc, ALUSrc, MemWrite,ResultSrc, Branch, ALUOp, Jump}=controls;
always @* begin
   case(op)
    7'b0000011:controls=11'b10010010000;
    7'b0100011:controls=11'b00111000000;
    7'b0110011:controls=11'b1xx00000100;
    7'b1100011:controls=11'b01000001010;
    7'b0010011:controls=11'b10010000100;
    7'b1101111:controls=11'b11100100001;
    default:controls=11'bxxxxxxxxxxx;
	endcase
end
  
endmodule
