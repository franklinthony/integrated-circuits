module alu_m #(parameter WIDTH = 8) (accum, data, opcode, clk, out, zero);
  
  /* Criando o tipo enum para o opcode */
  typedef enum logic [2:0] {
    HLT = 3'b000,
    SKZ = 3'b001,
    ADD = 3'b010,
   	AND = 3'b011,
    XOR = 3'b100,
    LDA = 3'b101,
    STO = 3'b110,
    JMP = 3'b111
  } opcode_e;
  
  /* Declarando entradas, saidas e tipos */
  input logic [WIDTH-1:0] accum, data;
  input logic clk;
  input opcode_e opcode;
  output logic [WIDTH-1:0]out;
  output logic zero;
  
  /* Setando os parametros para o comportamento da onda */
  timeunit 1ns;
  timeprecision 1ps;
  
  /* Gerando os resultados da ULA */
  always_ff @ (negedge clk)
    begin
      unique case (opcode)
        HLT: out = accum;
        SKZ: out = accum;
    	ADD: out = data + accum;
        AND: out = data & accum;
        XOR: out = data ^ accum;
        LDA: out = data;
        STO: out = accum;
        JMP: out = accum;
        default: out = out;
      endcase
    end
  
  /* Condicionais para o zero */
  always_comb
    begin
      if (accum == 0)
        begin
          zero = 1'b1;
        end 
      else 
        begin
          zero = 1'b0;
        end
    end
  
endmodule

