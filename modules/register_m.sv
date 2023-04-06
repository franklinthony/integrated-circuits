module register_m #(parameter WIDTH = 8) (rst_, d, enb, clk, q);
  
  /* Declarando entradas, saídas e tipos */
  input logic rst_;
  input logic enb, clk;
  input logic [WIDTH-1:0] d;
  output logic [WIDTH-1:0] q;
  
  /* Setando os parâmetros para o comportamento da onda */
  timeunit 1ns;
  timeprecision 1ps;
  
  /* Lógica */
  always_ff @ (posedge clk or negedge rst_)
    begin
      if (rst_ == 0)
  		q = 1'd0;	
   	  else if (enb == 1)
        q = d;
      else
        q = q;
  	end 
  
endmodule
