module memory_m #(parameter DWIDTH = 8, AWIDTH = 5) (addr, read, write, data);
  
  /* Declarando entradas, saidas e tipos */
  input logic [AWIDTH-1:0] addr;
  input logic read, write;
  inout logic [DWIDTH-1:0] data;
  
  /* Declaracao do vetor de memoria */
  logic [DWIDTH-1:0] mem [(2**AWIDTH)-1:0];
  
  /* Setando os parametros para o comportamento da onda */
  timeunit 1ns;
  timeprecision 1ps;
  
  /* Processo de escrita na memoria */
  always_ff @ (posedge write)
    begin
      if (!read) // Verificando se o sinal read está desativado
        mem[addr] = data;
    end

  /* Processo de leitura na memoria */
  /* Caso haja processo de escrita,
  	'data' recebe 'don't care' */
  assign data = (read && !write) ? mem[addr] : {DWIDTH{1'bz}};

endmodule

