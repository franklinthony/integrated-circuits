`ifdef EX_TYPE_PKG
  import ex_type_pkg::* ;
`else
  `ifndef EX_TYPE_DEFINED
    `define EX_TYPE_DEFINED
    `include "ex_type.svh"
  `endif
`endif

module control_m
(
  output logic    load_ac , // control load accumulator
  output logic    mem_rd  , // control memory read (asynch)
  output logic    mem_wr  , // control memory write (synch pos)
  output logic    inc_pc  , // control increment program counter
  output logic    load_pc , // control load program counter
  output logic    load_ir , // control load instruction register
  output logic    halt    , // control CPU halt
  input  opcode_e opcode  , // operation (enumerated)
  input  logic    zero    , // accumulator value is 0
  input  logic    rst_    , // reset (asynch low)
  input  logic    clk     , // clock
  input  logic    clk2    , // clock/2
  input  logic    fetch     // clock/4
) ;

  timeunit        1ns ;
  timeprecision 100ps ;

  //////////////////////////////////////////////////////////////
  // TO DO - DECLARE phase OF AN ENUMERATED LOGIC VECTOR TYPE //
  //////////////////////////////////////////////////////////////
  //enum logic [2:0] 
  typedef enum logic [2:0] {INST_ADDR, INST_FECTH, INST_LOAD,
                           IDLE, OP_ADDR, OP_FETCH, OPERATE,
                           STORE} phase_e;
  
  phase_e phase;

  always @(clk or negedge rst_) // This process violates 1364.1
    if ( rst_ == 0 )
      phase <= INST_ADDR ;
    else if ( clk2 && fetch || phase != INST_ADDR )
      // TO DO - REPLACE INCREMENT WITH AN ENUMERATION METHOD
      phase <= phase + 1;

  ////////////////////////////////////////////////////////////////
  // TO DO -DEFINE A COMBINATIONAL BLOCK GENERATING THE OUTPUTS //
  ////////////////////////////////////////////////////////////////
  always_comb
    begin
      logic ALU_OP, HLT_OP, SKZ_OP, JMP_OP, STO_OP ;
      ALU_OP = opcode == ADD || opcode == AND
            || opcode == XOR || opcode == LDA ;
      HLT_OP = opcode == HLT ;
      SKZ_OP = opcode == SKZ ;
      JMP_OP = opcode == JMP ;
      STO_OP = opcode == STO ;
      load_ac  = 0 ;
      mem_rd   = 0 ;
      mem_wr   = 0 ;
      inc_pc   = 0 ;
      load_pc  = 0 ;
      load_ir  = 0 ;
      halt     = 0 ;
      unique case (phase)
        INST_ADDR: begin
          load_ac = 0;
          mem_rd = 0;
          mem_wr = 0;
          inc_pc = 0;
          load_pc = 0;
          load_ir = 0;
          halt = 0;
        end 
        INST_FECTH: begin 
          load_ac = 0;
          mem_rd = 1;
          mem_wr = 0;
          inc_pc = 0;
          load_pc = 0;
          load_ir = 0;
          halt = 0;
        end
        INST_LOAD: begin 
          load_ac = 0;
          mem_rd = 1;
          mem_wr = 0;
          inc_pc = 0;
          load_pc = 0;
          load_ir = 1;
          halt = 0;
        end
        IDLE: begin
          load_ac = 0;
          mem_rd = 1;
          mem_wr = 0;
          inc_pc = 0;
          load_pc = 0;
          load_ir = 1;
          halt = 0;
        end
        OP_ADDR: begin
          load_ac = 0;
          mem_rd = 0;
          mem_wr = 0;
          inc_pc = 1;
          load_pc = 0;
          load_ir = 0;
          halt = HLT_OP;
        end 
        OP_FETCH: begin  
          load_ac = 0;
          mem_rd = ALU_OP;
          mem_wr = 0;
          inc_pc = 0;
          load_pc = 0;
          load_ir = 0;
          halt = 0;
        end 
        OPERATE: begin  
          load_ac = ALU_OP;
          mem_rd = ALU_OP;
          mem_wr = 0;
          inc_pc = SKZ_OP && zero;
          load_pc = JMP_OP;
          load_ir = 0;
          halt = 0;
        end 
        STORE: begin
          load_ac = ALU_OP;
          mem_rd = ALU_OP;
          mem_wr = STO_OP;
          inc_pc = JMP_OP || (SKZ_OP && zero);
          load_pc = JMP_OP;
          load_ir = 0;
          halt = 0;
        end 
      endcase
    end

endmodule : control_m

