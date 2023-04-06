module mux_m #(parameter WIDTH = 8) (data_a, data_b, sel_a, out);
  
  /* Declarando entradas, saídas e tipos */
  input logic [WIDTH-1:0] data_a, data_b;
  input logic sel_a;
  output logic [WIDTH-1:0] out;
  
  /* Setando os parâmetros para o comportamento da onda */
  timeunit 1ns;
  timeprecision 1ps;
  
  /* Lógica */
  always_comb
    begin
      unique case (sel_a)
        0: out = data_b;
        1: out = data_a;
        default: out = out;
      endcase
  	end 
  
endmodule

