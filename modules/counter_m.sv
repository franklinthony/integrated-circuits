module counter_m #(parameter WIDTH = 5) (data, load, rst_, clk, count);
  
  /* Declarando entradas, saidas e tipos */
  input logic rst_, clk, load;
  input logic [WIDTH-1:0] data;
  output logic [WIDTH-1:0] count;
  
  /* Setando os parametros para o comportamento da onda */
  timeunit 1ns;
  timeprecision 1ps;
  
  /* Variável interna para controle da contagem */
  reg [WIDTH-1:0] cont;
  
  /* Logica do contador*/
  always_ff @ (posedge clk or negedge rst_)
    begin
      priority if (rst_ == 0)
        begin 
          cont = {WIDTH{1'b0}};
        end 
      else if (load == 1)
        begin
          cont = data;
        end 
      else
        begin
          cont = cont + 1;
        end
    end
      
  /* Logica da saida do contador */
  always_comb 
    begin
      count = cont;
    end

endmodule

