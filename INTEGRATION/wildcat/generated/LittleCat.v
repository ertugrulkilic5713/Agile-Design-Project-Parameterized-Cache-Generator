module Csr(
  input  [11:0] io_address, // @[src/main/scala/wildcat/pipeline/Csr.scala 14:14]
  output [31:0] io_data // @[src/main/scala/wildcat/pipeline/Csr.scala 14:14]
);
  wire [31:0] _GEN_0 = 12'hf12 == io_address ? 32'h2f : 32'h0; // @[src/main/scala/wildcat/pipeline/Csr.scala 22:22 48:12 19:25]
  wire [31:0] _GEN_1 = 12'hb81 == io_address ? 32'h0 : _GEN_0; // @[src/main/scala/wildcat/pipeline/Csr.scala 22:22 45:12]
  wire [31:0] _GEN_2 = 12'hb01 == io_address ? 32'h0 : _GEN_1; // @[src/main/scala/wildcat/pipeline/Csr.scala 22:22 42:12]
  wire [31:0] _GEN_3 = 12'hb80 == io_address ? 32'h0 : _GEN_2; // @[src/main/scala/wildcat/pipeline/Csr.scala 22:22 39:12]
  wire [31:0] _GEN_4 = 12'hb00 == io_address ? 32'h0 : _GEN_3; // @[src/main/scala/wildcat/pipeline/Csr.scala 22:22 36:12]
  wire [31:0] _GEN_5 = 12'hc81 == io_address ? 32'h4 : _GEN_4; // @[src/main/scala/wildcat/pipeline/Csr.scala 22:22 33:12]
  wire [31:0] _GEN_6 = 12'hc01 == io_address ? 32'h3 : _GEN_5; // @[src/main/scala/wildcat/pipeline/Csr.scala 22:22 30:12]
  wire [31:0] _GEN_7 = 12'hc80 == io_address ? 32'h2 : _GEN_6; // @[src/main/scala/wildcat/pipeline/Csr.scala 22:22 27:12]
  assign io_data = 12'hc00 == io_address ? 32'h1 : _GEN_7; // @[src/main/scala/wildcat/pipeline/Csr.scala 22:22 24:12]
endmodule
module ThreeCats(
  input         clock,
  input         reset,
  output [31:0] io_imem_address, // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  input  [31:0] io_imem_rdData, // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  input         io_imem_ack, // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output [31:0] io_dmem_address, // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output        io_dmem_rd, // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output        io_dmem_wr, // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  input  [31:0] io_dmem_rdData, // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output [31:0] io_dmem_wrData, // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output [3:0]  io_dmem_wrMask, // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  input         io_dmem_ack // @[src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regs [0:31]; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire  regs_rs1Val_MPORT_en; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [4:0] regs_rs1Val_MPORT_addr; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [31:0] regs_rs1Val_MPORT_data; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire  regs_rs2Val_MPORT_en; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [4:0] regs_rs2Val_MPORT_addr; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [31:0] regs_rs2Val_MPORT_data; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [31:0] regs_MPORT_data; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [4:0] regs_MPORT_addr; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire  regs_MPORT_mask; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire  regs_MPORT_en; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  reg  regs_rs1Val_MPORT_en_pipe_0;
  reg [4:0] regs_rs1Val_MPORT_addr_pipe_0;
  reg  regs_rs2Val_MPORT_en_pipe_0;
  reg [4:0] regs_rs2Val_MPORT_addr_pipe_0;
  wire [11:0] csr_io_address; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 86:19]
  wire [31:0] csr_io_data; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 86:19]
  reg  exFwdReg_valid; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
  reg [4:0] exFwdReg_wbDest; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
  reg [31:0] exFwdReg_wbData; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
  reg [31:0] pcReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 39:22]
  wire [31:0] _pcNext_T_1 = pcReg + 32'h4; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 40:62]
  reg [2:0] decExReg_func3; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire  _doBranch_T = 3'h0 == decExReg_func3; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20]
  reg [4:0] decExReg_rs1; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg [31:0] decExReg_rs1Val; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire [31:0] v1 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs1 ? exFwdReg_wbData : decExReg_rs1Val; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 142:15]
  reg [4:0] decExReg_rs2; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg [31:0] decExReg_rs2Val; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire [31:0] v2 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs2 ? exFwdReg_wbData : decExReg_rs2Val; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 143:15]
  wire  _doBranch_T_1 = 3'h1 == decExReg_func3; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20]
  wire  _doBranch_T_2 = 3'h4 == decExReg_func3; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20]
  wire [31:0] _doBranch_res_T_2 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs1 ? exFwdReg_wbData : decExReg_rs1Val; // @[src/main/scala/wildcat/pipeline/Functions.scala 163:20]
  wire [31:0] _doBranch_res_T_3 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs2 ? exFwdReg_wbData : decExReg_rs2Val; // @[src/main/scala/wildcat/pipeline/Functions.scala 163:33]
  wire  _doBranch_T_3 = 3'h5 == decExReg_func3; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20]
  wire  _GEN_281 = 3'h7 == decExReg_func3 & v1 >= v2; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20 172:13 154:9]
  wire  _GEN_282 = 3'h6 == decExReg_func3 ? v1 < v2 : _GEN_281; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20 169:13]
  wire  _GEN_283 = 3'h5 == decExReg_func3 ? $signed(_doBranch_res_T_2) >= $signed(_doBranch_res_T_3) : _GEN_282; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20 166:13]
  wire  _GEN_284 = 3'h4 == decExReg_func3 ? $signed(_doBranch_res_T_2) < $signed(_doBranch_res_T_3) : _GEN_283; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20 163:13]
  wire  _GEN_285 = 3'h1 == decExReg_func3 ? v1 != v2 : _GEN_284; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20 160:13]
  wire  doBranch_res = 3'h0 == decExReg_func3 ? v1 == v2 : _GEN_285; // @[src/main/scala/wildcat/pipeline/Functions.scala 155:20 157:13]
  reg  decExReg_decOut_isBranch; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg  decExReg_decOut_isJal; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg  decExReg_decOut_isJalr; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg  decExReg_valid; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire  doBranch = (doBranch_res & decExReg_decOut_isBranch | decExReg_decOut_isJal | decExReg_decOut_isJalr) &
    decExReg_valid; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 168:130]
  reg  decExReg_decOut_isLoad; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg  decExReg_decOut_isStore; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire  _dmemAccess_T_2 = ~doBranch; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 169:93]
  wire  dmemAccess = decExReg_valid & (decExReg_decOut_isLoad | decExReg_decOut_isStore) & ~doBranch; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 169:90]
  reg  dmemStartedReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 170:31]
  wire  dmemDone = dmemAccess & dmemStartedReg & io_dmem_ack; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 171:47]
  reg [1:0] decExReg_memLow; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire  _res_T_7 = 2'h0 == decExReg_memLow; // @[src/main/scala/wildcat/pipeline/Functions.scala 288:24]
  wire [23:0] _res_res_T_1 = io_dmem_rdData[7] ? 24'hffffff : 24'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 290:24]
  wire [31:0] _res_res_T_3 = {_res_res_T_1,io_dmem_rdData[7:0]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 290:38]
  wire  _res_T_8 = 2'h1 == decExReg_memLow; // @[src/main/scala/wildcat/pipeline/Functions.scala 288:24]
  wire [23:0] _res_res_T_5 = io_dmem_rdData[15] ? 24'hffffff : 24'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 293:24]
  wire [31:0] _res_res_T_7 = {_res_res_T_5,io_dmem_rdData[15:8]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 293:39]
  wire  _res_T_9 = 2'h2 == decExReg_memLow; // @[src/main/scala/wildcat/pipeline/Functions.scala 288:24]
  wire [23:0] _res_res_T_9 = io_dmem_rdData[23] ? 24'hffffff : 24'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 296:24]
  wire [31:0] _res_res_T_11 = {_res_res_T_9,io_dmem_rdData[23:16]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 296:39]
  wire  _res_T_10 = 2'h3 == decExReg_memLow; // @[src/main/scala/wildcat/pipeline/Functions.scala 288:24]
  wire [23:0] _res_res_T_13 = io_dmem_rdData[31] ? 24'hffffff : 24'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 300:24]
  wire [31:0] _res_res_T_15 = {_res_res_T_13,io_dmem_rdData[31:24]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 300:39]
  wire [31:0] _GEN_289 = 2'h3 == decExReg_memLow ? _res_res_T_15 : io_dmem_rdData; // @[src/main/scala/wildcat/pipeline/Functions.scala 288:24 300:17 285:9]
  wire [31:0] _GEN_290 = 2'h2 == decExReg_memLow ? _res_res_T_11 : _GEN_289; // @[src/main/scala/wildcat/pipeline/Functions.scala 288:24 296:17]
  wire [31:0] _GEN_291 = 2'h1 == decExReg_memLow ? _res_res_T_7 : _GEN_290; // @[src/main/scala/wildcat/pipeline/Functions.scala 288:24 293:17]
  wire [31:0] _GEN_292 = 2'h0 == decExReg_memLow ? _res_res_T_3 : _GEN_291; // @[src/main/scala/wildcat/pipeline/Functions.scala 288:24 290:17]
  wire [15:0] _res_res_T_17 = io_dmem_rdData[15] ? 16'hffff : 16'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 307:24]
  wire [31:0] _res_res_T_19 = {_res_res_T_17,io_dmem_rdData[15:0]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 307:39]
  wire [15:0] _res_res_T_21 = io_dmem_rdData[31] ? 16'hffff : 16'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 310:24]
  wire [31:0] _res_res_T_23 = {_res_res_T_21,io_dmem_rdData[31:16]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 310:39]
  wire [31:0] _GEN_293 = _res_T_9 ? _res_res_T_23 : io_dmem_rdData; // @[src/main/scala/wildcat/pipeline/Functions.scala 305:24 310:17 285:9]
  wire [31:0] _GEN_294 = _res_T_7 ? _res_res_T_19 : _GEN_293; // @[src/main/scala/wildcat/pipeline/Functions.scala 305:24 307:17]
  wire [31:0] _GEN_295 = _res_T_10 ? {{24'd0}, io_dmem_rdData[31:24]} : io_dmem_rdData; // @[src/main/scala/wildcat/pipeline/Functions.scala 315:24 326:17 285:9]
  wire [31:0] _GEN_296 = _res_T_9 ? {{24'd0}, io_dmem_rdData[23:16]} : _GEN_295; // @[src/main/scala/wildcat/pipeline/Functions.scala 315:24 323:17]
  wire [31:0] _GEN_297 = _res_T_8 ? {{24'd0}, io_dmem_rdData[15:8]} : _GEN_296; // @[src/main/scala/wildcat/pipeline/Functions.scala 315:24 320:17]
  wire [31:0] _GEN_298 = _res_T_7 ? {{24'd0}, io_dmem_rdData[7:0]} : _GEN_297; // @[src/main/scala/wildcat/pipeline/Functions.scala 315:24 317:17]
  wire [31:0] _GEN_299 = _res_T_9 ? {{16'd0}, io_dmem_rdData[31:16]} : io_dmem_rdData; // @[src/main/scala/wildcat/pipeline/Functions.scala 331:24 336:17 285:9]
  wire [31:0] _GEN_300 = _res_T_7 ? {{16'd0}, io_dmem_rdData[15:0]} : _GEN_299; // @[src/main/scala/wildcat/pipeline/Functions.scala 331:24 333:17]
  wire [31:0] _GEN_301 = _doBranch_T_3 ? _GEN_300 : io_dmem_rdData; // @[src/main/scala/wildcat/pipeline/Functions.scala 286:19 285:9]
  wire [31:0] _GEN_302 = _doBranch_T_2 ? _GEN_298 : _GEN_301; // @[src/main/scala/wildcat/pipeline/Functions.scala 286:19]
  wire [31:0] _GEN_303 = _doBranch_T_1 ? _GEN_294 : _GEN_302; // @[src/main/scala/wildcat/pipeline/Functions.scala 286:19]
  wire [31:0] res_res_1 = _doBranch_T ? _GEN_292 : _GEN_303; // @[src/main/scala/wildcat/pipeline/Functions.scala 286:19]
  reg  decExReg_decOut_isCssrw; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg [31:0] decExReg_csrVal; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg  decExReg_decOut_isAuiPc; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg [31:0] decExReg_pc; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg [31:0] decExReg_decOut_imm; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire [31:0] _res_T_5 = $signed(decExReg_pc) + $signed(decExReg_decOut_imm); // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 152:55]
  reg  decExReg_decOut_isLui; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg [3:0] decExReg_decOut_aluOp; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg  decExReg_decOut_isImm; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire [31:0] val2 = decExReg_decOut_isImm ? decExReg_decOut_imm : v2; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 146:17]
  wire [31:0] res_res__9 = v1 & val2; // @[src/main/scala/wildcat/pipeline/Functions.scala 271:24]
  wire [31:0] res_res__8 = v1 | val2; // @[src/main/scala/wildcat/pipeline/Functions.scala 272:23]
  wire [31:0] res_res__7 = $signed(_doBranch_res_T_2) >>> val2[4:0]; // @[src/main/scala/wildcat/pipeline/Functions.scala 276:44]
  wire [31:0] res_res__6 = v1 >> val2[4:0]; // @[src/main/scala/wildcat/pipeline/Functions.scala 275:24]
  wire [31:0] res_res__5 = v1 ^ val2; // @[src/main/scala/wildcat/pipeline/Functions.scala 273:24]
  wire [31:0] res_res__4 = {{31'd0}, v1 < val2}; // @[src/main/scala/wildcat/pipeline/Functions.scala 268:19 278:20]
  wire [31:0] _res_res_3_T_1 = decExReg_decOut_isImm ? decExReg_decOut_imm : v2; // @[src/main/scala/wildcat/pipeline/Functions.scala 277:36]
  wire [31:0] res_res__3 = {{31'd0}, $signed(_doBranch_res_T_2) < $signed(_res_res_3_T_1)}; // @[src/main/scala/wildcat/pipeline/Functions.scala 268:19 277:19]
  wire [62:0] _GEN_2 = {{31'd0}, v1}; // @[src/main/scala/wildcat/pipeline/Functions.scala 274:25]
  wire [62:0] _res_res_2_T_1 = _GEN_2 << val2[4:0]; // @[src/main/scala/wildcat/pipeline/Functions.scala 274:25]
  wire [31:0] res_res__2 = _res_res_2_T_1[31:0]; // @[src/main/scala/wildcat/pipeline/Functions.scala 274:36]
  wire [31:0] res_res__1 = v1 - val2; // @[src/main/scala/wildcat/pipeline/Functions.scala 270:24]
  wire [31:0] res_res__0 = v1 + val2; // @[src/main/scala/wildcat/pipeline/Functions.scala 269:24]
  wire [31:0] _GEN_267 = 4'h1 == decExReg_decOut_aluOp ? res_res__1 : res_res__0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 147:{7,7}]
  wire [31:0] _GEN_268 = 4'h2 == decExReg_decOut_aluOp ? res_res__2 : _GEN_267; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 147:{7,7}]
  wire [31:0] _GEN_269 = 4'h3 == decExReg_decOut_aluOp ? res_res__3 : _GEN_268; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 147:{7,7}]
  wire [31:0] _GEN_270 = 4'h4 == decExReg_decOut_aluOp ? res_res__4 : _GEN_269; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 147:{7,7}]
  wire [31:0] _GEN_271 = 4'h5 == decExReg_decOut_aluOp ? res_res__5 : _GEN_270; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 147:{7,7}]
  wire [31:0] _GEN_272 = 4'h6 == decExReg_decOut_aluOp ? res_res__6 : _GEN_271; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 147:{7,7}]
  wire [31:0] _GEN_273 = 4'h7 == decExReg_decOut_aluOp ? res_res__7 : _GEN_272; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 147:{7,7}]
  wire [31:0] _GEN_274 = 4'h8 == decExReg_decOut_aluOp ? res_res__8 : _GEN_273; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 147:{7,7}]
  wire [31:0] _GEN_275 = 4'h9 == decExReg_decOut_aluOp ? res_res__9 : _GEN_274; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 147:{7,7}]
  wire [31:0] _GEN_276 = decExReg_decOut_isLui ? decExReg_decOut_imm : _GEN_275; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 148:31 147:7 149:9]
  wire [31:0] _GEN_277 = decExReg_decOut_isAuiPc ? _res_T_5 : _GEN_276; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 151:33 152:9]
  wire [31:0] _GEN_278 = decExReg_decOut_isCssrw ? decExReg_csrVal : _GEN_277; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 154:33 155:9]
  wire [31:0] res = decExReg_decOut_isLoad & dmemDone ? res_res_1 : _GEN_278; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 189:44 190:9]
  wire [31:0] branchTarget = decExReg_decOut_isJalr ? res : _res_T_5; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 164:16 165:32 166:18]
  wire [31:0] _pcNext_T_2 = doBranch ? branchTarget : _pcNext_T_1; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 40:31]
  reg  fetchPendingReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 43:32]
  reg  fetchDiscardReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 44:32]
  wire  fetchAck = fetchPendingReg & io_imem_ack; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 45:34]
  wire  stall = dmemAccess & ~dmemDone; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 172:23]
  wire  _fetchReq_T = ~stall; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 46:18]
  wire  fetchReq = ~stall & (~fetchPendingReg | fetchAck); // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 46:25]
  wire  _fetchPendingReg_T = fetchAck ? 1'h0 : fetchPendingReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 52:47]
  wire  fetchAckValid = fetchAck & ~fetchDiscardReg & _dmemAccess_T_2; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 59:52]
  wire [31:0] _GEN_1 = _dmemAccess_T_2 ? pcReg : _pcNext_T_2; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 63:21 64:14 40:27]
  wire [31:0] instr = ~fetchAckValid ? 32'h33 : io_imem_rdData; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 61:25 62:11 60:26]
  wire [31:0] _GEN_3 = ~fetchAckValid ? _GEN_1 : _pcNext_T_2; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 61:25 40:27]
  reg [31:0] pcRegReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 72:25]
  reg [31:0] instrReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 76:25]
  wire [31:0] rfReadInstr = stall ? instrReg : instr; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 80:24]
  reg [4:0] rs1Val_REG; // @[src/main/scala/wildcat/pipeline/Functions.scala 208:31]
  wire [31:0] rs1Val = rs1Val_REG == 5'h0 ? 32'h0 : regs_rs1Val_MPORT_data; // @[src/main/scala/wildcat/pipeline/Functions.scala 208:23]
  reg [4:0] rs2Val_REG; // @[src/main/scala/wildcat/pipeline/Functions.scala 209:31]
  wire [31:0] rs2Val = rs2Val_REG == 5'h0 ? 32'h0 : regs_rs2Val_MPORT_data; // @[src/main/scala/wildcat/pipeline/Functions.scala 209:23]
  reg [4:0] decExReg_rd; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire  _T_4 = decExReg_rd != 5'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 210:24]
  reg  decExReg_decOut_rfWrite; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire  wrEna = decExReg_valid & decExReg_decOut_rfWrite & (~decExReg_decOut_isLoad | dmemDone); // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 186:54]
  wire  _T_5 = wrEna & decExReg_rd != 5'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 210:18]
  wire  _T_15 = decExReg_decOut_isJal | decExReg_decOut_isJalr; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 160:30]
  wire [31:0] _wbData_T_1 = decExReg_pc + 32'h4; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 161:27]
  wire [31:0] wbData = decExReg_decOut_isJal | decExReg_decOut_isJalr ? _wbData_T_1 : res; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 159:10 160:57 161:12]
  wire [6:0] decOut_opcode = instrReg[6:0]; // @[src/main/scala/wildcat/pipeline/Functions.scala 17:29]
  wire [2:0] decOut_func3 = instrReg[14:12]; // @[src/main/scala/wildcat/pipeline/Functions.scala 18:28]
  wire  _GEN_83 = decOut_func3 == 3'h0 ? 1'h0 : 1'h1; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20 87:30 90:26]
  wire  _GEN_92 = 7'h73 == decOut_opcode ? _GEN_83 : 7'h2f == decOut_opcode; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
  wire  _GEN_95 = 7'h67 == decOut_opcode | 7'h73 == decOut_opcode; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 80:26]
  wire  _GEN_97 = 7'h67 == decOut_opcode | _GEN_92; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 82:24]
  wire  _GEN_99 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_83; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_102 = 7'h6f == decOut_opcode ? 3'h5 : {{2'd0}, _GEN_95}; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 75:26]
  wire  _GEN_103 = 7'h6f == decOut_opcode | _GEN_97; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 76:24]
  wire  _GEN_105 = 7'h6f == decOut_opcode ? 1'h0 : 7'h67 == decOut_opcode; // @[src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_107 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_99; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_110 = 7'h17 == decOut_opcode ? 3'h4 : _GEN_102; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 70:26]
  wire  _GEN_111 = 7'h17 == decOut_opcode | _GEN_103; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 71:24]
  wire  _GEN_113 = 7'h17 == decOut_opcode ? 1'h0 : 7'h6f == decOut_opcode; // @[src/main/scala/wildcat/pipeline/Functions.scala 27:18 37:20]
  wire  _GEN_114 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_105; // @[src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_116 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_107; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_119 = 7'h37 == decOut_opcode ? 3'h4 : _GEN_110; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 65:26]
  wire  _GEN_120 = 7'h37 == decOut_opcode | _GEN_111; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 66:24]
  wire  _GEN_122 = 7'h37 == decOut_opcode ? 1'h0 : 7'h17 == decOut_opcode; // @[src/main/scala/wildcat/pipeline/Functions.scala 23:20 37:20]
  wire  _GEN_123 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_113; // @[src/main/scala/wildcat/pipeline/Functions.scala 27:18 37:20]
  wire  _GEN_124 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_114; // @[src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_126 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_116; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_129 = 7'h23 == decOut_opcode ? 3'h2 : _GEN_119; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 61:26]
  wire  _GEN_131 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_120; // @[src/main/scala/wildcat/pipeline/Functions.scala 29:20 37:20]
  wire  _GEN_132 = 7'h23 == decOut_opcode ? 1'h0 : 7'h37 == decOut_opcode; // @[src/main/scala/wildcat/pipeline/Functions.scala 22:18 37:20]
  wire  _GEN_133 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_122; // @[src/main/scala/wildcat/pipeline/Functions.scala 23:20 37:20]
  wire  _GEN_134 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_123; // @[src/main/scala/wildcat/pipeline/Functions.scala 27:18 37:20]
  wire  _GEN_135 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_124; // @[src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_137 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_126; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_140 = 7'h3 == decOut_opcode ? 3'h1 : _GEN_129; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 56:26]
  wire  _GEN_141 = 7'h3 == decOut_opcode | _GEN_131; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 57:24]
  wire  _GEN_143 = 7'h3 == decOut_opcode ? 1'h0 : 7'h23 == decOut_opcode; // @[src/main/scala/wildcat/pipeline/Functions.scala 25:20 37:20]
  wire  _GEN_144 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_132; // @[src/main/scala/wildcat/pipeline/Functions.scala 22:18 37:20]
  wire  _GEN_145 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_133; // @[src/main/scala/wildcat/pipeline/Functions.scala 23:20 37:20]
  wire  _GEN_146 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_134; // @[src/main/scala/wildcat/pipeline/Functions.scala 27:18 37:20]
  wire  _GEN_147 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_135; // @[src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_149 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_137; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_152 = 7'h63 == decOut_opcode ? 3'h3 : _GEN_140; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 51:26]
  wire  _GEN_153 = 7'h63 == decOut_opcode | _GEN_147; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 52:22]
  wire  _GEN_155 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_141; // @[src/main/scala/wildcat/pipeline/Functions.scala 29:20 37:20]
  wire  _GEN_156 = 7'h63 == decOut_opcode ? 1'h0 : 7'h3 == decOut_opcode; // @[src/main/scala/wildcat/pipeline/Functions.scala 24:19 37:20]
  wire  _GEN_157 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_143; // @[src/main/scala/wildcat/pipeline/Functions.scala 25:20 37:20]
  wire  _GEN_158 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_144; // @[src/main/scala/wildcat/pipeline/Functions.scala 22:18 37:20]
  wire  _GEN_159 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_145; // @[src/main/scala/wildcat/pipeline/Functions.scala 23:20 37:20]
  wire  _GEN_160 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_146; // @[src/main/scala/wildcat/pipeline/Functions.scala 27:18 37:20]
  wire  _GEN_161 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_147; // @[src/main/scala/wildcat/pipeline/Functions.scala 28:19 37:20]
  wire  _GEN_163 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_149; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_166 = 7'h33 == decOut_opcode ? 3'h0 : _GEN_152; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 45:26]
  wire  _GEN_167 = 7'h33 == decOut_opcode | _GEN_155; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 46:24]
  wire  _GEN_169 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_153; // @[src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_172 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_157; // @[src/main/scala/wildcat/pipeline/Functions.scala 25:20 37:20]
  wire [2:0] decOut_instrType = 7'h13 == decOut_opcode ? 3'h1 : _GEN_166; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 39:26]
  wire  decOut_isImm = 7'h13 == decOut_opcode | _GEN_169; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 40:22]
  wire  decOut_rfWrite = 7'h13 == decOut_opcode | _GEN_167; // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20 41:24]
  wire  decOut_isStore = 7'h13 == decOut_opcode ? 1'h0 : _GEN_172; // @[src/main/scala/wildcat/pipeline/Functions.scala 25:20 37:20]
  wire [6:0] decOut_decOut_aluOp_func7 = instrReg[31:25]; // @[src/main/scala/wildcat/pipeline/Functions.scala 113:28]
  wire  _decOut_decOut_aluOp_T = 3'h0 == decOut_func3; // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19]
  wire  _decOut_decOut_aluOp_T_5 = decOut_opcode != 7'h13 & decOut_opcode != 7'h67 & decOut_decOut_aluOp_func7 != 7'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 119:55]
  wire  _decOut_decOut_aluOp_T_6 = 3'h1 == decOut_func3; // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19]
  wire  _decOut_decOut_aluOp_T_7 = 3'h2 == decOut_func3; // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19]
  wire [2:0] _GEN_198 = decOut_decOut_aluOp_func7 == 7'h0 ? 3'h6 : 3'h7; // @[src/main/scala/wildcat/pipeline/Functions.scala 136:29 137:17 139:17]
  wire [3:0] _GEN_199 = 3'h7 == decOut_func3 ? 4'h9 : 4'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19 146:15 115:28]
  wire [3:0] _GEN_200 = 3'h6 == decOut_func3 ? 4'h8 : _GEN_199; // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19 143:15]
  wire [3:0] _GEN_201 = 3'h5 == decOut_func3 ? {{1'd0}, _GEN_198} : _GEN_200; // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19]
  wire [3:0] _GEN_202 = 3'h4 == decOut_func3 ? 4'h5 : _GEN_201; // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19 133:15]
  wire [3:0] _GEN_203 = 3'h3 == decOut_func3 ? 4'h4 : _GEN_202; // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19 130:15]
  wire [3:0] _GEN_204 = 3'h2 == decOut_func3 ? 4'h3 : _GEN_203; // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19 127:15]
  wire [11:0] _decOut_decOut_imm_imm_T_1 = instrReg[31:20]; // @[src/main/scala/wildcat/pipeline/Functions.scala 181:32]
  wire [19:0] _decOut_decOut_imm_imm_T_3 = instrReg[31] ? 20'hfffff : 20'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 184:21]
  wire [31:0] _decOut_decOut_imm_imm_T_6 = {_decOut_decOut_imm_imm_T_3,instrReg[31:20]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 184:67]
  wire [31:0] _decOut_decOut_imm_imm_T_13 = {_decOut_decOut_imm_imm_T_3,decOut_decOut_aluOp_func7,instrReg[11:7]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 187:89]
  wire [18:0] _decOut_decOut_imm_imm_T_15 = instrReg[31] ? 19'h7ffff : 19'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 190:21]
  wire [30:0] _decOut_decOut_imm_imm_T_23 = {_decOut_decOut_imm_imm_T_15,instrReg[7],instrReg[30:25],instrReg[11:8],1'h0
    }; // @[src/main/scala/wildcat/pipeline/Functions.scala 190:119]
  wire [31:0] _decOut_decOut_imm_imm_T_27 = {instrReg[31:12],12'h0}; // @[src/main/scala/wildcat/pipeline/Functions.scala 193:55]
  wire [10:0] _decOut_decOut_imm_imm_T_29 = instrReg[31] ? 11'h7ff : 11'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 196:21]
  wire [30:0] _decOut_decOut_imm_imm_T_37 = {_decOut_decOut_imm_imm_T_29,instrReg[19:12],instrReg[20],instrReg[30:21],1'h0
    }; // @[src/main/scala/wildcat/pipeline/Functions.scala 196:121]
  wire [30:0] _GEN_207 = 3'h5 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_37) : $signed({{19{
    _decOut_decOut_imm_imm_T_1[11]}},_decOut_decOut_imm_imm_T_1}); // @[src/main/scala/wildcat/pipeline/Functions.scala 182:23 196:13 181:9]
  wire [31:0] _GEN_208 = 3'h4 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_27) : $signed({{1{_GEN_207[30]}},
    _GEN_207}); // @[src/main/scala/wildcat/pipeline/Functions.scala 182:23 193:13]
  wire [31:0] _GEN_209 = 3'h3 == decOut_instrType ? $signed({{1{_decOut_decOut_imm_imm_T_23[30]}},
    _decOut_decOut_imm_imm_T_23}) : $signed(_GEN_208); // @[src/main/scala/wildcat/pipeline/Functions.scala 182:23 190:13]
  wire [31:0] _GEN_210 = 3'h2 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_13) : $signed(_GEN_209); // @[src/main/scala/wildcat/pipeline/Functions.scala 182:23 187:13]
  wire [31:0] decOut_decOut_imm_imm = 3'h1 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_6) : $signed(_GEN_210)
    ; // @[src/main/scala/wildcat/pipeline/Functions.scala 182:23 184:13]
  wire [4:0] decEx_rs1 = instrReg[19:15]; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 111:24]
  wire [4:0] decEx_rs2 = instrReg[24:20]; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 112:24]
  wire [31:0] data = _T_5 & decExReg_rd == decEx_rs2 ? wbData : rs2Val; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 121:17]
  wire [31:0] _memAddress_T = _T_5 & decExReg_rd == decEx_rs1 ? wbData : rs1Val; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 123:29]
  wire [31:0] memAddress = $signed(_memAddress_T) + $signed(decOut_decOut_imm_imm); // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 123:50]
  wire [1:0] decEx_memLow = memAddress[1:0]; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 124:29]
  wire [31:0] _wrData_T_6 = {data[7:0],data[7:0],data[7:0],data[7:0]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 349:58]
  wire  _GEN_212 = 2'h0 == decEx_memLow; // @[src/main/scala/wildcat/pipeline/Functions.scala 350:{24,24} 346:25]
  wire  _GEN_213 = 2'h1 == decEx_memLow; // @[src/main/scala/wildcat/pipeline/Functions.scala 350:{24,24} 346:25]
  wire  _GEN_214 = 2'h2 == decEx_memLow; // @[src/main/scala/wildcat/pipeline/Functions.scala 350:{24,24} 346:25]
  wire  _GEN_215 = 2'h3 == decEx_memLow; // @[src/main/scala/wildcat/pipeline/Functions.scala 350:{24,24} 346:25]
  wire [31:0] _wrData_T_9 = {data[15:0],data[15:0]}; // @[src/main/scala/wildcat/pipeline/Functions.scala 353:31]
  wire  _GEN_218 = _GEN_212 ? 1'h0 : _GEN_214; // @[src/main/scala/wildcat/pipeline/Functions.scala 354:24 346:25]
  wire [31:0] _GEN_223 = _decOut_decOut_aluOp_T_6 ? _wrData_T_9 : data; // @[src/main/scala/wildcat/pipeline/Functions.scala 347:19 353:16 345:29]
  wire  _GEN_224 = _decOut_decOut_aluOp_T_6 ? _GEN_212 : _decOut_decOut_aluOp_T_7; // @[src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire  _GEN_226 = _decOut_decOut_aluOp_T_6 ? _GEN_218 : _decOut_decOut_aluOp_T_7; // @[src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire  wrMask_0 = _decOut_decOut_aluOp_T ? _GEN_212 : _GEN_224; // @[src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire  wrMask_1 = _decOut_decOut_aluOp_T ? _GEN_213 : _GEN_224; // @[src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire  wrMask_2 = _decOut_decOut_aluOp_T ? _GEN_214 : _GEN_226; // @[src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire  wrMask_3 = _decOut_decOut_aluOp_T ? _GEN_215 : _GEN_226; // @[src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire [3:0] _wr_T = {wrMask_3,wrMask_2,wrMask_1,wrMask_0}; // @[src/main/scala/wildcat/pipeline/Functions.scala 369:21]
  reg [31:0] decExReg_memAddress; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg [31:0] decExReg_memWrData; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  reg [3:0] decExReg_memWrMask; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
  wire [31:0] decEx_csrVal = csr_io_data; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 116:16 92:19]
  wire  _T_18 = ~dmemStartedReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 176:14]
  wire  _GEN_287 = ~dmemStartedReg | dmemStartedReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 176:31 177:20 170:31]
  wire  _io_dmem_wr_T_2 = dmemAccess & decExReg_decOut_isStore & _T_18; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 183:55]
  Csr csr ( // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 86:19]
    .io_address(csr_io_address),
    .io_data(csr_io_data)
  );
  assign regs_rs1Val_MPORT_en = regs_rs1Val_MPORT_en_pipe_0;
  assign regs_rs1Val_MPORT_addr = regs_rs1Val_MPORT_addr_pipe_0;
  assign regs_rs1Val_MPORT_data = regs[regs_rs1Val_MPORT_addr]; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  assign regs_rs2Val_MPORT_en = regs_rs2Val_MPORT_en_pipe_0;
  assign regs_rs2Val_MPORT_addr = regs_rs2Val_MPORT_addr_pipe_0;
  assign regs_rs2Val_MPORT_data = regs[regs_rs2Val_MPORT_addr]; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  assign regs_MPORT_data = _T_15 ? _wbData_T_1 : res;
  assign regs_MPORT_addr = decExReg_rd;
  assign regs_MPORT_mask = 1'h1;
  assign regs_MPORT_en = wrEna & _T_4;
  assign io_imem_address = stall ? pcReg : _GEN_3; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 67:16 68:12]
  assign io_dmem_address = decExReg_memAddress; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 180:19]
  assign io_dmem_rd = dmemAccess & decExReg_decOut_isLoad & _T_18; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 181:54]
  assign io_dmem_wr = dmemAccess & decExReg_decOut_isStore & _T_18; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 183:55]
  assign io_dmem_wrData = decExReg_memWrData; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 182:18]
  assign io_dmem_wrMask = _io_dmem_wr_T_2 ? decExReg_memWrMask : 4'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 184:24]
  assign csr_io_address = instrReg[31:20]; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 87:29]
  always @(posedge clock) begin
    if (regs_MPORT_en & regs_MPORT_mask) begin
      regs[regs_MPORT_addr] <= regs_MPORT_data; // @[src/main/scala/wildcat/pipeline/Functions.scala 206:29]
    end
    regs_rs1Val_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      regs_rs1Val_MPORT_addr_pipe_0 <= rfReadInstr[19:15];
    end
    regs_rs2Val_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      regs_rs2Val_MPORT_addr_pipe_0 <= rfReadInstr[24:20];
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
      exFwdReg_valid <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
    end else begin
      exFwdReg_valid <= _T_5; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 195:18]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
      exFwdReg_wbDest <= 5'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
    end else begin
      exFwdReg_wbDest <= decExReg_rd; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 196:19]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
      exFwdReg_wbData <= 32'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
    end else if (decExReg_decOut_isJal | decExReg_decOut_isJalr) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 160:57]
      exFwdReg_wbData <= _wbData_T_1; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 161:12]
    end else if (decExReg_decOut_isLoad & dmemDone) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 189:44]
      if (_doBranch_T) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 286:19]
        exFwdReg_wbData <= _GEN_292;
      end else begin
        exFwdReg_wbData <= _GEN_303;
      end
    end else if (decExReg_decOut_isCssrw) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 154:33]
      exFwdReg_wbData <= decExReg_csrVal; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 155:9]
    end else begin
      exFwdReg_wbData <= _GEN_277;
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 39:22]
      pcReg <= 32'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 39:22]
    end else if (!(stall)) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 67:16]
      if (~fetchAckValid) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 61:25]
        if (!(_dmemAccess_T_2)) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 63:21]
          pcReg <= _pcNext_T_2; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 40:27]
        end
      end else begin
        pcReg <= _pcNext_T_2; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 40:27]
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_func3 <= 3'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_func3 <= decOut_func3; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_rs1 <= 5'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_rs1 <= decEx_rs1; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_rs1Val <= 32'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (rs1Val_REG == 5'h0) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 208:23]
        decExReg_rs1Val <= 32'h0;
      end else begin
        decExReg_rs1Val <= regs_rs1Val_MPORT_data;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_rs2 <= 5'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_rs2 <= decEx_rs2; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_rs2Val <= 32'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (rs2Val_REG == 5'h0) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 209:23]
        decExReg_rs2Val <= 32'h0;
      end else begin
        decExReg_rs2Val <= regs_rs2Val_MPORT_data;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_isBranch <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (7'h13 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isBranch <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 26:21]
      end else if (7'h33 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isBranch <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 26:21]
      end else begin
        decExReg_decOut_isBranch <= 7'h63 == decOut_opcode;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_isJal <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (7'h13 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isJal <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 27:18]
      end else if (7'h33 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isJal <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 27:18]
      end else begin
        decExReg_decOut_isJal <= _GEN_160;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_isJalr <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (7'h13 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isJalr <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 28:19]
      end else if (7'h33 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isJalr <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 28:19]
      end else begin
        decExReg_decOut_isJalr <= _GEN_161;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_valid <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_valid <= _dmemAccess_T_2; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_isLoad <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (7'h13 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isLoad <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 24:19]
      end else if (7'h33 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isLoad <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 24:19]
      end else begin
        decExReg_decOut_isLoad <= _GEN_156;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_isStore <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (7'h13 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isStore <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 25:20]
      end else if (7'h33 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isStore <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 25:20]
      end else begin
        decExReg_decOut_isStore <= _GEN_157;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 170:31]
      dmemStartedReg <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 170:31]
    end else if (~dmemAccess | dmemDone) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 174:33]
      dmemStartedReg <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 175:20]
    end else begin
      dmemStartedReg <= _GEN_287;
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_memLow <= 2'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_memLow <= decEx_memLow; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_isCssrw <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (7'h13 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isCssrw <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20]
      end else if (7'h33 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isCssrw <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 31:20]
      end else begin
        decExReg_decOut_isCssrw <= _GEN_163;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_csrVal <= 32'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_csrVal <= decEx_csrVal; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_isAuiPc <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (7'h13 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isAuiPc <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 23:20]
      end else if (7'h33 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isAuiPc <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 23:20]
      end else begin
        decExReg_decOut_isAuiPc <= _GEN_159;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_pc <= 32'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_pc <= pcRegReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_imm <= 32'sh0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (3'h1 == decOut_instrType) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 182:23]
        decExReg_decOut_imm <= _decOut_decOut_imm_imm_T_6; // @[src/main/scala/wildcat/pipeline/Functions.scala 184:13]
      end else if (3'h2 == decOut_instrType) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 182:23]
        decExReg_decOut_imm <= _decOut_decOut_imm_imm_T_13; // @[src/main/scala/wildcat/pipeline/Functions.scala 187:13]
      end else begin
        decExReg_decOut_imm <= _GEN_209;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_isLui <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (7'h13 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isLui <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 22:18]
      end else if (7'h33 == decOut_opcode) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 37:20]
        decExReg_decOut_isLui <= 1'h0; // @[src/main/scala/wildcat/pipeline/Functions.scala 22:18]
      end else begin
        decExReg_decOut_isLui <= _GEN_158;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_aluOp <= 4'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (3'h0 == decOut_func3) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19]
        decExReg_decOut_aluOp <= {{3'd0}, _decOut_decOut_aluOp_T_5};
      end else if (3'h1 == decOut_func3) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 116:19]
        decExReg_decOut_aluOp <= 4'h2; // @[src/main/scala/wildcat/pipeline/Functions.scala 124:15]
      end else begin
        decExReg_decOut_aluOp <= _GEN_204;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_isImm <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_decOut_isImm <= decOut_isImm; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 43:32]
      fetchPendingReg <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 43:32]
    end else begin
      fetchPendingReg <= fetchReq | _fetchPendingReg_T; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 52:19]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 44:32]
      fetchDiscardReg <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 44:32]
    end else if (fetchReq) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 54:18]
      fetchDiscardReg <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 55:21]
    end else if (fetchAck) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 53:25]
      fetchDiscardReg <= 1'h0;
    end else begin
      fetchDiscardReg <= doBranch & fetchPendingReg | fetchDiscardReg;
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 72:25]
      pcRegReg <= 32'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 72:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 73:16]
      pcRegReg <= pcReg; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 74:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 76:25]
      instrReg <= 32'h33; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 76:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 77:16]
      if (doBranch) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 78:20]
        instrReg <= 32'h33;
      end else if (~fetchAckValid) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 61:25]
        instrReg <= 32'h33; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 62:11]
      end else begin
        instrReg <= io_imem_rdData; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 60:26]
      end
    end
    rs1Val_REG <= rfReadInstr[19:15]; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 81:24]
    rs2Val_REG <= rfReadInstr[24:20]; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 82:24]
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_rd <= 5'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_rd <= instrReg[11:7]; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_decOut_rfWrite <= 1'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_decOut_rfWrite <= decOut_rfWrite; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_memAddress <= 32'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      decExReg_memAddress <= memAddress; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 138:14]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_memWrData <= 32'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (decOut_isStore & _dmemAccess_T_2) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 128:37]
        if (_decOut_decOut_aluOp_T) begin // @[src/main/scala/wildcat/pipeline/Functions.scala 347:19]
          decExReg_memWrData <= _wrData_T_6; // @[src/main/scala/wildcat/pipeline/Functions.scala 349:16]
        end else begin
          decExReg_memWrData <= _GEN_223;
        end
      end else if (_T_5 & decExReg_rd == decEx_rs2) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 121:17]
        decExReg_memWrData <= wbData;
      end else begin
        decExReg_memWrData <= rs2Val;
      end
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
      decExReg_memWrMask <= 4'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 136:25]
    end else if (_fetchReq_T) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 137:16]
      if (decOut_isStore & _dmemAccess_T_2) begin // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 128:37]
        decExReg_memWrMask <= _wr_T; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 131:21]
      end else begin
        decExReg_memWrMask <= 4'h0; // @[src/main/scala/wildcat/pipeline/ThreeCats.scala 127:19]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    regs[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  regs_rs1Val_MPORT_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  regs_rs1Val_MPORT_addr_pipe_0 = _RAND_2[4:0];
  _RAND_3 = {1{`RANDOM}};
  regs_rs2Val_MPORT_en_pipe_0 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  regs_rs2Val_MPORT_addr_pipe_0 = _RAND_4[4:0];
  _RAND_5 = {1{`RANDOM}};
  exFwdReg_valid = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  exFwdReg_wbDest = _RAND_6[4:0];
  _RAND_7 = {1{`RANDOM}};
  exFwdReg_wbData = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  pcReg = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  decExReg_func3 = _RAND_9[2:0];
  _RAND_10 = {1{`RANDOM}};
  decExReg_rs1 = _RAND_10[4:0];
  _RAND_11 = {1{`RANDOM}};
  decExReg_rs1Val = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  decExReg_rs2 = _RAND_12[4:0];
  _RAND_13 = {1{`RANDOM}};
  decExReg_rs2Val = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  decExReg_decOut_isBranch = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  decExReg_decOut_isJal = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  decExReg_decOut_isJalr = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  decExReg_valid = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  decExReg_decOut_isLoad = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  decExReg_decOut_isStore = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  dmemStartedReg = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  decExReg_memLow = _RAND_21[1:0];
  _RAND_22 = {1{`RANDOM}};
  decExReg_decOut_isCssrw = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  decExReg_csrVal = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  decExReg_decOut_isAuiPc = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  decExReg_pc = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  decExReg_decOut_imm = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  decExReg_decOut_isLui = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  decExReg_decOut_aluOp = _RAND_28[3:0];
  _RAND_29 = {1{`RANDOM}};
  decExReg_decOut_isImm = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  fetchPendingReg = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  fetchDiscardReg = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  pcRegReg = _RAND_32[31:0];
  _RAND_33 = {1{`RANDOM}};
  instrReg = _RAND_33[31:0];
  _RAND_34 = {1{`RANDOM}};
  rs1Val_REG = _RAND_34[4:0];
  _RAND_35 = {1{`RANDOM}};
  rs2Val_REG = _RAND_35[4:0];
  _RAND_36 = {1{`RANDOM}};
  decExReg_rd = _RAND_36[4:0];
  _RAND_37 = {1{`RANDOM}};
  decExReg_decOut_rfWrite = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  decExReg_memAddress = _RAND_38[31:0];
  _RAND_39 = {1{`RANDOM}};
  decExReg_memWrData = _RAND_39[31:0];
  _RAND_40 = {1{`RANDOM}};
  decExReg_memWrMask = _RAND_40[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module InstructionROM(
  input         clock,
  input         reset,
  input  [31:0] cpuPort_address, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output [31:0] cpuPort_rdData, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output        cpuPort_ack // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] addrReg; // @[src/main/scala/memory/InstructionROM.scala 12:20]
  wire [31:0] _GEN_1 = 5'h1 == addrReg[6:2] ? 32'h293 : 32'hf0010237; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_2 = 5'h2 == addrReg[6:2] ? 32'h2337 : _GEN_1; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_3 = 5'h3 == addrReg[6:2] ? 32'h393 : _GEN_2; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_4 = 5'h4 == addrReg[6:2] ? 32'h538433 : _GEN_3; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_5 = 5'h5 == addrReg[6:2] ? 32'h83a023 : _GEN_4; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_6 = 5'h6 == addrReg[6:2] ? 32'h438393 : _GEN_5; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_7 = 5'h7 == addrReg[6:2] ? 32'hfe639ae3 : _GEN_6; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_8 = 5'h8 == addrReg[6:2] ? 32'h393 : _GEN_7; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_9 = 5'h9 == addrReg[6:2] ? 32'h3a403 : _GEN_8; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_10 = 5'ha == addrReg[6:2] ? 32'h5384b3 : _GEN_9; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_11 = 5'hb == addrReg[6:2] ? 32'h941c63 : _GEN_10; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_12 = 5'hc == addrReg[6:2] ? 32'h438393 : _GEN_11; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_13 = 5'hd == addrReg[6:2] ? 32'hfe6398e3 : _GEN_12; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_14 = 5'he == addrReg[6:2] ? 32'h128293 : _GEN_13; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_15 = 5'hf == addrReg[6:2] ? 32'h522023 : _GEN_14; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_16 = 5'h10 == addrReg[6:2] ? 32'hfcdff06f : _GEN_15; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_17 = 5'h11 == addrReg[6:2] ? 32'h84b7 : _GEN_16; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_18 = 5'h12 == addrReg[6:2] ? 32'hfff48493 : _GEN_17; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  wire [31:0] _GEN_19 = 5'h13 == addrReg[6:2] ? 32'h922023 : _GEN_18; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  reg  firstReg; // @[src/main/scala/memory/InstructionROM.scala 20:25]
  assign cpuPort_rdData = 5'h14 == addrReg[6:2] ? 32'h6f : _GEN_19; // @[src/main/scala/memory/InstructionROM.scala 15:{18,18}]
  assign cpuPort_ack = ~firstReg; // @[src/main/scala/memory/InstructionROM.scala 22:18]
  always @(posedge clock) begin
    addrReg <= cpuPort_address; // @[src/main/scala/memory/InstructionROM.scala 13:11]
    firstReg <= reset; // @[src/main/scala/memory/InstructionROM.scala 20:{25,25} 21:12]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  addrReg = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  firstReg = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module DirectMappedReadCache(
  input         clock,
  input         reset,
  output        io_cpu_req_ready, // @[src/main/scala/cache/cache.scala 8:14]
  input         io_cpu_req_valid, // @[src/main/scala/cache/cache.scala 8:14]
  input  [31:0] io_cpu_req_bits_addr, // @[src/main/scala/cache/cache.scala 8:14]
  input         io_cpu_req_bits_write, // @[src/main/scala/cache/cache.scala 8:14]
  input  [31:0] io_cpu_req_bits_wdata, // @[src/main/scala/cache/cache.scala 8:14]
  input  [3:0]  io_cpu_req_bits_wmask, // @[src/main/scala/cache/cache.scala 8:14]
  input         io_cpu_resp_ready, // @[src/main/scala/cache/cache.scala 8:14]
  output        io_cpu_resp_valid, // @[src/main/scala/cache/cache.scala 8:14]
  output [31:0] io_cpu_resp_bits_data, // @[src/main/scala/cache/cache.scala 8:14]
  input         io_mm_req_refill_ready, // @[src/main/scala/cache/cache.scala 8:14]
  output        io_mm_req_refill_valid, // @[src/main/scala/cache/cache.scala 8:14]
  output [31:0] io_mm_req_refill_bits_addr, // @[src/main/scala/cache/cache.scala 8:14]
  output        io_mm_data_refill_ready, // @[src/main/scala/cache/cache.scala 8:14]
  input         io_mm_data_refill_valid, // @[src/main/scala/cache/cache.scala 8:14]
  input  [31:0] io_mm_data_refill_bits_data, // @[src/main/scala/cache/cache.scala 8:14]
  input         io_mm_req_write_ready, // @[src/main/scala/cache/cache.scala 8:14]
  output        io_mm_req_write_valid, // @[src/main/scala/cache/cache.scala 8:14]
  output [31:0] io_mm_req_write_bits_addr, // @[src/main/scala/cache/cache.scala 8:14]
  output [31:0] io_mm_req_write_bits_data, // @[src/main/scala/cache/cache.scala 8:14]
  output [3:0]  io_mm_req_write_bits_mask, // @[src/main/scala/cache/cache.scala 8:14]
  output        io_stat_hit, // @[src/main/scala/cache/cache.scala 8:14]
  output        io_stat_miss // @[src/main/scala/cache/cache.scala 8:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [255:0] _RAND_3;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [31:0] _RAND_50;
  reg [31:0] _RAND_51;
  reg [31:0] _RAND_52;
  reg [31:0] _RAND_53;
  reg [31:0] _RAND_54;
  reg [31:0] _RAND_55;
  reg [31:0] _RAND_56;
  reg [31:0] _RAND_57;
  reg [31:0] _RAND_58;
  reg [31:0] _RAND_59;
  reg [31:0] _RAND_60;
  reg [31:0] _RAND_61;
  reg [31:0] _RAND_62;
  reg [31:0] _RAND_63;
  reg [31:0] _RAND_64;
  reg [31:0] _RAND_65;
  reg [31:0] _RAND_66;
  reg [31:0] _RAND_67;
  reg [31:0] _RAND_68;
  reg [31:0] _RAND_69;
  reg [31:0] _RAND_70;
  reg [31:0] _RAND_71;
  reg [31:0] _RAND_72;
  reg [31:0] _RAND_73;
  reg [31:0] _RAND_74;
  reg [31:0] _RAND_75;
  reg [31:0] _RAND_76;
  reg [31:0] _RAND_77;
  reg [31:0] _RAND_78;
  reg [31:0] _RAND_79;
  reg [31:0] _RAND_80;
  reg [31:0] _RAND_81;
  reg [31:0] _RAND_82;
  reg [31:0] _RAND_83;
  reg [31:0] _RAND_84;
  reg [31:0] _RAND_85;
  reg [31:0] _RAND_86;
  reg [31:0] _RAND_87;
  reg [31:0] _RAND_88;
  reg [31:0] _RAND_89;
  reg [31:0] _RAND_90;
  reg [31:0] _RAND_91;
  reg [31:0] _RAND_92;
  reg [31:0] _RAND_93;
  reg [31:0] _RAND_94;
  reg [31:0] _RAND_95;
  reg [31:0] _RAND_96;
  reg [31:0] _RAND_97;
  reg [31:0] _RAND_98;
  reg [31:0] _RAND_99;
  reg [31:0] _RAND_100;
  reg [31:0] _RAND_101;
  reg [31:0] _RAND_102;
  reg [31:0] _RAND_103;
  reg [31:0] _RAND_104;
  reg [31:0] _RAND_105;
  reg [31:0] _RAND_106;
  reg [31:0] _RAND_107;
  reg [31:0] _RAND_108;
  reg [31:0] _RAND_109;
  reg [31:0] _RAND_110;
  reg [31:0] _RAND_111;
  reg [31:0] _RAND_112;
  reg [31:0] _RAND_113;
  reg [31:0] _RAND_114;
  reg [31:0] _RAND_115;
  reg [31:0] _RAND_116;
  reg [31:0] _RAND_117;
  reg [31:0] _RAND_118;
  reg [31:0] _RAND_119;
  reg [31:0] _RAND_120;
  reg [31:0] _RAND_121;
  reg [31:0] _RAND_122;
  reg [31:0] _RAND_123;
  reg [31:0] _RAND_124;
  reg [31:0] _RAND_125;
  reg [31:0] _RAND_126;
  reg [31:0] _RAND_127;
  reg [31:0] _RAND_128;
  reg [31:0] _RAND_129;
  reg [31:0] _RAND_130;
  reg [31:0] _RAND_131;
  reg [31:0] _RAND_132;
  reg [31:0] _RAND_133;
  reg [31:0] _RAND_134;
  reg [31:0] _RAND_135;
  reg [31:0] _RAND_136;
  reg [31:0] _RAND_137;
  reg [31:0] _RAND_138;
  reg [31:0] _RAND_139;
  reg [31:0] _RAND_140;
  reg [31:0] _RAND_141;
  reg [31:0] _RAND_142;
  reg [31:0] _RAND_143;
  reg [31:0] _RAND_144;
  reg [31:0] _RAND_145;
  reg [31:0] _RAND_146;
  reg [31:0] _RAND_147;
  reg [31:0] _RAND_148;
`endif // RANDOMIZE_REG_INIT
  reg [19:0] tagMem [0:127]; // @[src/main/scala/cache/cache.scala 13:27]
  wire  tagMem_tagRd_en; // @[src/main/scala/cache/cache.scala 13:27]
  wire [6:0] tagMem_tagRd_addr; // @[src/main/scala/cache/cache.scala 13:27]
  wire [19:0] tagMem_tagRd_data; // @[src/main/scala/cache/cache.scala 13:27]
  wire [19:0] tagMem_MPORT_1_data; // @[src/main/scala/cache/cache.scala 13:27]
  wire [6:0] tagMem_MPORT_1_addr; // @[src/main/scala/cache/cache.scala 13:27]
  wire  tagMem_MPORT_1_mask; // @[src/main/scala/cache/cache.scala 13:27]
  wire  tagMem_MPORT_1_en; // @[src/main/scala/cache/cache.scala 13:27]
  reg  tagMem_tagRd_en_pipe_0;
  reg [6:0] tagMem_tagRd_addr_pipe_0;
  reg [255:0] dataMem [0:127]; // @[src/main/scala/cache/cache.scala 14:28]
  wire  dataMem_lineRd_en; // @[src/main/scala/cache/cache.scala 14:28]
  wire [6:0] dataMem_lineRd_addr; // @[src/main/scala/cache/cache.scala 14:28]
  wire [255:0] dataMem_lineRd_data; // @[src/main/scala/cache/cache.scala 14:28]
  wire [255:0] dataMem_MPORT_data; // @[src/main/scala/cache/cache.scala 14:28]
  wire [6:0] dataMem_MPORT_addr; // @[src/main/scala/cache/cache.scala 14:28]
  wire  dataMem_MPORT_mask; // @[src/main/scala/cache/cache.scala 14:28]
  wire  dataMem_MPORT_en; // @[src/main/scala/cache/cache.scala 14:28]
  reg  dataMem_lineRd_en_pipe_0;
  reg [6:0] dataMem_lineRd_addr_pipe_0;
  reg  validBits_0; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_1; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_2; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_3; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_4; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_5; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_6; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_7; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_8; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_9; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_10; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_11; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_12; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_13; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_14; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_15; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_16; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_17; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_18; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_19; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_20; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_21; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_22; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_23; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_24; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_25; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_26; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_27; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_28; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_29; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_30; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_31; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_32; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_33; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_34; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_35; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_36; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_37; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_38; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_39; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_40; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_41; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_42; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_43; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_44; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_45; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_46; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_47; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_48; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_49; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_50; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_51; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_52; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_53; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_54; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_55; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_56; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_57; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_58; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_59; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_60; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_61; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_62; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_63; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_64; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_65; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_66; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_67; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_68; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_69; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_70; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_71; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_72; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_73; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_74; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_75; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_76; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_77; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_78; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_79; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_80; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_81; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_82; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_83; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_84; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_85; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_86; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_87; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_88; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_89; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_90; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_91; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_92; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_93; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_94; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_95; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_96; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_97; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_98; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_99; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_100; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_101; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_102; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_103; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_104; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_105; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_106; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_107; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_108; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_109; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_110; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_111; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_112; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_113; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_114; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_115; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_116; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_117; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_118; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_119; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_120; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_121; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_122; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_123; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_124; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_125; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_126; // @[src/main/scala/cache/cache.scala 11:26]
  reg  validBits_127; // @[src/main/scala/cache/cache.scala 11:26]
  reg [2:0] state; // @[src/main/scala/cache/cache.scala 17:22]
  reg [31:0] addrReg; // @[src/main/scala/cache/cache.scala 18:20]
  reg [31:0] respData; // @[src/main/scala/cache/cache.scala 19:21]
  reg [31:0] refillBuf_0; // @[src/main/scala/cache/cache.scala 20:22]
  reg [31:0] refillBuf_1; // @[src/main/scala/cache/cache.scala 20:22]
  reg [31:0] refillBuf_2; // @[src/main/scala/cache/cache.scala 20:22]
  reg [31:0] refillBuf_3; // @[src/main/scala/cache/cache.scala 20:22]
  reg [31:0] refillBuf_4; // @[src/main/scala/cache/cache.scala 20:22]
  reg [31:0] refillBuf_5; // @[src/main/scala/cache/cache.scala 20:22]
  reg [31:0] refillBuf_6; // @[src/main/scala/cache/cache.scala 20:22]
  reg [31:0] refillBuf_7; // @[src/main/scala/cache/cache.scala 20:22]
  reg [2:0] beatCnt; // @[src/main/scala/cache/cache.scala 22:24]
  reg  writeReg; // @[src/main/scala/cache/cache.scala 24:21]
  reg [31:0] wdataReg; // @[src/main/scala/cache/cache.scala 25:21]
  reg [3:0] wmaskReg; // @[src/main/scala/cache/cache.scala 26:21]
  wire [6:0] reqIdx = addrReg[11:5]; // @[src/main/scala/cache/model.scala 54:33]
  wire [19:0] reqTag = addrReg[31:12]; // @[src/main/scala/cache/model.scala 53:31]
  wire [2:0] reqWord = addrReg[4:2]; // @[src/main/scala/cache/model.scala 55:66]
  wire  _tagRd_T = io_cpu_req_ready & io_cpu_req_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire  _T_2 = 3'h0 == state; // @[src/main/scala/cache/cache.scala 119:17]
  wire  _GEN_20 = 7'h1 == reqIdx ? validBits_1 : validBits_0; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_21 = 7'h2 == reqIdx ? validBits_2 : _GEN_20; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_22 = 7'h3 == reqIdx ? validBits_3 : _GEN_21; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_23 = 7'h4 == reqIdx ? validBits_4 : _GEN_22; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_24 = 7'h5 == reqIdx ? validBits_5 : _GEN_23; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_25 = 7'h6 == reqIdx ? validBits_6 : _GEN_24; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_26 = 7'h7 == reqIdx ? validBits_7 : _GEN_25; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_27 = 7'h8 == reqIdx ? validBits_8 : _GEN_26; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_28 = 7'h9 == reqIdx ? validBits_9 : _GEN_27; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_29 = 7'ha == reqIdx ? validBits_10 : _GEN_28; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_30 = 7'hb == reqIdx ? validBits_11 : _GEN_29; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_31 = 7'hc == reqIdx ? validBits_12 : _GEN_30; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_32 = 7'hd == reqIdx ? validBits_13 : _GEN_31; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_33 = 7'he == reqIdx ? validBits_14 : _GEN_32; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_34 = 7'hf == reqIdx ? validBits_15 : _GEN_33; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_35 = 7'h10 == reqIdx ? validBits_16 : _GEN_34; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_36 = 7'h11 == reqIdx ? validBits_17 : _GEN_35; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_37 = 7'h12 == reqIdx ? validBits_18 : _GEN_36; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_38 = 7'h13 == reqIdx ? validBits_19 : _GEN_37; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_39 = 7'h14 == reqIdx ? validBits_20 : _GEN_38; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_40 = 7'h15 == reqIdx ? validBits_21 : _GEN_39; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_41 = 7'h16 == reqIdx ? validBits_22 : _GEN_40; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_42 = 7'h17 == reqIdx ? validBits_23 : _GEN_41; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_43 = 7'h18 == reqIdx ? validBits_24 : _GEN_42; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_44 = 7'h19 == reqIdx ? validBits_25 : _GEN_43; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_45 = 7'h1a == reqIdx ? validBits_26 : _GEN_44; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_46 = 7'h1b == reqIdx ? validBits_27 : _GEN_45; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_47 = 7'h1c == reqIdx ? validBits_28 : _GEN_46; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_48 = 7'h1d == reqIdx ? validBits_29 : _GEN_47; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_49 = 7'h1e == reqIdx ? validBits_30 : _GEN_48; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_50 = 7'h1f == reqIdx ? validBits_31 : _GEN_49; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_51 = 7'h20 == reqIdx ? validBits_32 : _GEN_50; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_52 = 7'h21 == reqIdx ? validBits_33 : _GEN_51; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_53 = 7'h22 == reqIdx ? validBits_34 : _GEN_52; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_54 = 7'h23 == reqIdx ? validBits_35 : _GEN_53; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_55 = 7'h24 == reqIdx ? validBits_36 : _GEN_54; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_56 = 7'h25 == reqIdx ? validBits_37 : _GEN_55; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_57 = 7'h26 == reqIdx ? validBits_38 : _GEN_56; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_58 = 7'h27 == reqIdx ? validBits_39 : _GEN_57; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_59 = 7'h28 == reqIdx ? validBits_40 : _GEN_58; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_60 = 7'h29 == reqIdx ? validBits_41 : _GEN_59; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_61 = 7'h2a == reqIdx ? validBits_42 : _GEN_60; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_62 = 7'h2b == reqIdx ? validBits_43 : _GEN_61; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_63 = 7'h2c == reqIdx ? validBits_44 : _GEN_62; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_64 = 7'h2d == reqIdx ? validBits_45 : _GEN_63; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_65 = 7'h2e == reqIdx ? validBits_46 : _GEN_64; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_66 = 7'h2f == reqIdx ? validBits_47 : _GEN_65; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_67 = 7'h30 == reqIdx ? validBits_48 : _GEN_66; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_68 = 7'h31 == reqIdx ? validBits_49 : _GEN_67; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_69 = 7'h32 == reqIdx ? validBits_50 : _GEN_68; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_70 = 7'h33 == reqIdx ? validBits_51 : _GEN_69; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_71 = 7'h34 == reqIdx ? validBits_52 : _GEN_70; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_72 = 7'h35 == reqIdx ? validBits_53 : _GEN_71; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_73 = 7'h36 == reqIdx ? validBits_54 : _GEN_72; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_74 = 7'h37 == reqIdx ? validBits_55 : _GEN_73; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_75 = 7'h38 == reqIdx ? validBits_56 : _GEN_74; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_76 = 7'h39 == reqIdx ? validBits_57 : _GEN_75; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_77 = 7'h3a == reqIdx ? validBits_58 : _GEN_76; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_78 = 7'h3b == reqIdx ? validBits_59 : _GEN_77; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_79 = 7'h3c == reqIdx ? validBits_60 : _GEN_78; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_80 = 7'h3d == reqIdx ? validBits_61 : _GEN_79; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_81 = 7'h3e == reqIdx ? validBits_62 : _GEN_80; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_82 = 7'h3f == reqIdx ? validBits_63 : _GEN_81; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_83 = 7'h40 == reqIdx ? validBits_64 : _GEN_82; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_84 = 7'h41 == reqIdx ? validBits_65 : _GEN_83; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_85 = 7'h42 == reqIdx ? validBits_66 : _GEN_84; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_86 = 7'h43 == reqIdx ? validBits_67 : _GEN_85; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_87 = 7'h44 == reqIdx ? validBits_68 : _GEN_86; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_88 = 7'h45 == reqIdx ? validBits_69 : _GEN_87; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_89 = 7'h46 == reqIdx ? validBits_70 : _GEN_88; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_90 = 7'h47 == reqIdx ? validBits_71 : _GEN_89; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_91 = 7'h48 == reqIdx ? validBits_72 : _GEN_90; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_92 = 7'h49 == reqIdx ? validBits_73 : _GEN_91; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_93 = 7'h4a == reqIdx ? validBits_74 : _GEN_92; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_94 = 7'h4b == reqIdx ? validBits_75 : _GEN_93; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_95 = 7'h4c == reqIdx ? validBits_76 : _GEN_94; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_96 = 7'h4d == reqIdx ? validBits_77 : _GEN_95; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_97 = 7'h4e == reqIdx ? validBits_78 : _GEN_96; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_98 = 7'h4f == reqIdx ? validBits_79 : _GEN_97; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_99 = 7'h50 == reqIdx ? validBits_80 : _GEN_98; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_100 = 7'h51 == reqIdx ? validBits_81 : _GEN_99; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_101 = 7'h52 == reqIdx ? validBits_82 : _GEN_100; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_102 = 7'h53 == reqIdx ? validBits_83 : _GEN_101; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_103 = 7'h54 == reqIdx ? validBits_84 : _GEN_102; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_104 = 7'h55 == reqIdx ? validBits_85 : _GEN_103; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_105 = 7'h56 == reqIdx ? validBits_86 : _GEN_104; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_106 = 7'h57 == reqIdx ? validBits_87 : _GEN_105; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_107 = 7'h58 == reqIdx ? validBits_88 : _GEN_106; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_108 = 7'h59 == reqIdx ? validBits_89 : _GEN_107; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_109 = 7'h5a == reqIdx ? validBits_90 : _GEN_108; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_110 = 7'h5b == reqIdx ? validBits_91 : _GEN_109; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_111 = 7'h5c == reqIdx ? validBits_92 : _GEN_110; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_112 = 7'h5d == reqIdx ? validBits_93 : _GEN_111; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_113 = 7'h5e == reqIdx ? validBits_94 : _GEN_112; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_114 = 7'h5f == reqIdx ? validBits_95 : _GEN_113; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_115 = 7'h60 == reqIdx ? validBits_96 : _GEN_114; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_116 = 7'h61 == reqIdx ? validBits_97 : _GEN_115; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_117 = 7'h62 == reqIdx ? validBits_98 : _GEN_116; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_118 = 7'h63 == reqIdx ? validBits_99 : _GEN_117; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_119 = 7'h64 == reqIdx ? validBits_100 : _GEN_118; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_120 = 7'h65 == reqIdx ? validBits_101 : _GEN_119; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_121 = 7'h66 == reqIdx ? validBits_102 : _GEN_120; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_122 = 7'h67 == reqIdx ? validBits_103 : _GEN_121; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_123 = 7'h68 == reqIdx ? validBits_104 : _GEN_122; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_124 = 7'h69 == reqIdx ? validBits_105 : _GEN_123; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_125 = 7'h6a == reqIdx ? validBits_106 : _GEN_124; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_126 = 7'h6b == reqIdx ? validBits_107 : _GEN_125; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_127 = 7'h6c == reqIdx ? validBits_108 : _GEN_126; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_128 = 7'h6d == reqIdx ? validBits_109 : _GEN_127; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_129 = 7'h6e == reqIdx ? validBits_110 : _GEN_128; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_130 = 7'h6f == reqIdx ? validBits_111 : _GEN_129; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_131 = 7'h70 == reqIdx ? validBits_112 : _GEN_130; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_132 = 7'h71 == reqIdx ? validBits_113 : _GEN_131; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_133 = 7'h72 == reqIdx ? validBits_114 : _GEN_132; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_134 = 7'h73 == reqIdx ? validBits_115 : _GEN_133; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_135 = 7'h74 == reqIdx ? validBits_116 : _GEN_134; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_136 = 7'h75 == reqIdx ? validBits_117 : _GEN_135; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_137 = 7'h76 == reqIdx ? validBits_118 : _GEN_136; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_138 = 7'h77 == reqIdx ? validBits_119 : _GEN_137; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_139 = 7'h78 == reqIdx ? validBits_120 : _GEN_138; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_140 = 7'h79 == reqIdx ? validBits_121 : _GEN_139; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_141 = 7'h7a == reqIdx ? validBits_122 : _GEN_140; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_142 = 7'h7b == reqIdx ? validBits_123 : _GEN_141; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_143 = 7'h7c == reqIdx ? validBits_124 : _GEN_142; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_144 = 7'h7d == reqIdx ? validBits_125 : _GEN_143; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_145 = 7'h7e == reqIdx ? validBits_126 : _GEN_144; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  _GEN_146 = 7'h7f == reqIdx ? validBits_127 : _GEN_145; // @[src/main/scala/cache/cache.scala 135:{35,35}]
  wire  hit = _GEN_146 & tagMem_tagRd_data == reqTag; // @[src/main/scala/cache/cache.scala 135:35]
  wire  _GEN_176 = hit & writeReg; // @[src/main/scala/cache/cache.scala 140:17 43:36]
  wire  _T_17 = io_mm_data_refill_ready & io_mm_data_refill_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire  lastBeat = beatCnt == 3'h7; // @[src/main/scala/cache/cache.scala 116:26]
  wire  _GEN_495 = _T_17 & lastBeat; // @[src/main/scala/cache/cache.scala 227:36 43:36]
  wire  _GEN_807 = 3'h3 == state ? 1'h0 : 3'h4 == state & _GEN_495; // @[src/main/scala/cache/cache.scala 119:17 43:36]
  wire  _GEN_960 = 3'h2 == state ? 1'h0 : _GEN_807; // @[src/main/scala/cache/cache.scala 119:17 43:36]
  wire  _GEN_1103 = 3'h1 == state ? _GEN_176 : _GEN_960; // @[src/main/scala/cache/cache.scala 119:17]
  wire [255:0] _dataWriteLine_src_WIRE = dataMem_lineRd_data; // @[src/main/scala/cache/cache.scala 75:{53,53}]
  wire [31:0] dataWriteLine_src_7 = _dataWriteLine_src_WIRE[255:224]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] dataWriteLine_src_6 = _dataWriteLine_src_WIRE[223:192]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] dataWriteLine_src_5 = _dataWriteLine_src_WIRE[191:160]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] dataWriteLine_src_4 = _dataWriteLine_src_WIRE[159:128]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] dataWriteLine_src_3 = _dataWriteLine_src_WIRE[127:96]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] dataWriteLine_src_2 = _dataWriteLine_src_WIRE[95:64]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] dataWriteLine_src_1 = _dataWriteLine_src_WIRE[63:32]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] dataWriteLine_src_0 = _dataWriteLine_src_WIRE[31:0]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] _GEN_148 = 3'h1 == reqWord ? dataWriteLine_src_1 : dataWriteLine_src_0; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_149 = 3'h2 == reqWord ? dataWriteLine_src_2 : _GEN_148; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_150 = 3'h3 == reqWord ? dataWriteLine_src_3 : _GEN_149; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_151 = 3'h4 == reqWord ? dataWriteLine_src_4 : _GEN_150; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_152 = 3'h5 == reqWord ? dataWriteLine_src_5 : _GEN_151; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_153 = 3'h6 == reqWord ? dataWriteLine_src_6 : _GEN_152; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_154 = 3'h7 == reqWord ? dataWriteLine_src_7 : _GEN_153; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [7:0] dataWriteLine_words_bytes_3 = wmaskReg[3] ? wdataReg[31:24] : _GEN_154[31:24]; // @[src/main/scala/cache/cache.scala 88:10]
  wire [7:0] dataWriteLine_words_bytes_2 = wmaskReg[2] ? wdataReg[23:16] : _GEN_154[23:16]; // @[src/main/scala/cache/cache.scala 88:10]
  wire [7:0] dataWriteLine_words_bytes_1 = wmaskReg[1] ? wdataReg[15:8] : _GEN_154[15:8]; // @[src/main/scala/cache/cache.scala 88:10]
  wire [7:0] dataWriteLine_words_bytes_0 = wmaskReg[0] ? wdataReg[7:0] : _GEN_154[7:0]; // @[src/main/scala/cache/cache.scala 88:10]
  wire [31:0] _dataWriteLine_words_T = {dataWriteLine_words_bytes_3,dataWriteLine_words_bytes_2,
    dataWriteLine_words_bytes_1,dataWriteLine_words_bytes_0}; // @[src/main/scala/cache/cache.scala 90:11]
  wire [31:0] dataWriteLine_words_7 = 3'h7 == reqWord ? _dataWriteLine_words_T : dataWriteLine_src_7; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] dataWriteLine_words_6 = 3'h6 == reqWord ? _dataWriteLine_words_T : dataWriteLine_src_6; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] dataWriteLine_words_5 = 3'h5 == reqWord ? _dataWriteLine_words_T : dataWriteLine_src_5; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] dataWriteLine_words_4 = 3'h4 == reqWord ? _dataWriteLine_words_T : dataWriteLine_src_4; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] dataWriteLine_words_3 = 3'h3 == reqWord ? _dataWriteLine_words_T : dataWriteLine_src_3; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] dataWriteLine_words_2 = 3'h2 == reqWord ? _dataWriteLine_words_T : dataWriteLine_src_2; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] dataWriteLine_words_1 = 3'h1 == reqWord ? _dataWriteLine_words_T : dataWriteLine_src_1; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] dataWriteLine_words_0 = 3'h0 == reqWord ? _dataWriteLine_words_T : dataWriteLine_src_0; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [255:0] _dataWriteLine_T = {dataWriteLine_words_7,dataWriteLine_words_6,dataWriteLine_words_5,
    dataWriteLine_words_4,dataWriteLine_words_3,dataWriteLine_words_2,dataWriteLine_words_1,dataWriteLine_words_0}; // @[src/main/scala/cache/cache.scala 105:11]
  wire [255:0] _GEN_172 = writeReg ? _dataWriteLine_T : 256'h0; // @[src/main/scala/cache/cache.scala 141:24 146:25 44:34]
  wire [255:0] _GEN_177 = hit ? _GEN_172 : 256'h0; // @[src/main/scala/cache/cache.scala 140:17 44:34]
  wire [31:0] beats_7 = 3'h7 == beatCnt ? io_mm_data_refill_bits_data : refillBuf_7; // @[src/main/scala/cache/cache.scala 241:{28,28} 237:31]
  wire [31:0] beats_6 = 3'h6 == beatCnt ? io_mm_data_refill_bits_data : refillBuf_6; // @[src/main/scala/cache/cache.scala 241:{28,28} 237:31]
  wire [31:0] beats_5 = 3'h5 == beatCnt ? io_mm_data_refill_bits_data : refillBuf_5; // @[src/main/scala/cache/cache.scala 241:{28,28} 237:31]
  wire [31:0] beats_4 = 3'h4 == beatCnt ? io_mm_data_refill_bits_data : refillBuf_4; // @[src/main/scala/cache/cache.scala 241:{28,28} 237:31]
  wire [31:0] beats_3 = 3'h3 == beatCnt ? io_mm_data_refill_bits_data : refillBuf_3; // @[src/main/scala/cache/cache.scala 241:{28,28} 237:31]
  wire [31:0] beats_2 = 3'h2 == beatCnt ? io_mm_data_refill_bits_data : refillBuf_2; // @[src/main/scala/cache/cache.scala 241:{28,28} 237:31]
  wire [31:0] beats_1 = 3'h1 == beatCnt ? io_mm_data_refill_bits_data : refillBuf_1; // @[src/main/scala/cache/cache.scala 241:{28,28} 237:31]
  wire [31:0] beats_0 = 3'h0 == beatCnt ? io_mm_data_refill_bits_data : refillBuf_0; // @[src/main/scala/cache/cache.scala 241:{28,28} 237:31]
  wire [255:0] newLine = {beats_7,beats_6,beats_5,beats_4,beats_3,beats_2,beats_1,beats_0}; // @[src/main/scala/cache/cache.scala 245:31]
  wire [31:0] installedLine_src_7 = newLine[255:224]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] installedLine_src_6 = newLine[223:192]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] installedLine_src_5 = newLine[191:160]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] installedLine_src_4 = newLine[159:128]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] installedLine_src_3 = newLine[127:96]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] installedLine_src_2 = newLine[95:64]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] installedLine_src_1 = newLine[63:32]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] installedLine_src_0 = newLine[31:0]; // @[src/main/scala/cache/cache.scala 75:53]
  wire [31:0] _GEN_199 = 3'h1 == reqWord ? installedLine_src_1 : installedLine_src_0; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_200 = 3'h2 == reqWord ? installedLine_src_2 : _GEN_199; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_201 = 3'h3 == reqWord ? installedLine_src_3 : _GEN_200; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_202 = 3'h4 == reqWord ? installedLine_src_4 : _GEN_201; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_203 = 3'h5 == reqWord ? installedLine_src_5 : _GEN_202; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_204 = 3'h6 == reqWord ? installedLine_src_6 : _GEN_203; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [31:0] _GEN_205 = 3'h7 == reqWord ? installedLine_src_7 : _GEN_204; // @[src/main/scala/cache/cache.scala 88:{47,47}]
  wire [7:0] installedLine_words_bytes_3 = wmaskReg[3] ? wdataReg[31:24] : _GEN_205[31:24]; // @[src/main/scala/cache/cache.scala 88:10]
  wire [7:0] installedLine_words_bytes_2 = wmaskReg[2] ? wdataReg[23:16] : _GEN_205[23:16]; // @[src/main/scala/cache/cache.scala 88:10]
  wire [7:0] installedLine_words_bytes_1 = wmaskReg[1] ? wdataReg[15:8] : _GEN_205[15:8]; // @[src/main/scala/cache/cache.scala 88:10]
  wire [7:0] installedLine_words_bytes_0 = wmaskReg[0] ? wdataReg[7:0] : _GEN_205[7:0]; // @[src/main/scala/cache/cache.scala 88:10]
  wire [31:0] _installedLine_words_T = {installedLine_words_bytes_3,installedLine_words_bytes_2,
    installedLine_words_bytes_1,installedLine_words_bytes_0}; // @[src/main/scala/cache/cache.scala 90:11]
  wire [31:0] installedLine_words_7 = 3'h7 == reqWord ? _installedLine_words_T : installedLine_src_7; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] installedLine_words_6 = 3'h6 == reqWord ? _installedLine_words_T : installedLine_src_6; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] installedLine_words_5 = 3'h5 == reqWord ? _installedLine_words_T : installedLine_src_5; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] installedLine_words_4 = 3'h4 == reqWord ? _installedLine_words_T : installedLine_src_4; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] installedLine_words_3 = 3'h3 == reqWord ? _installedLine_words_T : installedLine_src_3; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] installedLine_words_2 = 3'h2 == reqWord ? _installedLine_words_T : installedLine_src_2; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] installedLine_words_1 = 3'h1 == reqWord ? _installedLine_words_T : installedLine_src_1; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [31:0] installedLine_words_0 = 3'h0 == reqWord ? _installedLine_words_T : installedLine_src_0; // @[src/main/scala/cache/cache.scala 103:{22,22} 96:25]
  wire [255:0] _installedLine_T = {installedLine_words_7,installedLine_words_6,installedLine_words_5,
    installedLine_words_4,installedLine_words_3,installedLine_words_2,installedLine_words_1,installedLine_words_0}; // @[src/main/scala/cache/cache.scala 105:11]
  wire [255:0] installedLine = writeReg ? _installedLine_T : newLine; // @[src/main/scala/cache/cache.scala 250:34]
  wire [255:0] _GEN_351 = lastBeat ? installedLine : 256'h0; // @[src/main/scala/cache/cache.scala 236:24 255:25 44:34]
  wire [255:0] _GEN_496 = _T_17 ? _GEN_351 : 256'h0; // @[src/main/scala/cache/cache.scala 227:36 44:34]
  wire [255:0] _GEN_654 = 3'h4 == state ? _GEN_496 : 256'h0; // @[src/main/scala/cache/cache.scala 119:17 44:34]
  wire [255:0] _GEN_808 = 3'h3 == state ? 256'h0 : _GEN_654; // @[src/main/scala/cache/cache.scala 119:17 44:34]
  wire [255:0] _GEN_961 = 3'h2 == state ? 256'h0 : _GEN_808; // @[src/main/scala/cache/cache.scala 119:17 44:34]
  wire [255:0] _GEN_1104 = 3'h1 == state ? _GEN_177 : _GEN_961; // @[src/main/scala/cache/cache.scala 119:17]
  wire [2:0] _GEN_173 = writeReg ? 3'h5 : 3'h6; // @[src/main/scala/cache/cache.scala 141:24 155:19 161:17]
  wire [2:0] _GEN_175 = writeReg ? 3'h5 : 3'h3; // @[src/main/scala/cache/cache.scala 166:26 168:19 171:19]
  wire  _T_13 = io_mm_req_refill_ready & io_mm_req_refill_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [2:0] _GEN_180 = _T_13 ? 3'h0 : beatCnt; // @[src/main/scala/cache/cache.scala 217:35 218:17 22:24]
  wire [2:0] _GEN_181 = _T_13 ? 3'h4 : state; // @[src/main/scala/cache/cache.scala 217:35 219:15 17:22]
  wire [2:0] _beatCnt_T_1 = beatCnt + 3'h1; // @[src/main/scala/cache/cache.scala 234:28]
  wire  _GEN_214 = 7'h0 == reqIdx | validBits_0; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_215 = 7'h1 == reqIdx | validBits_1; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_216 = 7'h2 == reqIdx | validBits_2; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_217 = 7'h3 == reqIdx | validBits_3; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_218 = 7'h4 == reqIdx | validBits_4; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_219 = 7'h5 == reqIdx | validBits_5; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_220 = 7'h6 == reqIdx | validBits_6; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_221 = 7'h7 == reqIdx | validBits_7; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_222 = 7'h8 == reqIdx | validBits_8; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_223 = 7'h9 == reqIdx | validBits_9; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_224 = 7'ha == reqIdx | validBits_10; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_225 = 7'hb == reqIdx | validBits_11; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_226 = 7'hc == reqIdx | validBits_12; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_227 = 7'hd == reqIdx | validBits_13; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_228 = 7'he == reqIdx | validBits_14; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_229 = 7'hf == reqIdx | validBits_15; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_230 = 7'h10 == reqIdx | validBits_16; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_231 = 7'h11 == reqIdx | validBits_17; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_232 = 7'h12 == reqIdx | validBits_18; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_233 = 7'h13 == reqIdx | validBits_19; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_234 = 7'h14 == reqIdx | validBits_20; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_235 = 7'h15 == reqIdx | validBits_21; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_236 = 7'h16 == reqIdx | validBits_22; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_237 = 7'h17 == reqIdx | validBits_23; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_238 = 7'h18 == reqIdx | validBits_24; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_239 = 7'h19 == reqIdx | validBits_25; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_240 = 7'h1a == reqIdx | validBits_26; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_241 = 7'h1b == reqIdx | validBits_27; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_242 = 7'h1c == reqIdx | validBits_28; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_243 = 7'h1d == reqIdx | validBits_29; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_244 = 7'h1e == reqIdx | validBits_30; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_245 = 7'h1f == reqIdx | validBits_31; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_246 = 7'h20 == reqIdx | validBits_32; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_247 = 7'h21 == reqIdx | validBits_33; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_248 = 7'h22 == reqIdx | validBits_34; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_249 = 7'h23 == reqIdx | validBits_35; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_250 = 7'h24 == reqIdx | validBits_36; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_251 = 7'h25 == reqIdx | validBits_37; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_252 = 7'h26 == reqIdx | validBits_38; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_253 = 7'h27 == reqIdx | validBits_39; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_254 = 7'h28 == reqIdx | validBits_40; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_255 = 7'h29 == reqIdx | validBits_41; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_256 = 7'h2a == reqIdx | validBits_42; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_257 = 7'h2b == reqIdx | validBits_43; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_258 = 7'h2c == reqIdx | validBits_44; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_259 = 7'h2d == reqIdx | validBits_45; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_260 = 7'h2e == reqIdx | validBits_46; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_261 = 7'h2f == reqIdx | validBits_47; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_262 = 7'h30 == reqIdx | validBits_48; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_263 = 7'h31 == reqIdx | validBits_49; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_264 = 7'h32 == reqIdx | validBits_50; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_265 = 7'h33 == reqIdx | validBits_51; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_266 = 7'h34 == reqIdx | validBits_52; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_267 = 7'h35 == reqIdx | validBits_53; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_268 = 7'h36 == reqIdx | validBits_54; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_269 = 7'h37 == reqIdx | validBits_55; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_270 = 7'h38 == reqIdx | validBits_56; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_271 = 7'h39 == reqIdx | validBits_57; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_272 = 7'h3a == reqIdx | validBits_58; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_273 = 7'h3b == reqIdx | validBits_59; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_274 = 7'h3c == reqIdx | validBits_60; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_275 = 7'h3d == reqIdx | validBits_61; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_276 = 7'h3e == reqIdx | validBits_62; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_277 = 7'h3f == reqIdx | validBits_63; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_278 = 7'h40 == reqIdx | validBits_64; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_279 = 7'h41 == reqIdx | validBits_65; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_280 = 7'h42 == reqIdx | validBits_66; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_281 = 7'h43 == reqIdx | validBits_67; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_282 = 7'h44 == reqIdx | validBits_68; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_283 = 7'h45 == reqIdx | validBits_69; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_284 = 7'h46 == reqIdx | validBits_70; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_285 = 7'h47 == reqIdx | validBits_71; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_286 = 7'h48 == reqIdx | validBits_72; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_287 = 7'h49 == reqIdx | validBits_73; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_288 = 7'h4a == reqIdx | validBits_74; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_289 = 7'h4b == reqIdx | validBits_75; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_290 = 7'h4c == reqIdx | validBits_76; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_291 = 7'h4d == reqIdx | validBits_77; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_292 = 7'h4e == reqIdx | validBits_78; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_293 = 7'h4f == reqIdx | validBits_79; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_294 = 7'h50 == reqIdx | validBits_80; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_295 = 7'h51 == reqIdx | validBits_81; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_296 = 7'h52 == reqIdx | validBits_82; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_297 = 7'h53 == reqIdx | validBits_83; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_298 = 7'h54 == reqIdx | validBits_84; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_299 = 7'h55 == reqIdx | validBits_85; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_300 = 7'h56 == reqIdx | validBits_86; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_301 = 7'h57 == reqIdx | validBits_87; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_302 = 7'h58 == reqIdx | validBits_88; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_303 = 7'h59 == reqIdx | validBits_89; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_304 = 7'h5a == reqIdx | validBits_90; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_305 = 7'h5b == reqIdx | validBits_91; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_306 = 7'h5c == reqIdx | validBits_92; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_307 = 7'h5d == reqIdx | validBits_93; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_308 = 7'h5e == reqIdx | validBits_94; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_309 = 7'h5f == reqIdx | validBits_95; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_310 = 7'h60 == reqIdx | validBits_96; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_311 = 7'h61 == reqIdx | validBits_97; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_312 = 7'h62 == reqIdx | validBits_98; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_313 = 7'h63 == reqIdx | validBits_99; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_314 = 7'h64 == reqIdx | validBits_100; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_315 = 7'h65 == reqIdx | validBits_101; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_316 = 7'h66 == reqIdx | validBits_102; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_317 = 7'h67 == reqIdx | validBits_103; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_318 = 7'h68 == reqIdx | validBits_104; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_319 = 7'h69 == reqIdx | validBits_105; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_320 = 7'h6a == reqIdx | validBits_106; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_321 = 7'h6b == reqIdx | validBits_107; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_322 = 7'h6c == reqIdx | validBits_108; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_323 = 7'h6d == reqIdx | validBits_109; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_324 = 7'h6e == reqIdx | validBits_110; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_325 = 7'h6f == reqIdx | validBits_111; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_326 = 7'h70 == reqIdx | validBits_112; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_327 = 7'h71 == reqIdx | validBits_113; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_328 = 7'h72 == reqIdx | validBits_114; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_329 = 7'h73 == reqIdx | validBits_115; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_330 = 7'h74 == reqIdx | validBits_116; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_331 = 7'h75 == reqIdx | validBits_117; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_332 = 7'h76 == reqIdx | validBits_118; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_333 = 7'h77 == reqIdx | validBits_119; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_334 = 7'h78 == reqIdx | validBits_120; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_335 = 7'h79 == reqIdx | validBits_121; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_336 = 7'h7a == reqIdx | validBits_122; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_337 = 7'h7b == reqIdx | validBits_123; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_338 = 7'h7c == reqIdx | validBits_124; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_339 = 7'h7d == reqIdx | validBits_125; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_340 = 7'h7e == reqIdx | validBits_126; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_341 = 7'h7f == reqIdx | validBits_127; // @[src/main/scala/cache/cache.scala 11:26 259:{29,29}]
  wire  _GEN_356 = lastBeat ? _GEN_214 : validBits_0; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_357 = lastBeat ? _GEN_215 : validBits_1; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_358 = lastBeat ? _GEN_216 : validBits_2; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_359 = lastBeat ? _GEN_217 : validBits_3; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_360 = lastBeat ? _GEN_218 : validBits_4; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_361 = lastBeat ? _GEN_219 : validBits_5; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_362 = lastBeat ? _GEN_220 : validBits_6; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_363 = lastBeat ? _GEN_221 : validBits_7; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_364 = lastBeat ? _GEN_222 : validBits_8; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_365 = lastBeat ? _GEN_223 : validBits_9; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_366 = lastBeat ? _GEN_224 : validBits_10; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_367 = lastBeat ? _GEN_225 : validBits_11; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_368 = lastBeat ? _GEN_226 : validBits_12; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_369 = lastBeat ? _GEN_227 : validBits_13; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_370 = lastBeat ? _GEN_228 : validBits_14; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_371 = lastBeat ? _GEN_229 : validBits_15; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_372 = lastBeat ? _GEN_230 : validBits_16; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_373 = lastBeat ? _GEN_231 : validBits_17; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_374 = lastBeat ? _GEN_232 : validBits_18; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_375 = lastBeat ? _GEN_233 : validBits_19; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_376 = lastBeat ? _GEN_234 : validBits_20; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_377 = lastBeat ? _GEN_235 : validBits_21; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_378 = lastBeat ? _GEN_236 : validBits_22; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_379 = lastBeat ? _GEN_237 : validBits_23; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_380 = lastBeat ? _GEN_238 : validBits_24; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_381 = lastBeat ? _GEN_239 : validBits_25; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_382 = lastBeat ? _GEN_240 : validBits_26; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_383 = lastBeat ? _GEN_241 : validBits_27; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_384 = lastBeat ? _GEN_242 : validBits_28; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_385 = lastBeat ? _GEN_243 : validBits_29; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_386 = lastBeat ? _GEN_244 : validBits_30; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_387 = lastBeat ? _GEN_245 : validBits_31; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_388 = lastBeat ? _GEN_246 : validBits_32; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_389 = lastBeat ? _GEN_247 : validBits_33; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_390 = lastBeat ? _GEN_248 : validBits_34; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_391 = lastBeat ? _GEN_249 : validBits_35; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_392 = lastBeat ? _GEN_250 : validBits_36; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_393 = lastBeat ? _GEN_251 : validBits_37; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_394 = lastBeat ? _GEN_252 : validBits_38; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_395 = lastBeat ? _GEN_253 : validBits_39; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_396 = lastBeat ? _GEN_254 : validBits_40; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_397 = lastBeat ? _GEN_255 : validBits_41; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_398 = lastBeat ? _GEN_256 : validBits_42; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_399 = lastBeat ? _GEN_257 : validBits_43; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_400 = lastBeat ? _GEN_258 : validBits_44; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_401 = lastBeat ? _GEN_259 : validBits_45; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_402 = lastBeat ? _GEN_260 : validBits_46; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_403 = lastBeat ? _GEN_261 : validBits_47; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_404 = lastBeat ? _GEN_262 : validBits_48; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_405 = lastBeat ? _GEN_263 : validBits_49; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_406 = lastBeat ? _GEN_264 : validBits_50; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_407 = lastBeat ? _GEN_265 : validBits_51; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_408 = lastBeat ? _GEN_266 : validBits_52; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_409 = lastBeat ? _GEN_267 : validBits_53; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_410 = lastBeat ? _GEN_268 : validBits_54; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_411 = lastBeat ? _GEN_269 : validBits_55; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_412 = lastBeat ? _GEN_270 : validBits_56; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_413 = lastBeat ? _GEN_271 : validBits_57; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_414 = lastBeat ? _GEN_272 : validBits_58; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_415 = lastBeat ? _GEN_273 : validBits_59; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_416 = lastBeat ? _GEN_274 : validBits_60; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_417 = lastBeat ? _GEN_275 : validBits_61; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_418 = lastBeat ? _GEN_276 : validBits_62; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_419 = lastBeat ? _GEN_277 : validBits_63; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_420 = lastBeat ? _GEN_278 : validBits_64; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_421 = lastBeat ? _GEN_279 : validBits_65; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_422 = lastBeat ? _GEN_280 : validBits_66; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_423 = lastBeat ? _GEN_281 : validBits_67; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_424 = lastBeat ? _GEN_282 : validBits_68; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_425 = lastBeat ? _GEN_283 : validBits_69; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_426 = lastBeat ? _GEN_284 : validBits_70; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_427 = lastBeat ? _GEN_285 : validBits_71; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_428 = lastBeat ? _GEN_286 : validBits_72; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_429 = lastBeat ? _GEN_287 : validBits_73; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_430 = lastBeat ? _GEN_288 : validBits_74; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_431 = lastBeat ? _GEN_289 : validBits_75; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_432 = lastBeat ? _GEN_290 : validBits_76; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_433 = lastBeat ? _GEN_291 : validBits_77; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_434 = lastBeat ? _GEN_292 : validBits_78; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_435 = lastBeat ? _GEN_293 : validBits_79; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_436 = lastBeat ? _GEN_294 : validBits_80; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_437 = lastBeat ? _GEN_295 : validBits_81; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_438 = lastBeat ? _GEN_296 : validBits_82; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_439 = lastBeat ? _GEN_297 : validBits_83; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_440 = lastBeat ? _GEN_298 : validBits_84; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_441 = lastBeat ? _GEN_299 : validBits_85; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_442 = lastBeat ? _GEN_300 : validBits_86; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_443 = lastBeat ? _GEN_301 : validBits_87; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_444 = lastBeat ? _GEN_302 : validBits_88; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_445 = lastBeat ? _GEN_303 : validBits_89; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_446 = lastBeat ? _GEN_304 : validBits_90; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_447 = lastBeat ? _GEN_305 : validBits_91; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_448 = lastBeat ? _GEN_306 : validBits_92; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_449 = lastBeat ? _GEN_307 : validBits_93; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_450 = lastBeat ? _GEN_308 : validBits_94; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_451 = lastBeat ? _GEN_309 : validBits_95; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_452 = lastBeat ? _GEN_310 : validBits_96; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_453 = lastBeat ? _GEN_311 : validBits_97; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_454 = lastBeat ? _GEN_312 : validBits_98; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_455 = lastBeat ? _GEN_313 : validBits_99; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_456 = lastBeat ? _GEN_314 : validBits_100; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_457 = lastBeat ? _GEN_315 : validBits_101; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_458 = lastBeat ? _GEN_316 : validBits_102; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_459 = lastBeat ? _GEN_317 : validBits_103; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_460 = lastBeat ? _GEN_318 : validBits_104; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_461 = lastBeat ? _GEN_319 : validBits_105; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_462 = lastBeat ? _GEN_320 : validBits_106; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_463 = lastBeat ? _GEN_321 : validBits_107; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_464 = lastBeat ? _GEN_322 : validBits_108; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_465 = lastBeat ? _GEN_323 : validBits_109; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_466 = lastBeat ? _GEN_324 : validBits_110; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_467 = lastBeat ? _GEN_325 : validBits_111; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_468 = lastBeat ? _GEN_326 : validBits_112; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_469 = lastBeat ? _GEN_327 : validBits_113; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_470 = lastBeat ? _GEN_328 : validBits_114; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_471 = lastBeat ? _GEN_329 : validBits_115; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_472 = lastBeat ? _GEN_330 : validBits_116; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_473 = lastBeat ? _GEN_331 : validBits_117; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_474 = lastBeat ? _GEN_332 : validBits_118; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_475 = lastBeat ? _GEN_333 : validBits_119; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_476 = lastBeat ? _GEN_334 : validBits_120; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_477 = lastBeat ? _GEN_335 : validBits_121; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_478 = lastBeat ? _GEN_336 : validBits_122; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_479 = lastBeat ? _GEN_337 : validBits_123; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_480 = lastBeat ? _GEN_338 : validBits_124; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_481 = lastBeat ? _GEN_339 : validBits_125; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_482 = lastBeat ? _GEN_340 : validBits_126; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire  _GEN_483 = lastBeat ? _GEN_341 : validBits_127; // @[src/main/scala/cache/cache.scala 236:24 11:26]
  wire [31:0] _GEN_484 = lastBeat ? _GEN_205 : respData; // @[src/main/scala/cache/cache.scala 236:24 266:20 19:21]
  wire [2:0] _GEN_485 = lastBeat ? 3'h6 : state; // @[src/main/scala/cache/cache.scala 236:24 267:17 17:22]
  wire [31:0] _GEN_486 = _T_17 ? beats_0 : refillBuf_0; // @[src/main/scala/cache/cache.scala 20:22 227:36]
  wire [31:0] _GEN_487 = _T_17 ? beats_1 : refillBuf_1; // @[src/main/scala/cache/cache.scala 20:22 227:36]
  wire [31:0] _GEN_488 = _T_17 ? beats_2 : refillBuf_2; // @[src/main/scala/cache/cache.scala 20:22 227:36]
  wire [31:0] _GEN_489 = _T_17 ? beats_3 : refillBuf_3; // @[src/main/scala/cache/cache.scala 20:22 227:36]
  wire [31:0] _GEN_490 = _T_17 ? beats_4 : refillBuf_4; // @[src/main/scala/cache/cache.scala 20:22 227:36]
  wire [31:0] _GEN_491 = _T_17 ? beats_5 : refillBuf_5; // @[src/main/scala/cache/cache.scala 20:22 227:36]
  wire [31:0] _GEN_492 = _T_17 ? beats_6 : refillBuf_6; // @[src/main/scala/cache/cache.scala 20:22 227:36]
  wire [31:0] _GEN_493 = _T_17 ? beats_7 : refillBuf_7; // @[src/main/scala/cache/cache.scala 20:22 227:36]
  wire [2:0] _GEN_494 = _T_17 ? _beatCnt_T_1 : beatCnt; // @[src/main/scala/cache/cache.scala 227:36 234:17 22:24]
  wire  _GEN_501 = _T_17 ? _GEN_356 : validBits_0; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_502 = _T_17 ? _GEN_357 : validBits_1; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_503 = _T_17 ? _GEN_358 : validBits_2; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_504 = _T_17 ? _GEN_359 : validBits_3; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_505 = _T_17 ? _GEN_360 : validBits_4; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_506 = _T_17 ? _GEN_361 : validBits_5; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_507 = _T_17 ? _GEN_362 : validBits_6; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_508 = _T_17 ? _GEN_363 : validBits_7; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_509 = _T_17 ? _GEN_364 : validBits_8; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_510 = _T_17 ? _GEN_365 : validBits_9; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_511 = _T_17 ? _GEN_366 : validBits_10; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_512 = _T_17 ? _GEN_367 : validBits_11; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_513 = _T_17 ? _GEN_368 : validBits_12; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_514 = _T_17 ? _GEN_369 : validBits_13; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_515 = _T_17 ? _GEN_370 : validBits_14; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_516 = _T_17 ? _GEN_371 : validBits_15; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_517 = _T_17 ? _GEN_372 : validBits_16; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_518 = _T_17 ? _GEN_373 : validBits_17; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_519 = _T_17 ? _GEN_374 : validBits_18; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_520 = _T_17 ? _GEN_375 : validBits_19; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_521 = _T_17 ? _GEN_376 : validBits_20; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_522 = _T_17 ? _GEN_377 : validBits_21; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_523 = _T_17 ? _GEN_378 : validBits_22; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_524 = _T_17 ? _GEN_379 : validBits_23; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_525 = _T_17 ? _GEN_380 : validBits_24; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_526 = _T_17 ? _GEN_381 : validBits_25; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_527 = _T_17 ? _GEN_382 : validBits_26; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_528 = _T_17 ? _GEN_383 : validBits_27; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_529 = _T_17 ? _GEN_384 : validBits_28; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_530 = _T_17 ? _GEN_385 : validBits_29; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_531 = _T_17 ? _GEN_386 : validBits_30; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_532 = _T_17 ? _GEN_387 : validBits_31; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_533 = _T_17 ? _GEN_388 : validBits_32; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_534 = _T_17 ? _GEN_389 : validBits_33; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_535 = _T_17 ? _GEN_390 : validBits_34; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_536 = _T_17 ? _GEN_391 : validBits_35; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_537 = _T_17 ? _GEN_392 : validBits_36; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_538 = _T_17 ? _GEN_393 : validBits_37; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_539 = _T_17 ? _GEN_394 : validBits_38; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_540 = _T_17 ? _GEN_395 : validBits_39; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_541 = _T_17 ? _GEN_396 : validBits_40; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_542 = _T_17 ? _GEN_397 : validBits_41; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_543 = _T_17 ? _GEN_398 : validBits_42; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_544 = _T_17 ? _GEN_399 : validBits_43; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_545 = _T_17 ? _GEN_400 : validBits_44; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_546 = _T_17 ? _GEN_401 : validBits_45; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_547 = _T_17 ? _GEN_402 : validBits_46; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_548 = _T_17 ? _GEN_403 : validBits_47; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_549 = _T_17 ? _GEN_404 : validBits_48; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_550 = _T_17 ? _GEN_405 : validBits_49; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_551 = _T_17 ? _GEN_406 : validBits_50; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_552 = _T_17 ? _GEN_407 : validBits_51; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_553 = _T_17 ? _GEN_408 : validBits_52; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_554 = _T_17 ? _GEN_409 : validBits_53; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_555 = _T_17 ? _GEN_410 : validBits_54; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_556 = _T_17 ? _GEN_411 : validBits_55; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_557 = _T_17 ? _GEN_412 : validBits_56; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_558 = _T_17 ? _GEN_413 : validBits_57; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_559 = _T_17 ? _GEN_414 : validBits_58; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_560 = _T_17 ? _GEN_415 : validBits_59; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_561 = _T_17 ? _GEN_416 : validBits_60; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_562 = _T_17 ? _GEN_417 : validBits_61; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_563 = _T_17 ? _GEN_418 : validBits_62; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_564 = _T_17 ? _GEN_419 : validBits_63; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_565 = _T_17 ? _GEN_420 : validBits_64; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_566 = _T_17 ? _GEN_421 : validBits_65; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_567 = _T_17 ? _GEN_422 : validBits_66; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_568 = _T_17 ? _GEN_423 : validBits_67; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_569 = _T_17 ? _GEN_424 : validBits_68; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_570 = _T_17 ? _GEN_425 : validBits_69; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_571 = _T_17 ? _GEN_426 : validBits_70; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_572 = _T_17 ? _GEN_427 : validBits_71; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_573 = _T_17 ? _GEN_428 : validBits_72; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_574 = _T_17 ? _GEN_429 : validBits_73; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_575 = _T_17 ? _GEN_430 : validBits_74; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_576 = _T_17 ? _GEN_431 : validBits_75; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_577 = _T_17 ? _GEN_432 : validBits_76; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_578 = _T_17 ? _GEN_433 : validBits_77; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_579 = _T_17 ? _GEN_434 : validBits_78; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_580 = _T_17 ? _GEN_435 : validBits_79; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_581 = _T_17 ? _GEN_436 : validBits_80; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_582 = _T_17 ? _GEN_437 : validBits_81; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_583 = _T_17 ? _GEN_438 : validBits_82; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_584 = _T_17 ? _GEN_439 : validBits_83; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_585 = _T_17 ? _GEN_440 : validBits_84; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_586 = _T_17 ? _GEN_441 : validBits_85; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_587 = _T_17 ? _GEN_442 : validBits_86; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_588 = _T_17 ? _GEN_443 : validBits_87; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_589 = _T_17 ? _GEN_444 : validBits_88; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_590 = _T_17 ? _GEN_445 : validBits_89; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_591 = _T_17 ? _GEN_446 : validBits_90; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_592 = _T_17 ? _GEN_447 : validBits_91; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_593 = _T_17 ? _GEN_448 : validBits_92; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_594 = _T_17 ? _GEN_449 : validBits_93; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_595 = _T_17 ? _GEN_450 : validBits_94; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_596 = _T_17 ? _GEN_451 : validBits_95; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_597 = _T_17 ? _GEN_452 : validBits_96; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_598 = _T_17 ? _GEN_453 : validBits_97; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_599 = _T_17 ? _GEN_454 : validBits_98; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_600 = _T_17 ? _GEN_455 : validBits_99; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_601 = _T_17 ? _GEN_456 : validBits_100; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_602 = _T_17 ? _GEN_457 : validBits_101; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_603 = _T_17 ? _GEN_458 : validBits_102; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_604 = _T_17 ? _GEN_459 : validBits_103; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_605 = _T_17 ? _GEN_460 : validBits_104; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_606 = _T_17 ? _GEN_461 : validBits_105; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_607 = _T_17 ? _GEN_462 : validBits_106; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_608 = _T_17 ? _GEN_463 : validBits_107; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_609 = _T_17 ? _GEN_464 : validBits_108; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_610 = _T_17 ? _GEN_465 : validBits_109; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_611 = _T_17 ? _GEN_466 : validBits_110; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_612 = _T_17 ? _GEN_467 : validBits_111; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_613 = _T_17 ? _GEN_468 : validBits_112; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_614 = _T_17 ? _GEN_469 : validBits_113; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_615 = _T_17 ? _GEN_470 : validBits_114; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_616 = _T_17 ? _GEN_471 : validBits_115; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_617 = _T_17 ? _GEN_472 : validBits_116; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_618 = _T_17 ? _GEN_473 : validBits_117; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_619 = _T_17 ? _GEN_474 : validBits_118; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_620 = _T_17 ? _GEN_475 : validBits_119; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_621 = _T_17 ? _GEN_476 : validBits_120; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_622 = _T_17 ? _GEN_477 : validBits_121; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_623 = _T_17 ? _GEN_478 : validBits_122; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_624 = _T_17 ? _GEN_479 : validBits_123; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_625 = _T_17 ? _GEN_480 : validBits_124; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_626 = _T_17 ? _GEN_481 : validBits_125; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_627 = _T_17 ? _GEN_482 : validBits_126; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire  _GEN_628 = _T_17 ? _GEN_483 : validBits_127; // @[src/main/scala/cache/cache.scala 11:26 227:36]
  wire [31:0] _GEN_629 = _T_17 ? _GEN_484 : respData; // @[src/main/scala/cache/cache.scala 19:21 227:36]
  wire [2:0] _GEN_630 = _T_17 ? _GEN_485 : state; // @[src/main/scala/cache/cache.scala 17:22 227:36]
  wire [31:0] _io_mm_req_write_bits_addr_T_1 = {addrReg[31:2],2'h0}; // @[src/main/scala/cache/model.scala 59:70]
  wire  _T_21 = io_mm_req_write_ready & io_mm_req_write_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [2:0] _GEN_632 = _T_21 ? 3'h6 : state; // @[src/main/scala/cache/cache.scala 278:36 280:17 17:22]
  wire [2:0] _GEN_633 = io_cpu_resp_ready ? 3'h0 : state; // @[src/main/scala/cache/cache.scala 287:31 288:15 17:22]
  wire [2:0] _GEN_635 = 3'h6 == state ? _GEN_633 : state; // @[src/main/scala/cache/cache.scala 119:17 17:22]
  wire [31:0] _GEN_637 = 3'h5 == state ? _io_mm_req_write_bits_addr_T_1 : 32'h0; // @[src/main/scala/cache/cache.scala 119:17 275:35 63:29]
  wire [31:0] _GEN_638 = 3'h5 == state ? wdataReg : 32'h0; // @[src/main/scala/cache/cache.scala 119:17 276:35 62:29]
  wire [3:0] _GEN_639 = 3'h5 == state ? wmaskReg : 4'h0; // @[src/main/scala/cache/cache.scala 119:17 277:35 64:29]
  wire [2:0] _GEN_641 = 3'h5 == state ? _GEN_632 : _GEN_635; // @[src/main/scala/cache/cache.scala 119:17]
  wire  _GEN_642 = 3'h5 == state ? 1'h0 : 3'h6 == state; // @[src/main/scala/cache/cache.scala 119:17 50:21]
  wire [31:0] _GEN_644 = 3'h4 == state ? _GEN_486 : refillBuf_0; // @[src/main/scala/cache/cache.scala 119:17 20:22]
  wire [31:0] _GEN_645 = 3'h4 == state ? _GEN_487 : refillBuf_1; // @[src/main/scala/cache/cache.scala 119:17 20:22]
  wire [31:0] _GEN_646 = 3'h4 == state ? _GEN_488 : refillBuf_2; // @[src/main/scala/cache/cache.scala 119:17 20:22]
  wire [31:0] _GEN_647 = 3'h4 == state ? _GEN_489 : refillBuf_3; // @[src/main/scala/cache/cache.scala 119:17 20:22]
  wire [31:0] _GEN_648 = 3'h4 == state ? _GEN_490 : refillBuf_4; // @[src/main/scala/cache/cache.scala 119:17 20:22]
  wire [31:0] _GEN_649 = 3'h4 == state ? _GEN_491 : refillBuf_5; // @[src/main/scala/cache/cache.scala 119:17 20:22]
  wire [31:0] _GEN_650 = 3'h4 == state ? _GEN_492 : refillBuf_6; // @[src/main/scala/cache/cache.scala 119:17 20:22]
  wire [31:0] _GEN_651 = 3'h4 == state ? _GEN_493 : refillBuf_7; // @[src/main/scala/cache/cache.scala 119:17 20:22]
  wire [2:0] _GEN_652 = 3'h4 == state ? _GEN_494 : beatCnt; // @[src/main/scala/cache/cache.scala 119:17 22:24]
  wire  _GEN_659 = 3'h4 == state ? _GEN_501 : validBits_0; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_660 = 3'h4 == state ? _GEN_502 : validBits_1; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_661 = 3'h4 == state ? _GEN_503 : validBits_2; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_662 = 3'h4 == state ? _GEN_504 : validBits_3; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_663 = 3'h4 == state ? _GEN_505 : validBits_4; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_664 = 3'h4 == state ? _GEN_506 : validBits_5; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_665 = 3'h4 == state ? _GEN_507 : validBits_6; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_666 = 3'h4 == state ? _GEN_508 : validBits_7; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_667 = 3'h4 == state ? _GEN_509 : validBits_8; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_668 = 3'h4 == state ? _GEN_510 : validBits_9; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_669 = 3'h4 == state ? _GEN_511 : validBits_10; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_670 = 3'h4 == state ? _GEN_512 : validBits_11; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_671 = 3'h4 == state ? _GEN_513 : validBits_12; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_672 = 3'h4 == state ? _GEN_514 : validBits_13; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_673 = 3'h4 == state ? _GEN_515 : validBits_14; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_674 = 3'h4 == state ? _GEN_516 : validBits_15; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_675 = 3'h4 == state ? _GEN_517 : validBits_16; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_676 = 3'h4 == state ? _GEN_518 : validBits_17; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_677 = 3'h4 == state ? _GEN_519 : validBits_18; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_678 = 3'h4 == state ? _GEN_520 : validBits_19; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_679 = 3'h4 == state ? _GEN_521 : validBits_20; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_680 = 3'h4 == state ? _GEN_522 : validBits_21; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_681 = 3'h4 == state ? _GEN_523 : validBits_22; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_682 = 3'h4 == state ? _GEN_524 : validBits_23; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_683 = 3'h4 == state ? _GEN_525 : validBits_24; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_684 = 3'h4 == state ? _GEN_526 : validBits_25; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_685 = 3'h4 == state ? _GEN_527 : validBits_26; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_686 = 3'h4 == state ? _GEN_528 : validBits_27; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_687 = 3'h4 == state ? _GEN_529 : validBits_28; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_688 = 3'h4 == state ? _GEN_530 : validBits_29; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_689 = 3'h4 == state ? _GEN_531 : validBits_30; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_690 = 3'h4 == state ? _GEN_532 : validBits_31; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_691 = 3'h4 == state ? _GEN_533 : validBits_32; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_692 = 3'h4 == state ? _GEN_534 : validBits_33; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_693 = 3'h4 == state ? _GEN_535 : validBits_34; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_694 = 3'h4 == state ? _GEN_536 : validBits_35; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_695 = 3'h4 == state ? _GEN_537 : validBits_36; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_696 = 3'h4 == state ? _GEN_538 : validBits_37; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_697 = 3'h4 == state ? _GEN_539 : validBits_38; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_698 = 3'h4 == state ? _GEN_540 : validBits_39; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_699 = 3'h4 == state ? _GEN_541 : validBits_40; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_700 = 3'h4 == state ? _GEN_542 : validBits_41; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_701 = 3'h4 == state ? _GEN_543 : validBits_42; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_702 = 3'h4 == state ? _GEN_544 : validBits_43; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_703 = 3'h4 == state ? _GEN_545 : validBits_44; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_704 = 3'h4 == state ? _GEN_546 : validBits_45; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_705 = 3'h4 == state ? _GEN_547 : validBits_46; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_706 = 3'h4 == state ? _GEN_548 : validBits_47; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_707 = 3'h4 == state ? _GEN_549 : validBits_48; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_708 = 3'h4 == state ? _GEN_550 : validBits_49; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_709 = 3'h4 == state ? _GEN_551 : validBits_50; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_710 = 3'h4 == state ? _GEN_552 : validBits_51; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_711 = 3'h4 == state ? _GEN_553 : validBits_52; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_712 = 3'h4 == state ? _GEN_554 : validBits_53; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_713 = 3'h4 == state ? _GEN_555 : validBits_54; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_714 = 3'h4 == state ? _GEN_556 : validBits_55; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_715 = 3'h4 == state ? _GEN_557 : validBits_56; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_716 = 3'h4 == state ? _GEN_558 : validBits_57; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_717 = 3'h4 == state ? _GEN_559 : validBits_58; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_718 = 3'h4 == state ? _GEN_560 : validBits_59; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_719 = 3'h4 == state ? _GEN_561 : validBits_60; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_720 = 3'h4 == state ? _GEN_562 : validBits_61; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_721 = 3'h4 == state ? _GEN_563 : validBits_62; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_722 = 3'h4 == state ? _GEN_564 : validBits_63; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_723 = 3'h4 == state ? _GEN_565 : validBits_64; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_724 = 3'h4 == state ? _GEN_566 : validBits_65; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_725 = 3'h4 == state ? _GEN_567 : validBits_66; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_726 = 3'h4 == state ? _GEN_568 : validBits_67; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_727 = 3'h4 == state ? _GEN_569 : validBits_68; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_728 = 3'h4 == state ? _GEN_570 : validBits_69; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_729 = 3'h4 == state ? _GEN_571 : validBits_70; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_730 = 3'h4 == state ? _GEN_572 : validBits_71; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_731 = 3'h4 == state ? _GEN_573 : validBits_72; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_732 = 3'h4 == state ? _GEN_574 : validBits_73; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_733 = 3'h4 == state ? _GEN_575 : validBits_74; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_734 = 3'h4 == state ? _GEN_576 : validBits_75; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_735 = 3'h4 == state ? _GEN_577 : validBits_76; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_736 = 3'h4 == state ? _GEN_578 : validBits_77; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_737 = 3'h4 == state ? _GEN_579 : validBits_78; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_738 = 3'h4 == state ? _GEN_580 : validBits_79; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_739 = 3'h4 == state ? _GEN_581 : validBits_80; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_740 = 3'h4 == state ? _GEN_582 : validBits_81; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_741 = 3'h4 == state ? _GEN_583 : validBits_82; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_742 = 3'h4 == state ? _GEN_584 : validBits_83; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_743 = 3'h4 == state ? _GEN_585 : validBits_84; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_744 = 3'h4 == state ? _GEN_586 : validBits_85; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_745 = 3'h4 == state ? _GEN_587 : validBits_86; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_746 = 3'h4 == state ? _GEN_588 : validBits_87; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_747 = 3'h4 == state ? _GEN_589 : validBits_88; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_748 = 3'h4 == state ? _GEN_590 : validBits_89; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_749 = 3'h4 == state ? _GEN_591 : validBits_90; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_750 = 3'h4 == state ? _GEN_592 : validBits_91; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_751 = 3'h4 == state ? _GEN_593 : validBits_92; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_752 = 3'h4 == state ? _GEN_594 : validBits_93; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_753 = 3'h4 == state ? _GEN_595 : validBits_94; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_754 = 3'h4 == state ? _GEN_596 : validBits_95; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_755 = 3'h4 == state ? _GEN_597 : validBits_96; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_756 = 3'h4 == state ? _GEN_598 : validBits_97; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_757 = 3'h4 == state ? _GEN_599 : validBits_98; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_758 = 3'h4 == state ? _GEN_600 : validBits_99; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_759 = 3'h4 == state ? _GEN_601 : validBits_100; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_760 = 3'h4 == state ? _GEN_602 : validBits_101; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_761 = 3'h4 == state ? _GEN_603 : validBits_102; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_762 = 3'h4 == state ? _GEN_604 : validBits_103; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_763 = 3'h4 == state ? _GEN_605 : validBits_104; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_764 = 3'h4 == state ? _GEN_606 : validBits_105; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_765 = 3'h4 == state ? _GEN_607 : validBits_106; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_766 = 3'h4 == state ? _GEN_608 : validBits_107; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_767 = 3'h4 == state ? _GEN_609 : validBits_108; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_768 = 3'h4 == state ? _GEN_610 : validBits_109; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_769 = 3'h4 == state ? _GEN_611 : validBits_110; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_770 = 3'h4 == state ? _GEN_612 : validBits_111; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_771 = 3'h4 == state ? _GEN_613 : validBits_112; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_772 = 3'h4 == state ? _GEN_614 : validBits_113; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_773 = 3'h4 == state ? _GEN_615 : validBits_114; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_774 = 3'h4 == state ? _GEN_616 : validBits_115; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_775 = 3'h4 == state ? _GEN_617 : validBits_116; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_776 = 3'h4 == state ? _GEN_618 : validBits_117; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_777 = 3'h4 == state ? _GEN_619 : validBits_118; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_778 = 3'h4 == state ? _GEN_620 : validBits_119; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_779 = 3'h4 == state ? _GEN_621 : validBits_120; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_780 = 3'h4 == state ? _GEN_622 : validBits_121; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_781 = 3'h4 == state ? _GEN_623 : validBits_122; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_782 = 3'h4 == state ? _GEN_624 : validBits_123; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_783 = 3'h4 == state ? _GEN_625 : validBits_124; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_784 = 3'h4 == state ? _GEN_626 : validBits_125; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_785 = 3'h4 == state ? _GEN_627 : validBits_126; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_786 = 3'h4 == state ? _GEN_628 : validBits_127; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire [31:0] _GEN_787 = 3'h4 == state ? _GEN_629 : respData; // @[src/main/scala/cache/cache.scala 119:17 19:21]
  wire [2:0] _GEN_788 = 3'h4 == state ? _GEN_630 : _GEN_641; // @[src/main/scala/cache/cache.scala 119:17]
  wire  _GEN_789 = 3'h4 == state ? 1'h0 : 3'h5 == state; // @[src/main/scala/cache/cache.scala 119:17 61:25]
  wire [31:0] _GEN_790 = 3'h4 == state ? 32'h0 : _GEN_637; // @[src/main/scala/cache/cache.scala 119:17 63:29]
  wire [31:0] _GEN_791 = 3'h4 == state ? 32'h0 : _GEN_638; // @[src/main/scala/cache/cache.scala 119:17 62:29]
  wire [3:0] _GEN_792 = 3'h4 == state ? 4'h0 : _GEN_639; // @[src/main/scala/cache/cache.scala 119:17 64:29]
  wire  _GEN_794 = 3'h4 == state ? 1'h0 : _GEN_642; // @[src/main/scala/cache/cache.scala 119:17 50:21]
  wire [2:0] _GEN_796 = 3'h3 == state ? _GEN_180 : _GEN_652; // @[src/main/scala/cache/cache.scala 119:17]
  wire [2:0] _GEN_797 = 3'h3 == state ? _GEN_181 : _GEN_788; // @[src/main/scala/cache/cache.scala 119:17]
  wire  _GEN_798 = 3'h3 == state ? 1'h0 : 3'h4 == state; // @[src/main/scala/cache/cache.scala 119:17 57:27]
  wire  _GEN_813 = 3'h3 == state ? validBits_0 : _GEN_659; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_814 = 3'h3 == state ? validBits_1 : _GEN_660; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_815 = 3'h3 == state ? validBits_2 : _GEN_661; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_816 = 3'h3 == state ? validBits_3 : _GEN_662; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_817 = 3'h3 == state ? validBits_4 : _GEN_663; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_818 = 3'h3 == state ? validBits_5 : _GEN_664; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_819 = 3'h3 == state ? validBits_6 : _GEN_665; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_820 = 3'h3 == state ? validBits_7 : _GEN_666; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_821 = 3'h3 == state ? validBits_8 : _GEN_667; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_822 = 3'h3 == state ? validBits_9 : _GEN_668; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_823 = 3'h3 == state ? validBits_10 : _GEN_669; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_824 = 3'h3 == state ? validBits_11 : _GEN_670; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_825 = 3'h3 == state ? validBits_12 : _GEN_671; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_826 = 3'h3 == state ? validBits_13 : _GEN_672; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_827 = 3'h3 == state ? validBits_14 : _GEN_673; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_828 = 3'h3 == state ? validBits_15 : _GEN_674; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_829 = 3'h3 == state ? validBits_16 : _GEN_675; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_830 = 3'h3 == state ? validBits_17 : _GEN_676; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_831 = 3'h3 == state ? validBits_18 : _GEN_677; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_832 = 3'h3 == state ? validBits_19 : _GEN_678; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_833 = 3'h3 == state ? validBits_20 : _GEN_679; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_834 = 3'h3 == state ? validBits_21 : _GEN_680; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_835 = 3'h3 == state ? validBits_22 : _GEN_681; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_836 = 3'h3 == state ? validBits_23 : _GEN_682; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_837 = 3'h3 == state ? validBits_24 : _GEN_683; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_838 = 3'h3 == state ? validBits_25 : _GEN_684; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_839 = 3'h3 == state ? validBits_26 : _GEN_685; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_840 = 3'h3 == state ? validBits_27 : _GEN_686; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_841 = 3'h3 == state ? validBits_28 : _GEN_687; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_842 = 3'h3 == state ? validBits_29 : _GEN_688; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_843 = 3'h3 == state ? validBits_30 : _GEN_689; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_844 = 3'h3 == state ? validBits_31 : _GEN_690; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_845 = 3'h3 == state ? validBits_32 : _GEN_691; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_846 = 3'h3 == state ? validBits_33 : _GEN_692; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_847 = 3'h3 == state ? validBits_34 : _GEN_693; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_848 = 3'h3 == state ? validBits_35 : _GEN_694; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_849 = 3'h3 == state ? validBits_36 : _GEN_695; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_850 = 3'h3 == state ? validBits_37 : _GEN_696; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_851 = 3'h3 == state ? validBits_38 : _GEN_697; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_852 = 3'h3 == state ? validBits_39 : _GEN_698; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_853 = 3'h3 == state ? validBits_40 : _GEN_699; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_854 = 3'h3 == state ? validBits_41 : _GEN_700; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_855 = 3'h3 == state ? validBits_42 : _GEN_701; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_856 = 3'h3 == state ? validBits_43 : _GEN_702; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_857 = 3'h3 == state ? validBits_44 : _GEN_703; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_858 = 3'h3 == state ? validBits_45 : _GEN_704; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_859 = 3'h3 == state ? validBits_46 : _GEN_705; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_860 = 3'h3 == state ? validBits_47 : _GEN_706; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_861 = 3'h3 == state ? validBits_48 : _GEN_707; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_862 = 3'h3 == state ? validBits_49 : _GEN_708; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_863 = 3'h3 == state ? validBits_50 : _GEN_709; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_864 = 3'h3 == state ? validBits_51 : _GEN_710; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_865 = 3'h3 == state ? validBits_52 : _GEN_711; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_866 = 3'h3 == state ? validBits_53 : _GEN_712; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_867 = 3'h3 == state ? validBits_54 : _GEN_713; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_868 = 3'h3 == state ? validBits_55 : _GEN_714; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_869 = 3'h3 == state ? validBits_56 : _GEN_715; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_870 = 3'h3 == state ? validBits_57 : _GEN_716; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_871 = 3'h3 == state ? validBits_58 : _GEN_717; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_872 = 3'h3 == state ? validBits_59 : _GEN_718; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_873 = 3'h3 == state ? validBits_60 : _GEN_719; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_874 = 3'h3 == state ? validBits_61 : _GEN_720; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_875 = 3'h3 == state ? validBits_62 : _GEN_721; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_876 = 3'h3 == state ? validBits_63 : _GEN_722; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_877 = 3'h3 == state ? validBits_64 : _GEN_723; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_878 = 3'h3 == state ? validBits_65 : _GEN_724; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_879 = 3'h3 == state ? validBits_66 : _GEN_725; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_880 = 3'h3 == state ? validBits_67 : _GEN_726; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_881 = 3'h3 == state ? validBits_68 : _GEN_727; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_882 = 3'h3 == state ? validBits_69 : _GEN_728; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_883 = 3'h3 == state ? validBits_70 : _GEN_729; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_884 = 3'h3 == state ? validBits_71 : _GEN_730; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_885 = 3'h3 == state ? validBits_72 : _GEN_731; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_886 = 3'h3 == state ? validBits_73 : _GEN_732; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_887 = 3'h3 == state ? validBits_74 : _GEN_733; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_888 = 3'h3 == state ? validBits_75 : _GEN_734; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_889 = 3'h3 == state ? validBits_76 : _GEN_735; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_890 = 3'h3 == state ? validBits_77 : _GEN_736; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_891 = 3'h3 == state ? validBits_78 : _GEN_737; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_892 = 3'h3 == state ? validBits_79 : _GEN_738; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_893 = 3'h3 == state ? validBits_80 : _GEN_739; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_894 = 3'h3 == state ? validBits_81 : _GEN_740; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_895 = 3'h3 == state ? validBits_82 : _GEN_741; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_896 = 3'h3 == state ? validBits_83 : _GEN_742; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_897 = 3'h3 == state ? validBits_84 : _GEN_743; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_898 = 3'h3 == state ? validBits_85 : _GEN_744; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_899 = 3'h3 == state ? validBits_86 : _GEN_745; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_900 = 3'h3 == state ? validBits_87 : _GEN_746; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_901 = 3'h3 == state ? validBits_88 : _GEN_747; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_902 = 3'h3 == state ? validBits_89 : _GEN_748; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_903 = 3'h3 == state ? validBits_90 : _GEN_749; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_904 = 3'h3 == state ? validBits_91 : _GEN_750; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_905 = 3'h3 == state ? validBits_92 : _GEN_751; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_906 = 3'h3 == state ? validBits_93 : _GEN_752; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_907 = 3'h3 == state ? validBits_94 : _GEN_753; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_908 = 3'h3 == state ? validBits_95 : _GEN_754; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_909 = 3'h3 == state ? validBits_96 : _GEN_755; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_910 = 3'h3 == state ? validBits_97 : _GEN_756; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_911 = 3'h3 == state ? validBits_98 : _GEN_757; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_912 = 3'h3 == state ? validBits_99 : _GEN_758; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_913 = 3'h3 == state ? validBits_100 : _GEN_759; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_914 = 3'h3 == state ? validBits_101 : _GEN_760; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_915 = 3'h3 == state ? validBits_102 : _GEN_761; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_916 = 3'h3 == state ? validBits_103 : _GEN_762; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_917 = 3'h3 == state ? validBits_104 : _GEN_763; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_918 = 3'h3 == state ? validBits_105 : _GEN_764; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_919 = 3'h3 == state ? validBits_106 : _GEN_765; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_920 = 3'h3 == state ? validBits_107 : _GEN_766; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_921 = 3'h3 == state ? validBits_108 : _GEN_767; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_922 = 3'h3 == state ? validBits_109 : _GEN_768; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_923 = 3'h3 == state ? validBits_110 : _GEN_769; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_924 = 3'h3 == state ? validBits_111 : _GEN_770; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_925 = 3'h3 == state ? validBits_112 : _GEN_771; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_926 = 3'h3 == state ? validBits_113 : _GEN_772; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_927 = 3'h3 == state ? validBits_114 : _GEN_773; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_928 = 3'h3 == state ? validBits_115 : _GEN_774; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_929 = 3'h3 == state ? validBits_116 : _GEN_775; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_930 = 3'h3 == state ? validBits_117 : _GEN_776; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_931 = 3'h3 == state ? validBits_118 : _GEN_777; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_932 = 3'h3 == state ? validBits_119 : _GEN_778; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_933 = 3'h3 == state ? validBits_120 : _GEN_779; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_934 = 3'h3 == state ? validBits_121 : _GEN_780; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_935 = 3'h3 == state ? validBits_122 : _GEN_781; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_936 = 3'h3 == state ? validBits_123 : _GEN_782; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_937 = 3'h3 == state ? validBits_124 : _GEN_783; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_938 = 3'h3 == state ? validBits_125 : _GEN_784; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_939 = 3'h3 == state ? validBits_126 : _GEN_785; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_940 = 3'h3 == state ? validBits_127 : _GEN_786; // @[src/main/scala/cache/cache.scala 119:17 11:26]
  wire  _GEN_942 = 3'h3 == state ? 1'h0 : _GEN_789; // @[src/main/scala/cache/cache.scala 119:17 61:25]
  wire [31:0] _GEN_943 = 3'h3 == state ? 32'h0 : _GEN_790; // @[src/main/scala/cache/cache.scala 119:17 63:29]
  wire [31:0] _GEN_944 = 3'h3 == state ? 32'h0 : _GEN_791; // @[src/main/scala/cache/cache.scala 119:17 62:29]
  wire [3:0] _GEN_945 = 3'h3 == state ? 4'h0 : _GEN_792; // @[src/main/scala/cache/cache.scala 119:17 64:29]
  wire  _GEN_947 = 3'h3 == state ? 1'h0 : _GEN_794; // @[src/main/scala/cache/cache.scala 119:17 50:21]
  wire  _GEN_948 = 3'h2 == state ? 1'h0 : 3'h3 == state; // @[src/main/scala/cache/cache.scala 119:17 55:26]
  wire  _GEN_951 = 3'h2 == state ? 1'h0 : _GEN_798; // @[src/main/scala/cache/cache.scala 119:17 57:27]
  wire  _GEN_1095 = 3'h2 == state ? 1'h0 : _GEN_942; // @[src/main/scala/cache/cache.scala 119:17 61:25]
  wire [31:0] _GEN_1096 = 3'h2 == state ? 32'h0 : _GEN_943; // @[src/main/scala/cache/cache.scala 119:17 63:29]
  wire [31:0] _GEN_1097 = 3'h2 == state ? 32'h0 : _GEN_944; // @[src/main/scala/cache/cache.scala 119:17 62:29]
  wire [3:0] _GEN_1098 = 3'h2 == state ? 4'h0 : _GEN_945; // @[src/main/scala/cache/cache.scala 119:17 64:29]
  wire  _GEN_1100 = 3'h2 == state ? 1'h0 : _GEN_947; // @[src/main/scala/cache/cache.scala 119:17 50:21]
  wire  _GEN_1101 = 3'h1 == state & hit; // @[src/main/scala/cache/cache.scala 119:17 136:19 67:15]
  wire  _GEN_1102 = 3'h1 == state & ~hit; // @[src/main/scala/cache/cache.scala 119:17 137:20 68:16]
  wire  _GEN_1107 = 3'h1 == state ? 1'h0 : _GEN_948; // @[src/main/scala/cache/cache.scala 119:17 55:26]
  wire  _GEN_1109 = 3'h1 == state ? 1'h0 : _GEN_951; // @[src/main/scala/cache/cache.scala 119:17 57:27]
  wire  _GEN_1120 = 3'h1 == state ? 1'h0 : _GEN_960; // @[src/main/scala/cache/cache.scala 119:17 13:27]
  wire  _GEN_1251 = 3'h1 == state ? 1'h0 : _GEN_1095; // @[src/main/scala/cache/cache.scala 119:17 61:25]
  wire [31:0] _GEN_1252 = 3'h1 == state ? 32'h0 : _GEN_1096; // @[src/main/scala/cache/cache.scala 119:17 63:29]
  wire [31:0] _GEN_1253 = 3'h1 == state ? 32'h0 : _GEN_1097; // @[src/main/scala/cache/cache.scala 119:17 62:29]
  wire [3:0] _GEN_1254 = 3'h1 == state ? 4'h0 : _GEN_1098; // @[src/main/scala/cache/cache.scala 119:17 64:29]
  wire  _GEN_1256 = 3'h1 == state ? 1'h0 : _GEN_1100; // @[src/main/scala/cache/cache.scala 119:17 50:21]
  assign tagMem_tagRd_en = tagMem_tagRd_en_pipe_0;
  assign tagMem_tagRd_addr = tagMem_tagRd_addr_pipe_0;
  assign tagMem_tagRd_data = tagMem[tagMem_tagRd_addr]; // @[src/main/scala/cache/cache.scala 13:27]
  assign tagMem_MPORT_1_data = addrReg[31:12];
  assign tagMem_MPORT_1_addr = addrReg[11:5];
  assign tagMem_MPORT_1_mask = 1'h1;
  assign tagMem_MPORT_1_en = _T_2 ? 1'h0 : _GEN_1120;
  assign dataMem_lineRd_en = dataMem_lineRd_en_pipe_0;
  assign dataMem_lineRd_addr = dataMem_lineRd_addr_pipe_0;
  assign dataMem_lineRd_data = dataMem[dataMem_lineRd_addr]; // @[src/main/scala/cache/cache.scala 14:28]
  assign dataMem_MPORT_data = _T_2 ? 256'h0 : _GEN_1104;
  assign dataMem_MPORT_addr = addrReg[11:5];
  assign dataMem_MPORT_mask = 1'h1;
  assign dataMem_MPORT_en = _T_2 ? 1'h0 : _GEN_1103;
  assign io_cpu_req_ready = state == 3'h0; // @[src/main/scala/cache/cache.scala 37:29]
  assign io_cpu_resp_valid = 3'h0 == state ? 1'h0 : _GEN_1256; // @[src/main/scala/cache/cache.scala 119:17 50:21]
  assign io_cpu_resp_bits_data = respData; // @[src/main/scala/cache/cache.scala 51:25]
  assign io_mm_req_refill_valid = 3'h0 == state ? 1'h0 : _GEN_1107; // @[src/main/scala/cache/cache.scala 119:17 55:26]
  assign io_mm_req_refill_bits_addr = {addrReg[31:5],5'h0}; // @[src/main/scala/cache/model.scala 56:38]
  assign io_mm_data_refill_ready = 3'h0 == state ? 1'h0 : _GEN_1109; // @[src/main/scala/cache/cache.scala 119:17 57:27]
  assign io_mm_req_write_valid = 3'h0 == state ? 1'h0 : _GEN_1251; // @[src/main/scala/cache/cache.scala 119:17 61:25]
  assign io_mm_req_write_bits_addr = 3'h0 == state ? 32'h0 : _GEN_1252; // @[src/main/scala/cache/cache.scala 119:17 63:29]
  assign io_mm_req_write_bits_data = 3'h0 == state ? 32'h0 : _GEN_1253; // @[src/main/scala/cache/cache.scala 119:17 62:29]
  assign io_mm_req_write_bits_mask = 3'h0 == state ? 4'h0 : _GEN_1254; // @[src/main/scala/cache/cache.scala 119:17 64:29]
  assign io_stat_hit = 3'h0 == state ? 1'h0 : _GEN_1101; // @[src/main/scala/cache/cache.scala 119:17 67:15]
  assign io_stat_miss = 3'h0 == state ? 1'h0 : _GEN_1102; // @[src/main/scala/cache/cache.scala 119:17 68:16]
  always @(posedge clock) begin
    if (tagMem_MPORT_1_en & tagMem_MPORT_1_mask) begin
      tagMem[tagMem_MPORT_1_addr] <= tagMem_MPORT_1_data; // @[src/main/scala/cache/cache.scala 13:27]
    end
    tagMem_tagRd_en_pipe_0 <= io_cpu_req_ready & io_cpu_req_valid;
    if (io_cpu_req_ready & io_cpu_req_valid) begin
      tagMem_tagRd_addr_pipe_0 <= io_cpu_req_bits_addr[11:5];
    end
    if (dataMem_MPORT_en & dataMem_MPORT_mask) begin
      dataMem[dataMem_MPORT_addr] <= dataMem_MPORT_data; // @[src/main/scala/cache/cache.scala 14:28]
    end
    dataMem_lineRd_en_pipe_0 <= io_cpu_req_ready & io_cpu_req_valid;
    if (io_cpu_req_ready & io_cpu_req_valid) begin
      dataMem_lineRd_addr_pipe_0 <= io_cpu_req_bits_addr[11:5];
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_0 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_0 <= _GEN_813;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_1 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_1 <= _GEN_814;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_2 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_2 <= _GEN_815;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_3 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_3 <= _GEN_816;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_4 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_4 <= _GEN_817;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_5 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_5 <= _GEN_818;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_6 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_6 <= _GEN_819;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_7 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_7 <= _GEN_820;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_8 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_8 <= _GEN_821;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_9 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_9 <= _GEN_822;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_10 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_10 <= _GEN_823;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_11 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_11 <= _GEN_824;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_12 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_12 <= _GEN_825;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_13 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_13 <= _GEN_826;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_14 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_14 <= _GEN_827;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_15 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_15 <= _GEN_828;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_16 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_16 <= _GEN_829;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_17 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_17 <= _GEN_830;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_18 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_18 <= _GEN_831;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_19 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_19 <= _GEN_832;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_20 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_20 <= _GEN_833;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_21 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_21 <= _GEN_834;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_22 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_22 <= _GEN_835;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_23 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_23 <= _GEN_836;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_24 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_24 <= _GEN_837;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_25 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_25 <= _GEN_838;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_26 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_26 <= _GEN_839;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_27 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_27 <= _GEN_840;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_28 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_28 <= _GEN_841;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_29 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_29 <= _GEN_842;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_30 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_30 <= _GEN_843;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_31 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_31 <= _GEN_844;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_32 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_32 <= _GEN_845;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_33 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_33 <= _GEN_846;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_34 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_34 <= _GEN_847;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_35 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_35 <= _GEN_848;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_36 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_36 <= _GEN_849;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_37 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_37 <= _GEN_850;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_38 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_38 <= _GEN_851;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_39 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_39 <= _GEN_852;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_40 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_40 <= _GEN_853;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_41 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_41 <= _GEN_854;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_42 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_42 <= _GEN_855;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_43 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_43 <= _GEN_856;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_44 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_44 <= _GEN_857;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_45 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_45 <= _GEN_858;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_46 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_46 <= _GEN_859;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_47 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_47 <= _GEN_860;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_48 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_48 <= _GEN_861;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_49 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_49 <= _GEN_862;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_50 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_50 <= _GEN_863;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_51 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_51 <= _GEN_864;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_52 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_52 <= _GEN_865;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_53 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_53 <= _GEN_866;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_54 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_54 <= _GEN_867;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_55 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_55 <= _GEN_868;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_56 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_56 <= _GEN_869;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_57 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_57 <= _GEN_870;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_58 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_58 <= _GEN_871;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_59 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_59 <= _GEN_872;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_60 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_60 <= _GEN_873;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_61 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_61 <= _GEN_874;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_62 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_62 <= _GEN_875;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_63 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_63 <= _GEN_876;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_64 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_64 <= _GEN_877;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_65 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_65 <= _GEN_878;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_66 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_66 <= _GEN_879;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_67 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_67 <= _GEN_880;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_68 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_68 <= _GEN_881;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_69 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_69 <= _GEN_882;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_70 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_70 <= _GEN_883;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_71 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_71 <= _GEN_884;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_72 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_72 <= _GEN_885;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_73 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_73 <= _GEN_886;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_74 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_74 <= _GEN_887;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_75 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_75 <= _GEN_888;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_76 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_76 <= _GEN_889;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_77 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_77 <= _GEN_890;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_78 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_78 <= _GEN_891;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_79 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_79 <= _GEN_892;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_80 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_80 <= _GEN_893;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_81 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_81 <= _GEN_894;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_82 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_82 <= _GEN_895;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_83 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_83 <= _GEN_896;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_84 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_84 <= _GEN_897;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_85 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_85 <= _GEN_898;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_86 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_86 <= _GEN_899;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_87 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_87 <= _GEN_900;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_88 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_88 <= _GEN_901;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_89 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_89 <= _GEN_902;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_90 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_90 <= _GEN_903;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_91 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_91 <= _GEN_904;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_92 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_92 <= _GEN_905;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_93 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_93 <= _GEN_906;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_94 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_94 <= _GEN_907;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_95 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_95 <= _GEN_908;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_96 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_96 <= _GEN_909;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_97 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_97 <= _GEN_910;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_98 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_98 <= _GEN_911;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_99 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_99 <= _GEN_912;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_100 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_100 <= _GEN_913;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_101 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_101 <= _GEN_914;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_102 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_102 <= _GEN_915;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_103 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_103 <= _GEN_916;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_104 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_104 <= _GEN_917;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_105 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_105 <= _GEN_918;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_106 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_106 <= _GEN_919;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_107 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_107 <= _GEN_920;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_108 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_108 <= _GEN_921;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_109 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_109 <= _GEN_922;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_110 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_110 <= _GEN_923;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_111 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_111 <= _GEN_924;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_112 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_112 <= _GEN_925;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_113 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_113 <= _GEN_926;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_114 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_114 <= _GEN_927;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_115 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_115 <= _GEN_928;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_116 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_116 <= _GEN_929;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_117 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_117 <= _GEN_930;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_118 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_118 <= _GEN_931;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_119 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_119 <= _GEN_932;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_120 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_120 <= _GEN_933;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_121 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_121 <= _GEN_934;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_122 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_122 <= _GEN_935;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_123 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_123 <= _GEN_936;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_124 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_124 <= _GEN_937;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_125 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_125 <= _GEN_938;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_126 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_126 <= _GEN_939;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 11:26]
      validBits_127 <= 1'h0; // @[src/main/scala/cache/cache.scala 11:26]
    end else if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          validBits_127 <= _GEN_940;
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 17:22]
      state <= 3'h0; // @[src/main/scala/cache/cache.scala 17:22]
    end else if (3'h0 == state) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (_tagRd_T) begin // @[src/main/scala/cache/cache.scala 122:29]
        state <= 3'h1; // @[src/main/scala/cache/cache.scala 129:15]
      end
    end else if (3'h1 == state) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (hit) begin // @[src/main/scala/cache/cache.scala 140:17]
        state <= _GEN_173;
      end else begin
        state <= _GEN_175;
      end
    end else if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      state <= _GEN_797;
    end
    if (3'h0 == state) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (_tagRd_T) begin // @[src/main/scala/cache/cache.scala 122:29]
        addrReg <= io_cpu_req_bits_addr; // @[src/main/scala/cache/cache.scala 123:17]
      end
    end
    if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (3'h1 == state) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (hit) begin // @[src/main/scala/cache/cache.scala 140:17]
          if (!(writeReg)) begin // @[src/main/scala/cache/cache.scala 141:24]
            respData <= _GEN_154; // @[src/main/scala/cache/cache.scala 160:20]
          end
        end
      end else if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h3 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          respData <= _GEN_787;
        end
      end
    end
    if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          if (!(3'h3 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
            refillBuf_0 <= _GEN_644;
          end
        end
      end
    end
    if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          if (!(3'h3 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
            refillBuf_1 <= _GEN_645;
          end
        end
      end
    end
    if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          if (!(3'h3 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
            refillBuf_2 <= _GEN_646;
          end
        end
      end
    end
    if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          if (!(3'h3 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
            refillBuf_3 <= _GEN_647;
          end
        end
      end
    end
    if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          if (!(3'h3 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
            refillBuf_4 <= _GEN_648;
          end
        end
      end
    end
    if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          if (!(3'h3 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
            refillBuf_5 <= _GEN_649;
          end
        end
      end
    end
    if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          if (!(3'h3 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
            refillBuf_6 <= _GEN_650;
          end
        end
      end
    end
    if (!(3'h0 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
          if (!(3'h3 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
            refillBuf_7 <= _GEN_651;
          end
        end
      end
    end
    if (reset) begin // @[src/main/scala/cache/cache.scala 22:24]
      beatCnt <= 3'h0; // @[src/main/scala/cache/cache.scala 22:24]
    end else if (3'h0 == state) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (_tagRd_T) begin // @[src/main/scala/cache/cache.scala 122:29]
        beatCnt <= 3'h0; // @[src/main/scala/cache/cache.scala 128:17]
      end
    end else if (!(3'h1 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (!(3'h2 == state)) begin // @[src/main/scala/cache/cache.scala 119:17]
        beatCnt <= _GEN_796;
      end
    end
    if (3'h0 == state) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (_tagRd_T) begin // @[src/main/scala/cache/cache.scala 122:29]
        writeReg <= io_cpu_req_bits_write; // @[src/main/scala/cache/cache.scala 124:18]
      end
    end
    if (3'h0 == state) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (_tagRd_T) begin // @[src/main/scala/cache/cache.scala 122:29]
        wdataReg <= io_cpu_req_bits_wdata; // @[src/main/scala/cache/cache.scala 125:18]
      end
    end
    if (3'h0 == state) begin // @[src/main/scala/cache/cache.scala 119:17]
      if (_tagRd_T) begin // @[src/main/scala/cache/cache.scala 122:29]
        wmaskReg <= io_cpu_req_bits_wmask; // @[src/main/scala/cache/cache.scala 126:18]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    tagMem[initvar] = _RAND_0[19:0];
  _RAND_3 = {8{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    dataMem[initvar] = _RAND_3[255:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  tagMem_tagRd_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  tagMem_tagRd_addr_pipe_0 = _RAND_2[6:0];
  _RAND_4 = {1{`RANDOM}};
  dataMem_lineRd_en_pipe_0 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  dataMem_lineRd_addr_pipe_0 = _RAND_5[6:0];
  _RAND_6 = {1{`RANDOM}};
  validBits_0 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  validBits_1 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  validBits_2 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  validBits_3 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  validBits_4 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  validBits_5 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  validBits_6 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  validBits_7 = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  validBits_8 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  validBits_9 = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  validBits_10 = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  validBits_11 = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  validBits_12 = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  validBits_13 = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  validBits_14 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  validBits_15 = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  validBits_16 = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  validBits_17 = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  validBits_18 = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  validBits_19 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  validBits_20 = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  validBits_21 = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  validBits_22 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  validBits_23 = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  validBits_24 = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  validBits_25 = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  validBits_26 = _RAND_32[0:0];
  _RAND_33 = {1{`RANDOM}};
  validBits_27 = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  validBits_28 = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  validBits_29 = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  validBits_30 = _RAND_36[0:0];
  _RAND_37 = {1{`RANDOM}};
  validBits_31 = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  validBits_32 = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  validBits_33 = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  validBits_34 = _RAND_40[0:0];
  _RAND_41 = {1{`RANDOM}};
  validBits_35 = _RAND_41[0:0];
  _RAND_42 = {1{`RANDOM}};
  validBits_36 = _RAND_42[0:0];
  _RAND_43 = {1{`RANDOM}};
  validBits_37 = _RAND_43[0:0];
  _RAND_44 = {1{`RANDOM}};
  validBits_38 = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  validBits_39 = _RAND_45[0:0];
  _RAND_46 = {1{`RANDOM}};
  validBits_40 = _RAND_46[0:0];
  _RAND_47 = {1{`RANDOM}};
  validBits_41 = _RAND_47[0:0];
  _RAND_48 = {1{`RANDOM}};
  validBits_42 = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  validBits_43 = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  validBits_44 = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  validBits_45 = _RAND_51[0:0];
  _RAND_52 = {1{`RANDOM}};
  validBits_46 = _RAND_52[0:0];
  _RAND_53 = {1{`RANDOM}};
  validBits_47 = _RAND_53[0:0];
  _RAND_54 = {1{`RANDOM}};
  validBits_48 = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  validBits_49 = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  validBits_50 = _RAND_56[0:0];
  _RAND_57 = {1{`RANDOM}};
  validBits_51 = _RAND_57[0:0];
  _RAND_58 = {1{`RANDOM}};
  validBits_52 = _RAND_58[0:0];
  _RAND_59 = {1{`RANDOM}};
  validBits_53 = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  validBits_54 = _RAND_60[0:0];
  _RAND_61 = {1{`RANDOM}};
  validBits_55 = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  validBits_56 = _RAND_62[0:0];
  _RAND_63 = {1{`RANDOM}};
  validBits_57 = _RAND_63[0:0];
  _RAND_64 = {1{`RANDOM}};
  validBits_58 = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  validBits_59 = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  validBits_60 = _RAND_66[0:0];
  _RAND_67 = {1{`RANDOM}};
  validBits_61 = _RAND_67[0:0];
  _RAND_68 = {1{`RANDOM}};
  validBits_62 = _RAND_68[0:0];
  _RAND_69 = {1{`RANDOM}};
  validBits_63 = _RAND_69[0:0];
  _RAND_70 = {1{`RANDOM}};
  validBits_64 = _RAND_70[0:0];
  _RAND_71 = {1{`RANDOM}};
  validBits_65 = _RAND_71[0:0];
  _RAND_72 = {1{`RANDOM}};
  validBits_66 = _RAND_72[0:0];
  _RAND_73 = {1{`RANDOM}};
  validBits_67 = _RAND_73[0:0];
  _RAND_74 = {1{`RANDOM}};
  validBits_68 = _RAND_74[0:0];
  _RAND_75 = {1{`RANDOM}};
  validBits_69 = _RAND_75[0:0];
  _RAND_76 = {1{`RANDOM}};
  validBits_70 = _RAND_76[0:0];
  _RAND_77 = {1{`RANDOM}};
  validBits_71 = _RAND_77[0:0];
  _RAND_78 = {1{`RANDOM}};
  validBits_72 = _RAND_78[0:0];
  _RAND_79 = {1{`RANDOM}};
  validBits_73 = _RAND_79[0:0];
  _RAND_80 = {1{`RANDOM}};
  validBits_74 = _RAND_80[0:0];
  _RAND_81 = {1{`RANDOM}};
  validBits_75 = _RAND_81[0:0];
  _RAND_82 = {1{`RANDOM}};
  validBits_76 = _RAND_82[0:0];
  _RAND_83 = {1{`RANDOM}};
  validBits_77 = _RAND_83[0:0];
  _RAND_84 = {1{`RANDOM}};
  validBits_78 = _RAND_84[0:0];
  _RAND_85 = {1{`RANDOM}};
  validBits_79 = _RAND_85[0:0];
  _RAND_86 = {1{`RANDOM}};
  validBits_80 = _RAND_86[0:0];
  _RAND_87 = {1{`RANDOM}};
  validBits_81 = _RAND_87[0:0];
  _RAND_88 = {1{`RANDOM}};
  validBits_82 = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  validBits_83 = _RAND_89[0:0];
  _RAND_90 = {1{`RANDOM}};
  validBits_84 = _RAND_90[0:0];
  _RAND_91 = {1{`RANDOM}};
  validBits_85 = _RAND_91[0:0];
  _RAND_92 = {1{`RANDOM}};
  validBits_86 = _RAND_92[0:0];
  _RAND_93 = {1{`RANDOM}};
  validBits_87 = _RAND_93[0:0];
  _RAND_94 = {1{`RANDOM}};
  validBits_88 = _RAND_94[0:0];
  _RAND_95 = {1{`RANDOM}};
  validBits_89 = _RAND_95[0:0];
  _RAND_96 = {1{`RANDOM}};
  validBits_90 = _RAND_96[0:0];
  _RAND_97 = {1{`RANDOM}};
  validBits_91 = _RAND_97[0:0];
  _RAND_98 = {1{`RANDOM}};
  validBits_92 = _RAND_98[0:0];
  _RAND_99 = {1{`RANDOM}};
  validBits_93 = _RAND_99[0:0];
  _RAND_100 = {1{`RANDOM}};
  validBits_94 = _RAND_100[0:0];
  _RAND_101 = {1{`RANDOM}};
  validBits_95 = _RAND_101[0:0];
  _RAND_102 = {1{`RANDOM}};
  validBits_96 = _RAND_102[0:0];
  _RAND_103 = {1{`RANDOM}};
  validBits_97 = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  validBits_98 = _RAND_104[0:0];
  _RAND_105 = {1{`RANDOM}};
  validBits_99 = _RAND_105[0:0];
  _RAND_106 = {1{`RANDOM}};
  validBits_100 = _RAND_106[0:0];
  _RAND_107 = {1{`RANDOM}};
  validBits_101 = _RAND_107[0:0];
  _RAND_108 = {1{`RANDOM}};
  validBits_102 = _RAND_108[0:0];
  _RAND_109 = {1{`RANDOM}};
  validBits_103 = _RAND_109[0:0];
  _RAND_110 = {1{`RANDOM}};
  validBits_104 = _RAND_110[0:0];
  _RAND_111 = {1{`RANDOM}};
  validBits_105 = _RAND_111[0:0];
  _RAND_112 = {1{`RANDOM}};
  validBits_106 = _RAND_112[0:0];
  _RAND_113 = {1{`RANDOM}};
  validBits_107 = _RAND_113[0:0];
  _RAND_114 = {1{`RANDOM}};
  validBits_108 = _RAND_114[0:0];
  _RAND_115 = {1{`RANDOM}};
  validBits_109 = _RAND_115[0:0];
  _RAND_116 = {1{`RANDOM}};
  validBits_110 = _RAND_116[0:0];
  _RAND_117 = {1{`RANDOM}};
  validBits_111 = _RAND_117[0:0];
  _RAND_118 = {1{`RANDOM}};
  validBits_112 = _RAND_118[0:0];
  _RAND_119 = {1{`RANDOM}};
  validBits_113 = _RAND_119[0:0];
  _RAND_120 = {1{`RANDOM}};
  validBits_114 = _RAND_120[0:0];
  _RAND_121 = {1{`RANDOM}};
  validBits_115 = _RAND_121[0:0];
  _RAND_122 = {1{`RANDOM}};
  validBits_116 = _RAND_122[0:0];
  _RAND_123 = {1{`RANDOM}};
  validBits_117 = _RAND_123[0:0];
  _RAND_124 = {1{`RANDOM}};
  validBits_118 = _RAND_124[0:0];
  _RAND_125 = {1{`RANDOM}};
  validBits_119 = _RAND_125[0:0];
  _RAND_126 = {1{`RANDOM}};
  validBits_120 = _RAND_126[0:0];
  _RAND_127 = {1{`RANDOM}};
  validBits_121 = _RAND_127[0:0];
  _RAND_128 = {1{`RANDOM}};
  validBits_122 = _RAND_128[0:0];
  _RAND_129 = {1{`RANDOM}};
  validBits_123 = _RAND_129[0:0];
  _RAND_130 = {1{`RANDOM}};
  validBits_124 = _RAND_130[0:0];
  _RAND_131 = {1{`RANDOM}};
  validBits_125 = _RAND_131[0:0];
  _RAND_132 = {1{`RANDOM}};
  validBits_126 = _RAND_132[0:0];
  _RAND_133 = {1{`RANDOM}};
  validBits_127 = _RAND_133[0:0];
  _RAND_134 = {1{`RANDOM}};
  state = _RAND_134[2:0];
  _RAND_135 = {1{`RANDOM}};
  addrReg = _RAND_135[31:0];
  _RAND_136 = {1{`RANDOM}};
  respData = _RAND_136[31:0];
  _RAND_137 = {1{`RANDOM}};
  refillBuf_0 = _RAND_137[31:0];
  _RAND_138 = {1{`RANDOM}};
  refillBuf_1 = _RAND_138[31:0];
  _RAND_139 = {1{`RANDOM}};
  refillBuf_2 = _RAND_139[31:0];
  _RAND_140 = {1{`RANDOM}};
  refillBuf_3 = _RAND_140[31:0];
  _RAND_141 = {1{`RANDOM}};
  refillBuf_4 = _RAND_141[31:0];
  _RAND_142 = {1{`RANDOM}};
  refillBuf_5 = _RAND_142[31:0];
  _RAND_143 = {1{`RANDOM}};
  refillBuf_6 = _RAND_143[31:0];
  _RAND_144 = {1{`RANDOM}};
  refillBuf_7 = _RAND_144[31:0];
  _RAND_145 = {1{`RANDOM}};
  beatCnt = _RAND_145[2:0];
  _RAND_146 = {1{`RANDOM}};
  writeReg = _RAND_146[0:0];
  _RAND_147 = {1{`RANDOM}};
  wdataReg = _RAND_147[31:0];
  _RAND_148 = {1{`RANDOM}};
  wmaskReg = _RAND_148[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CacheAdapter(
  input         clock,
  input         reset,
  input  [31:0] cpuPort_address, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input         cpuPort_rd, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input         cpuPort_wr, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output [31:0] cpuPort_rdData, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input  [31:0] cpuPort_wrData, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input  [3:0]  cpuPort_wrMask, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output        cpuPort_ack, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output [31:0] mem_port_address, // @[src/main/scala/adapter/cache_adapter.scala 22:20]
  output        mem_port_rd, // @[src/main/scala/adapter/cache_adapter.scala 22:20]
  output        mem_port_wr, // @[src/main/scala/adapter/cache_adapter.scala 22:20]
  input  [31:0] mem_port_rdData, // @[src/main/scala/adapter/cache_adapter.scala 22:20]
  output [31:0] mem_port_wrData, // @[src/main/scala/adapter/cache_adapter.scala 22:20]
  output [3:0]  mem_port_wrMask, // @[src/main/scala/adapter/cache_adapter.scala 22:20]
  input         mem_port_ack, // @[src/main/scala/adapter/cache_adapter.scala 22:20]
  output        debug_hit, // @[src/main/scala/adapter/cache_adapter.scala 29:21]
  output        debug_miss // @[src/main/scala/adapter/cache_adapter.scala 30:22]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  wire  cache_clock; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_reset; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_cpu_req_ready; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_cpu_req_valid; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire [31:0] cache_io_cpu_req_bits_addr; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_cpu_req_bits_write; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire [31:0] cache_io_cpu_req_bits_wdata; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire [3:0] cache_io_cpu_req_bits_wmask; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_cpu_resp_ready; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_cpu_resp_valid; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire [31:0] cache_io_cpu_resp_bits_data; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_mm_req_refill_ready; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_mm_req_refill_valid; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire [31:0] cache_io_mm_req_refill_bits_addr; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_mm_data_refill_ready; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_mm_data_refill_valid; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire [31:0] cache_io_mm_data_refill_bits_data; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_mm_req_write_ready; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_mm_req_write_valid; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire [31:0] cache_io_mm_req_write_bits_addr; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire [31:0] cache_io_mm_req_write_bits_data; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire [3:0] cache_io_mm_req_write_bits_mask; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_stat_hit; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  wire  cache_io_stat_miss; // @[src/main/scala/adapter/cache_adapter.scala 21:21]
  reg  cpu_state; // @[src/main/scala/adapter/cache_adapter.scala 40:26]
  reg [31:0] req_reg_addr; // @[src/main/scala/adapter/cache_adapter.scala 41:20]
  reg  req_reg_write; // @[src/main/scala/adapter/cache_adapter.scala 41:20]
  reg [31:0] req_reg_wdata; // @[src/main/scala/adapter/cache_adapter.scala 41:20]
  reg [3:0] req_reg_wmask; // @[src/main/scala/adapter/cache_adapter.scala 41:20]
  reg  req_sent; // @[src/main/scala/adapter/cache_adapter.scala 42:25]
  wire  _cache_io_cpu_req_bits_T = ~cpu_state; // @[src/main/scala/adapter/cache_adapter.scala 52:42]
  wire  _T_1 = cpuPort_rd | cpuPort_wr; // @[src/main/scala/adapter/cache_adapter.scala 62:23]
  wire  _GEN_6 = cpuPort_rd | cpuPort_wr | cpu_state; // @[src/main/scala/adapter/cache_adapter.scala 62:38 66:19 40:26]
  wire  _T_3 = ~req_sent; // @[src/main/scala/adapter/cache_adapter.scala 70:12]
  wire  _GEN_7 = cache_io_cpu_req_ready | req_sent; // @[src/main/scala/adapter/cache_adapter.scala 72:38 73:20 42:25]
  wire  _GEN_9 = ~req_sent ? _GEN_7 : req_sent; // @[src/main/scala/adapter/cache_adapter.scala 70:23 42:25]
  wire  _GEN_10 = cache_io_cpu_resp_valid; // @[src/main/scala/adapter/cache_adapter.scala 56:15 77:37 78:21]
  wire  _GEN_13 = cpu_state & _T_3; // @[src/main/scala/adapter/cache_adapter.scala 60:21 51:26]
  reg [1:0] mem_state; // @[src/main/scala/adapter/cache_adapter.scala 87:26]
  reg [31:0] base_reg; // @[src/main/scala/adapter/cache_adapter.scala 88:21]
  reg [2:0] beat_cnt; // @[src/main/scala/adapter/cache_adapter.scala 89:25]
  reg [31:0] data_reg; // @[src/main/scala/adapter/cache_adapter.scala 90:21]
  wire  last_beat = beat_cnt == 3'h7; // @[src/main/scala/adapter/cache_adapter.scala 103:28]
  wire  _GEN_29 = cache_io_mm_req_refill_valid; // @[src/main/scala/adapter/cache_adapter.scala 116:44 119:23 97:15]
  wire [31:0] _GEN_30 = cache_io_mm_req_refill_valid ? cache_io_mm_req_refill_bits_addr : 32'h0; // @[src/main/scala/adapter/cache_adapter.scala 116:44 120:28 99:20]
  wire  _GEN_32 = cache_io_mm_req_write_valid; // @[src/main/scala/adapter/cache_adapter.scala 108:41 109:21 98:15]
  wire [31:0] _GEN_33 = cache_io_mm_req_write_valid ? cache_io_mm_req_write_bits_addr : _GEN_30; // @[src/main/scala/adapter/cache_adapter.scala 108:41 110:26]
  wire [31:0] _GEN_34 = cache_io_mm_req_write_valid ? cache_io_mm_req_write_bits_data : 32'h0; // @[src/main/scala/adapter/cache_adapter.scala 100:19 108:41 111:25]
  wire [3:0] _GEN_35 = cache_io_mm_req_write_valid ? cache_io_mm_req_write_bits_mask : 4'h0; // @[src/main/scala/adapter/cache_adapter.scala 101:19 108:41 112:25]
  wire  _GEN_37 = cache_io_mm_req_write_valid ? 1'h0 : 1'h1; // @[src/main/scala/adapter/cache_adapter.scala 108:41 92:32 115:38]
  wire  _GEN_40 = cache_io_mm_req_write_valid ? 1'h0 : _GEN_29; // @[src/main/scala/adapter/cache_adapter.scala 108:41 97:15]
  wire [1:0] _GEN_44 = mem_port_ack ? 2'h2 : mem_state; // @[src/main/scala/adapter/cache_adapter.scala 132:26 134:19 87:26]
  wire [2:0] next = beat_cnt + 3'h1; // @[src/main/scala/adapter/cache_adapter.scala 143:31]
  wire [4:0] _mem_port_address_T = {next, 2'h0}; // @[src/main/scala/adapter/cache_adapter.scala 146:48]
  wire [31:0] _GEN_83 = {{27'd0}, _mem_port_address_T}; // @[src/main/scala/adapter/cache_adapter.scala 146:40]
  wire [31:0] _mem_port_address_T_2 = base_reg + _GEN_83; // @[src/main/scala/adapter/cache_adapter.scala 146:40]
  wire [1:0] _GEN_45 = last_beat ? 2'h0 : 2'h1; // @[src/main/scala/adapter/cache_adapter.scala 140:25 141:21 147:21]
  wire [2:0] _GEN_46 = last_beat ? beat_cnt : next; // @[src/main/scala/adapter/cache_adapter.scala 140:25 144:20 89:25]
  wire  _GEN_47 = last_beat ? 1'h0 : 1'h1; // @[src/main/scala/adapter/cache_adapter.scala 140:25 97:15 145:23]
  wire [31:0] _GEN_48 = last_beat ? 32'h0 : _mem_port_address_T_2; // @[src/main/scala/adapter/cache_adapter.scala 140:25 99:20 146:28]
  wire [1:0] _GEN_49 = cache_io_mm_data_refill_ready ? _GEN_45 : mem_state; // @[src/main/scala/adapter/cache_adapter.scala 139:43 87:26]
  wire [2:0] _GEN_50 = cache_io_mm_data_refill_ready ? _GEN_46 : beat_cnt; // @[src/main/scala/adapter/cache_adapter.scala 139:43 89:25]
  wire  _GEN_51 = cache_io_mm_data_refill_ready & _GEN_47; // @[src/main/scala/adapter/cache_adapter.scala 139:43 97:15]
  wire [31:0] _GEN_52 = cache_io_mm_data_refill_ready ? _GEN_48 : 32'h0; // @[src/main/scala/adapter/cache_adapter.scala 139:43 99:20]
  wire [1:0] _GEN_54 = 2'h2 == mem_state ? _GEN_49 : mem_state; // @[src/main/scala/adapter/cache_adapter.scala 106:21 87:26]
  wire [2:0] _GEN_55 = 2'h2 == mem_state ? _GEN_50 : beat_cnt; // @[src/main/scala/adapter/cache_adapter.scala 106:21 89:25]
  wire [31:0] _GEN_57 = 2'h2 == mem_state ? _GEN_52 : 32'h0; // @[src/main/scala/adapter/cache_adapter.scala 106:21 99:20]
  wire  _GEN_60 = 2'h1 == mem_state ? 1'h0 : 2'h2 == mem_state; // @[src/main/scala/adapter/cache_adapter.scala 106:21 93:33]
  wire  _GEN_62 = 2'h1 == mem_state ? 1'h0 : 2'h2 == mem_state & _GEN_51; // @[src/main/scala/adapter/cache_adapter.scala 106:21 97:15]
  wire [31:0] _GEN_63 = 2'h1 == mem_state ? 32'h0 : _GEN_57; // @[src/main/scala/adapter/cache_adapter.scala 106:21 99:20]
  wire  _GEN_67 = 2'h3 == mem_state ? 1'h0 : _GEN_60; // @[src/main/scala/adapter/cache_adapter.scala 106:21 93:33]
  wire  _GEN_69 = 2'h3 == mem_state ? 1'h0 : _GEN_62; // @[src/main/scala/adapter/cache_adapter.scala 106:21 97:15]
  wire [31:0] _GEN_70 = 2'h3 == mem_state ? 32'h0 : _GEN_63; // @[src/main/scala/adapter/cache_adapter.scala 106:21 99:20]
  DirectMappedReadCache cache ( // @[src/main/scala/adapter/cache_adapter.scala 21:21]
    .clock(cache_clock),
    .reset(cache_reset),
    .io_cpu_req_ready(cache_io_cpu_req_ready),
    .io_cpu_req_valid(cache_io_cpu_req_valid),
    .io_cpu_req_bits_addr(cache_io_cpu_req_bits_addr),
    .io_cpu_req_bits_write(cache_io_cpu_req_bits_write),
    .io_cpu_req_bits_wdata(cache_io_cpu_req_bits_wdata),
    .io_cpu_req_bits_wmask(cache_io_cpu_req_bits_wmask),
    .io_cpu_resp_ready(cache_io_cpu_resp_ready),
    .io_cpu_resp_valid(cache_io_cpu_resp_valid),
    .io_cpu_resp_bits_data(cache_io_cpu_resp_bits_data),
    .io_mm_req_refill_ready(cache_io_mm_req_refill_ready),
    .io_mm_req_refill_valid(cache_io_mm_req_refill_valid),
    .io_mm_req_refill_bits_addr(cache_io_mm_req_refill_bits_addr),
    .io_mm_data_refill_ready(cache_io_mm_data_refill_ready),
    .io_mm_data_refill_valid(cache_io_mm_data_refill_valid),
    .io_mm_data_refill_bits_data(cache_io_mm_data_refill_bits_data),
    .io_mm_req_write_ready(cache_io_mm_req_write_ready),
    .io_mm_req_write_valid(cache_io_mm_req_write_valid),
    .io_mm_req_write_bits_addr(cache_io_mm_req_write_bits_addr),
    .io_mm_req_write_bits_data(cache_io_mm_req_write_bits_data),
    .io_mm_req_write_bits_mask(cache_io_mm_req_write_bits_mask),
    .io_stat_hit(cache_io_stat_hit),
    .io_stat_miss(cache_io_stat_miss)
  );
  assign cpuPort_rdData = cache_io_cpu_resp_bits_data; // @[src/main/scala/adapter/cache_adapter.scala 55:18]
  assign cpuPort_ack = _cache_io_cpu_req_bits_T ? 1'h0 : cpu_state & _GEN_10; // @[src/main/scala/adapter/cache_adapter.scala 56:15 60:21]
  assign mem_port_address = 2'h0 == mem_state ? _GEN_33 : _GEN_70; // @[src/main/scala/adapter/cache_adapter.scala 106:21]
  assign mem_port_rd = 2'h0 == mem_state ? _GEN_40 : _GEN_69; // @[src/main/scala/adapter/cache_adapter.scala 106:21]
  assign mem_port_wr = 2'h0 == mem_state & _GEN_32; // @[src/main/scala/adapter/cache_adapter.scala 106:21 98:15]
  assign mem_port_wrData = 2'h0 == mem_state ? _GEN_34 : 32'h0; // @[src/main/scala/adapter/cache_adapter.scala 100:19 106:21]
  assign mem_port_wrMask = 2'h0 == mem_state ? _GEN_35 : 4'h0; // @[src/main/scala/adapter/cache_adapter.scala 101:19 106:21]
  assign debug_hit = cache_io_stat_hit; // @[src/main/scala/adapter/cache_adapter.scala 33:13]
  assign debug_miss = cache_io_stat_miss; // @[src/main/scala/adapter/cache_adapter.scala 34:14]
  assign cache_clock = clock;
  assign cache_reset = reset;
  assign cache_io_cpu_req_valid = _cache_io_cpu_req_bits_T ? _T_1 : _GEN_13; // @[src/main/scala/adapter/cache_adapter.scala 60:21]
  assign cache_io_cpu_req_bits_addr = ~cpu_state ? cpuPort_address : req_reg_addr; // @[src/main/scala/adapter/cache_adapter.scala 52:31]
  assign cache_io_cpu_req_bits_write = ~cpu_state ? cpuPort_wr : req_reg_write; // @[src/main/scala/adapter/cache_adapter.scala 52:31]
  assign cache_io_cpu_req_bits_wdata = ~cpu_state ? cpuPort_wrData : req_reg_wdata; // @[src/main/scala/adapter/cache_adapter.scala 52:31]
  assign cache_io_cpu_req_bits_wmask = ~cpu_state ? cpuPort_wrMask : req_reg_wmask; // @[src/main/scala/adapter/cache_adapter.scala 52:31]
  assign cache_io_cpu_resp_ready = _cache_io_cpu_req_bits_T ? 1'h0 : cpu_state; // @[src/main/scala/adapter/cache_adapter.scala 60:21 53:27]
  assign cache_io_mm_req_refill_ready = 2'h0 == mem_state & _GEN_37; // @[src/main/scala/adapter/cache_adapter.scala 106:21 92:32]
  assign cache_io_mm_data_refill_valid = 2'h0 == mem_state ? 1'h0 : _GEN_67; // @[src/main/scala/adapter/cache_adapter.scala 106:21 93:33]
  assign cache_io_mm_data_refill_bits_data = data_reg; // @[src/main/scala/adapter/cache_adapter.scala 94:37]
  assign cache_io_mm_req_write_ready = 2'h0 == mem_state ? 1'h0 : 2'h3 == mem_state & mem_port_ack; // @[src/main/scala/adapter/cache_adapter.scala 106:21 95:31]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/adapter/cache_adapter.scala 40:26]
      cpu_state <= 1'h0; // @[src/main/scala/adapter/cache_adapter.scala 40:26]
    end else if (_cache_io_cpu_req_bits_T) begin // @[src/main/scala/adapter/cache_adapter.scala 60:21]
      cpu_state <= _GEN_6;
    end else if (cpu_state) begin // @[src/main/scala/adapter/cache_adapter.scala 60:21]
      if (cache_io_cpu_resp_valid) begin // @[src/main/scala/adapter/cache_adapter.scala 77:37]
        cpu_state <= 1'h0; // @[src/main/scala/adapter/cache_adapter.scala 80:19]
      end
    end
    if (_cache_io_cpu_req_bits_T) begin // @[src/main/scala/adapter/cache_adapter.scala 60:21]
      if (cpuPort_rd | cpuPort_wr) begin // @[src/main/scala/adapter/cache_adapter.scala 62:38]
        req_reg_addr <= cpuPort_address; // @[src/main/scala/adapter/cache_adapter.scala 63:17]
      end
    end
    if (_cache_io_cpu_req_bits_T) begin // @[src/main/scala/adapter/cache_adapter.scala 60:21]
      if (cpuPort_rd | cpuPort_wr) begin // @[src/main/scala/adapter/cache_adapter.scala 62:38]
        req_reg_write <= cpuPort_wr; // @[src/main/scala/adapter/cache_adapter.scala 63:17]
      end
    end
    if (_cache_io_cpu_req_bits_T) begin // @[src/main/scala/adapter/cache_adapter.scala 60:21]
      if (cpuPort_rd | cpuPort_wr) begin // @[src/main/scala/adapter/cache_adapter.scala 62:38]
        req_reg_wdata <= cpuPort_wrData; // @[src/main/scala/adapter/cache_adapter.scala 63:17]
      end
    end
    if (_cache_io_cpu_req_bits_T) begin // @[src/main/scala/adapter/cache_adapter.scala 60:21]
      if (cpuPort_rd | cpuPort_wr) begin // @[src/main/scala/adapter/cache_adapter.scala 62:38]
        req_reg_wmask <= cpuPort_wrMask; // @[src/main/scala/adapter/cache_adapter.scala 63:17]
      end
    end
    if (reset) begin // @[src/main/scala/adapter/cache_adapter.scala 42:25]
      req_sent <= 1'h0; // @[src/main/scala/adapter/cache_adapter.scala 42:25]
    end else if (_cache_io_cpu_req_bits_T) begin // @[src/main/scala/adapter/cache_adapter.scala 60:21]
      if (cpuPort_rd | cpuPort_wr) begin // @[src/main/scala/adapter/cache_adapter.scala 62:38]
        req_sent <= cache_io_cpu_req_ready; // @[src/main/scala/adapter/cache_adapter.scala 65:18]
      end
    end else if (cpu_state) begin // @[src/main/scala/adapter/cache_adapter.scala 60:21]
      if (cache_io_cpu_resp_valid) begin // @[src/main/scala/adapter/cache_adapter.scala 77:37]
        req_sent <= 1'h0; // @[src/main/scala/adapter/cache_adapter.scala 79:18]
      end else begin
        req_sent <= _GEN_9;
      end
    end
    if (reset) begin // @[src/main/scala/adapter/cache_adapter.scala 87:26]
      mem_state <= 2'h0; // @[src/main/scala/adapter/cache_adapter.scala 87:26]
    end else if (2'h0 == mem_state) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
      if (cache_io_mm_req_write_valid) begin // @[src/main/scala/adapter/cache_adapter.scala 108:41]
        mem_state <= 2'h3; // @[src/main/scala/adapter/cache_adapter.scala 113:19]
      end else if (cache_io_mm_req_refill_valid) begin // @[src/main/scala/adapter/cache_adapter.scala 116:44]
        mem_state <= 2'h1; // @[src/main/scala/adapter/cache_adapter.scala 121:21]
      end
    end else if (2'h3 == mem_state) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
      if (mem_port_ack) begin // @[src/main/scala/adapter/cache_adapter.scala 126:26]
        mem_state <= 2'h0; // @[src/main/scala/adapter/cache_adapter.scala 128:19]
      end
    end else if (2'h1 == mem_state) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
      mem_state <= _GEN_44;
    end else begin
      mem_state <= _GEN_54;
    end
    if (2'h0 == mem_state) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
      if (!(cache_io_mm_req_write_valid)) begin // @[src/main/scala/adapter/cache_adapter.scala 108:41]
        if (cache_io_mm_req_refill_valid) begin // @[src/main/scala/adapter/cache_adapter.scala 116:44]
          base_reg <= cache_io_mm_req_refill_bits_addr; // @[src/main/scala/adapter/cache_adapter.scala 117:20]
        end
      end
    end
    if (reset) begin // @[src/main/scala/adapter/cache_adapter.scala 89:25]
      beat_cnt <= 3'h0; // @[src/main/scala/adapter/cache_adapter.scala 89:25]
    end else if (2'h0 == mem_state) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
      if (!(cache_io_mm_req_write_valid)) begin // @[src/main/scala/adapter/cache_adapter.scala 108:41]
        if (cache_io_mm_req_refill_valid) begin // @[src/main/scala/adapter/cache_adapter.scala 116:44]
          beat_cnt <= 3'h0; // @[src/main/scala/adapter/cache_adapter.scala 118:20]
        end
      end
    end else if (!(2'h3 == mem_state)) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
      if (!(2'h1 == mem_state)) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
        beat_cnt <= _GEN_55;
      end
    end
    if (!(2'h0 == mem_state)) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
      if (!(2'h3 == mem_state)) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
        if (2'h1 == mem_state) begin // @[src/main/scala/adapter/cache_adapter.scala 106:21]
          if (mem_port_ack) begin // @[src/main/scala/adapter/cache_adapter.scala 132:26]
            data_reg <= mem_port_rdData; // @[src/main/scala/adapter/cache_adapter.scala 133:18]
          end
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cpu_state = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  req_reg_addr = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  req_reg_write = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  req_reg_wdata = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  req_reg_wmask = _RAND_4[3:0];
  _RAND_5 = {1{`RANDOM}};
  req_sent = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  mem_state = _RAND_6[1:0];
  _RAND_7 = {1{`RANDOM}};
  base_reg = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  beat_cnt = _RAND_8[2:0];
  _RAND_9 = {1{`RANDOM}};
  data_reg = _RAND_9[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ScratchPadMem(
  input         clock,
  input         reset,
  input  [31:0] cpuPort_address, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input         cpuPort_rd, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input         cpuPort_wr, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output [31:0] cpuPort_rdData, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input  [31:0] cpuPort_wrData, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input  [3:0]  cpuPort_wrMask, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output        cpuPort_ack // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] MEM [0:4095]; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
  wire  MEM_cpuPort_rdData_MPORT_3_en; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
  wire [11:0] MEM_cpuPort_rdData_MPORT_3_addr; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
  wire [7:0] MEM_cpuPort_rdData_MPORT_3_data; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
  wire [7:0] MEM_MPORT_data; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
  wire [11:0] MEM_MPORT_addr; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
  wire  MEM_MPORT_mask; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
  wire  MEM_MPORT_en; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
  reg  MEM_cpuPort_rdData_MPORT_3_en_pipe_0;
  reg [11:0] MEM_cpuPort_rdData_MPORT_3_addr_pipe_0;
  reg [7:0] MEM_1 [0:4095]; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
  wire  MEM_1_cpuPort_rdData_MPORT_2_en; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
  wire [11:0] MEM_1_cpuPort_rdData_MPORT_2_addr; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
  wire [7:0] MEM_1_cpuPort_rdData_MPORT_2_data; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
  wire [7:0] MEM_1_MPORT_1_data; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
  wire [11:0] MEM_1_MPORT_1_addr; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
  wire  MEM_1_MPORT_1_mask; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
  wire  MEM_1_MPORT_1_en; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
  reg  MEM_1_cpuPort_rdData_MPORT_2_en_pipe_0;
  reg [11:0] MEM_1_cpuPort_rdData_MPORT_2_addr_pipe_0;
  reg [7:0] MEM_2 [0:4095]; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
  wire  MEM_2_cpuPort_rdData_MPORT_1_en; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
  wire [11:0] MEM_2_cpuPort_rdData_MPORT_1_addr; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
  wire [7:0] MEM_2_cpuPort_rdData_MPORT_1_data; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
  wire [7:0] MEM_2_MPORT_2_data; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
  wire [11:0] MEM_2_MPORT_2_addr; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
  wire  MEM_2_MPORT_2_mask; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
  wire  MEM_2_MPORT_2_en; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
  reg  MEM_2_cpuPort_rdData_MPORT_1_en_pipe_0;
  reg [11:0] MEM_2_cpuPort_rdData_MPORT_1_addr_pipe_0;
  reg [7:0] MEM_3 [0:4095]; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
  wire  MEM_3_cpuPort_rdData_MPORT_en; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
  wire [11:0] MEM_3_cpuPort_rdData_MPORT_addr; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
  wire [7:0] MEM_3_cpuPort_rdData_MPORT_data; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
  wire [7:0] MEM_3_MPORT_3_data; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
  wire [11:0] MEM_3_MPORT_3_addr; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
  wire  MEM_3_MPORT_3_mask; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
  wire  MEM_3_MPORT_3_en; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
  reg  MEM_3_cpuPort_rdData_MPORT_en_pipe_0;
  reg [11:0] MEM_3_cpuPort_rdData_MPORT_addr_pipe_0;
  wire [23:0] _cpuPort_rdData_T_10 = {MEM_3_cpuPort_rdData_MPORT_data,MEM_2_cpuPort_rdData_MPORT_1_data,
    MEM_1_cpuPort_rdData_MPORT_2_data}; // @[src/main/scala/memory/ScratchPadMem.scala 58:45]
  reg  cpuPort_ack_REG; // @[src/main/scala/memory/ScratchPadMem.scala 73:25]
  assign MEM_cpuPort_rdData_MPORT_3_en = MEM_cpuPort_rdData_MPORT_3_en_pipe_0;
  assign MEM_cpuPort_rdData_MPORT_3_addr = MEM_cpuPort_rdData_MPORT_3_addr_pipe_0;
  assign MEM_cpuPort_rdData_MPORT_3_data = MEM[MEM_cpuPort_rdData_MPORT_3_addr]; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
  assign MEM_MPORT_data = cpuPort_wrData[7:0];
  assign MEM_MPORT_addr = cpuPort_address[13:2];
  assign MEM_MPORT_mask = 1'h1;
  assign MEM_MPORT_en = cpuPort_wrMask[0] & cpuPort_wr;
  assign MEM_1_cpuPort_rdData_MPORT_2_en = MEM_1_cpuPort_rdData_MPORT_2_en_pipe_0;
  assign MEM_1_cpuPort_rdData_MPORT_2_addr = MEM_1_cpuPort_rdData_MPORT_2_addr_pipe_0;
  assign MEM_1_cpuPort_rdData_MPORT_2_data = MEM_1[MEM_1_cpuPort_rdData_MPORT_2_addr]; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
  assign MEM_1_MPORT_1_data = cpuPort_wrData[15:8];
  assign MEM_1_MPORT_1_addr = cpuPort_address[13:2];
  assign MEM_1_MPORT_1_mask = 1'h1;
  assign MEM_1_MPORT_1_en = cpuPort_wrMask[1] & cpuPort_wr;
  assign MEM_2_cpuPort_rdData_MPORT_1_en = MEM_2_cpuPort_rdData_MPORT_1_en_pipe_0;
  assign MEM_2_cpuPort_rdData_MPORT_1_addr = MEM_2_cpuPort_rdData_MPORT_1_addr_pipe_0;
  assign MEM_2_cpuPort_rdData_MPORT_1_data = MEM_2[MEM_2_cpuPort_rdData_MPORT_1_addr]; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
  assign MEM_2_MPORT_2_data = cpuPort_wrData[23:16];
  assign MEM_2_MPORT_2_addr = cpuPort_address[13:2];
  assign MEM_2_MPORT_2_mask = 1'h1;
  assign MEM_2_MPORT_2_en = cpuPort_wrMask[2] & cpuPort_wr;
  assign MEM_3_cpuPort_rdData_MPORT_en = MEM_3_cpuPort_rdData_MPORT_en_pipe_0;
  assign MEM_3_cpuPort_rdData_MPORT_addr = MEM_3_cpuPort_rdData_MPORT_addr_pipe_0;
  assign MEM_3_cpuPort_rdData_MPORT_data = MEM_3[MEM_3_cpuPort_rdData_MPORT_addr]; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
  assign MEM_3_MPORT_3_data = cpuPort_wrData[31:24];
  assign MEM_3_MPORT_3_addr = cpuPort_address[13:2];
  assign MEM_3_MPORT_3_mask = 1'h1;
  assign MEM_3_MPORT_3_en = cpuPort_wrMask[3] & cpuPort_wr;
  assign cpuPort_rdData = {_cpuPort_rdData_T_10,MEM_cpuPort_rdData_MPORT_3_data}; // @[src/main/scala/memory/ScratchPadMem.scala 59:45]
  assign cpuPort_ack = cpuPort_ack_REG; // @[src/main/scala/memory/ScratchPadMem.scala 73:15]
  always @(posedge clock) begin
    if (MEM_MPORT_en & MEM_MPORT_mask) begin
      MEM[MEM_MPORT_addr] <= MEM_MPORT_data; // @[src/main/scala/memory/ScratchPadMem.scala 14:16]
    end
    MEM_cpuPort_rdData_MPORT_3_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_cpuPort_rdData_MPORT_3_addr_pipe_0 <= cpuPort_address[13:2];
    end
    if (MEM_1_MPORT_1_en & MEM_1_MPORT_1_mask) begin
      MEM_1[MEM_1_MPORT_1_addr] <= MEM_1_MPORT_1_data; // @[src/main/scala/memory/ScratchPadMem.scala 15:16]
    end
    MEM_1_cpuPort_rdData_MPORT_2_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_1_cpuPort_rdData_MPORT_2_addr_pipe_0 <= cpuPort_address[13:2];
    end
    if (MEM_2_MPORT_2_en & MEM_2_MPORT_2_mask) begin
      MEM_2[MEM_2_MPORT_2_addr] <= MEM_2_MPORT_2_data; // @[src/main/scala/memory/ScratchPadMem.scala 16:16]
    end
    MEM_2_cpuPort_rdData_MPORT_1_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_2_cpuPort_rdData_MPORT_1_addr_pipe_0 <= cpuPort_address[13:2];
    end
    if (MEM_3_MPORT_3_en & MEM_3_MPORT_3_mask) begin
      MEM_3[MEM_3_MPORT_3_addr] <= MEM_3_MPORT_3_data; // @[src/main/scala/memory/ScratchPadMem.scala 17:16]
    end
    MEM_3_cpuPort_rdData_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_3_cpuPort_rdData_MPORT_addr_pipe_0 <= cpuPort_address[13:2];
    end
    if (reset) begin // @[src/main/scala/memory/ScratchPadMem.scala 73:25]
      cpuPort_ack_REG <= 1'h0; // @[src/main/scala/memory/ScratchPadMem.scala 73:25]
    end else begin
      cpuPort_ack_REG <= cpuPort_rd | cpuPort_wr; // @[src/main/scala/memory/ScratchPadMem.scala 73:25]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4096; initvar = initvar+1)
    MEM[initvar] = _RAND_0[7:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4096; initvar = initvar+1)
    MEM_1[initvar] = _RAND_3[7:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4096; initvar = initvar+1)
    MEM_2[initvar] = _RAND_6[7:0];
  _RAND_9 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4096; initvar = initvar+1)
    MEM_3[initvar] = _RAND_9[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  MEM_cpuPort_rdData_MPORT_3_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  MEM_cpuPort_rdData_MPORT_3_addr_pipe_0 = _RAND_2[11:0];
  _RAND_4 = {1{`RANDOM}};
  MEM_1_cpuPort_rdData_MPORT_2_en_pipe_0 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  MEM_1_cpuPort_rdData_MPORT_2_addr_pipe_0 = _RAND_5[11:0];
  _RAND_7 = {1{`RANDOM}};
  MEM_2_cpuPort_rdData_MPORT_1_en_pipe_0 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  MEM_2_cpuPort_rdData_MPORT_1_addr_pipe_0 = _RAND_8[11:0];
  _RAND_10 = {1{`RANDOM}};
  MEM_3_cpuPort_rdData_MPORT_en_pipe_0 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  MEM_3_cpuPort_rdData_MPORT_addr_pipe_0 = _RAND_11[11:0];
  _RAND_12 = {1{`RANDOM}};
  cpuPort_ack_REG = _RAND_12[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module IODevice(
  input         clock,
  input         reset,
  input         cpuPort_rd, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input         cpuPort_wr, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output [31:0] cpuPort_rdData, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  input  [31:0] cpuPort_wrData, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output        cpuPort_ack, // @[soc-comm/src/main/scala/soc/PipeConDevice.scala 11:19]
  output [15:0] io_out, // @[src/main/scala/wildcat/pipeline/LittleCat.scala 45:16]
  input  [1:0]  io_in // @[src/main/scala/wildcat/pipeline/LittleCat.scala 45:16]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] outReg; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 49:25]
  reg [1:0] cpuPort_rdData_REG; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 51:38]
  reg [1:0] cpuPort_rdData_REG_1; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 51:30]
  reg  cpuPort_ack_REG; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 52:27]
  assign cpuPort_rdData = {{30'd0}, cpuPort_rdData_REG_1}; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 51:20]
  assign cpuPort_ack = cpuPort_ack_REG; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 52:17]
  assign io_out = outReg; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 53:12]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 49:25]
      outReg <= 16'h0; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 49:25]
    end else if (cpuPort_wr) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 50:22]
      outReg <= cpuPort_wrData[15:0]; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 50:31]
    end
    cpuPort_rdData_REG <= io_in; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 51:38]
    cpuPort_rdData_REG_1 <= cpuPort_rdData_REG; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 51:30]
    if (reset) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 52:27]
      cpuPort_ack_REG <= 1'h0; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 52:27]
    end else begin
      cpuPort_ack_REG <= cpuPort_rd | cpuPort_wr; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 52:27]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  outReg = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  cpuPort_rdData_REG = _RAND_1[1:0];
  _RAND_2 = {1{`RANDOM}};
  cpuPort_rdData_REG_1 = _RAND_2[1:0];
  _RAND_3 = {1{`RANDOM}};
  cpuPort_ack_REG = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Tx(
  input        clock,
  input        reset,
  output       io_txd, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 22:14]
  output       io_channel_ready, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 22:14]
  input        io_channel_valid, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 22:14]
  input  [7:0] io_channel_bits // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 22:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [10:0] shiftReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 29:25]
  reg [19:0] cntReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 30:23]
  reg [3:0] bitsReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 31:24]
  wire  _io_channel_ready_T = cntReg == 20'h0; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 33:31]
  wire [9:0] shift = shiftReg[10:1]; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 40:28]
  wire [10:0] _shiftReg_T_1 = {1'h1,shift}; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 41:22]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 42:26]
  wire [10:0] _shiftReg_T_3 = {2'h3,io_channel_bits,1'h0}; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 45:24]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 53:22]
  assign io_txd = shiftReg[0]; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 34:21]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 33:40]
  always @(posedge clock) begin
    if (reset) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 29:25]
      shiftReg <= 11'h7ff; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 29:25]
    end else if (_io_channel_ready_T) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 36:24]
      if (bitsReg != 4'h0) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 39:27]
        shiftReg <= _shiftReg_T_1; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 41:16]
      end else if (io_channel_valid) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 44:30]
        shiftReg <= _shiftReg_T_3; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 45:18]
      end else begin
        shiftReg <= 11'h7ff; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 48:18]
      end
    end
    if (reset) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 30:23]
      cntReg <= 20'h0; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 30:23]
    end else if (_io_channel_ready_T) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 36:24]
      cntReg <= 20'h363; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 38:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 53:12]
    end
    if (reset) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 31:24]
      bitsReg <= 4'h0; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 31:24]
    end else if (_io_channel_ready_T) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 36:24]
      if (bitsReg != 4'h0) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 39:27]
        bitsReg <= _bitsReg_T_1; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 42:15]
      end else if (io_channel_valid) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 44:30]
        bitsReg <= 4'hb; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 46:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shiftReg = _RAND_0[10:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Buffer(
  input        clock,
  input        reset,
  output       io_in_ready, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
  input        io_in_valid, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
  input  [7:0] io_in_bits, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
  input        io_out_ready, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
  output       io_out_valid, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
  output [7:0] io_out_bits // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  stateReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 116:25]
  reg [7:0] dataReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 117:24]
  wire  _io_in_ready_T = ~stateReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 119:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 123:23 125:16 116:25]
  assign io_in_ready = ~stateReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 119:27]
  assign io_out_valid = stateReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 120:28]
  assign io_out_bits = dataReg; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 132:15]
  always @(posedge clock) begin
    if (reset) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 116:25]
      stateReg <= 1'h0; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 116:25]
    end else if (_io_in_ready_T) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 122:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 128:24]
      stateReg <= 1'h0; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 129:16]
    end
    if (reset) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 117:24]
      dataReg <= 8'h0; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 117:24]
    end else if (_io_in_ready_T) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 122:28]
      if (io_in_valid) begin // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 123:23]
        dataReg <= io_in_bits; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 124:15]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BufferedTx(
  input        clock,
  input        reset,
  output       io_txd, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 139:14]
  output       io_channel_ready, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 139:14]
  input        io_channel_valid, // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 139:14]
  input  [7:0] io_channel_bits // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 139:14]
);
  wire  tx_clock; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire  tx_reset; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire  tx_io_txd; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire  tx_io_channel_ready; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire  tx_io_channel_valid; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire [7:0] tx_io_channel_bits; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire  buf__clock; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__reset; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__io_in_ready; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__io_in_valid; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire [7:0] buf__io_in_bits; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__io_out_ready; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__io_out_valid; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire [7:0] buf__io_out_bits; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  Tx tx ( // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Buffer buf_ ( // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_txd = tx_io_txd; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 148:10]
  assign io_channel_ready = buf__io_in_ready; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 146:13]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 147:17]
  assign tx_io_channel_bits = buf__io_out_bits; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 147:17]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = io_channel_valid; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 146:13]
  assign buf__io_in_bits = io_channel_bits; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 146:13]
  assign buf__io_out_ready = tx_io_channel_ready; // @[ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 147:17]
endmodule
module StatsUART(
  input         clock,
  input         reset,
  input  [31:0] io_hits, // @[src/main/scala/device/StatsUart.scala 13:14]
  input  [31:0] io_misses, // @[src/main/scala/device/StatsUart.scala 13:14]
  output        io_txd // @[src/main/scala/device/StatsUart.scala 13:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
`endif // RANDOMIZE_REG_INIT
  wire  tx_clock; // @[src/main/scala/device/StatsUart.scala 20:18]
  wire  tx_reset; // @[src/main/scala/device/StatsUart.scala 20:18]
  wire  tx_io_txd; // @[src/main/scala/device/StatsUart.scala 20:18]
  wire  tx_io_channel_ready; // @[src/main/scala/device/StatsUart.scala 20:18]
  wire  tx_io_channel_valid; // @[src/main/scala/device/StatsUart.scala 20:18]
  wire [7:0] tx_io_channel_bits; // @[src/main/scala/device/StatsUart.scala 20:18]
  reg [23:0] timer; // @[src/main/scala/device/StatsUart.scala 23:22]
  reg [7:0] frame_1; // @[src/main/scala/device/StatsUart.scala 24:18]
  reg [7:0] frame_2; // @[src/main/scala/device/StatsUart.scala 24:18]
  reg [7:0] frame_3; // @[src/main/scala/device/StatsUart.scala 24:18]
  reg [7:0] frame_4; // @[src/main/scala/device/StatsUart.scala 24:18]
  reg [7:0] frame_5; // @[src/main/scala/device/StatsUart.scala 24:18]
  reg [7:0] frame_6; // @[src/main/scala/device/StatsUart.scala 24:18]
  reg [7:0] frame_7; // @[src/main/scala/device/StatsUart.scala 24:18]
  reg [7:0] frame_8; // @[src/main/scala/device/StatsUart.scala 24:18]
  reg [3:0] idx; // @[src/main/scala/device/StatsUart.scala 25:20]
  reg  sending; // @[src/main/scala/device/StatsUart.scala 26:24]
  wire [7:0] _GEN_1 = 4'h1 == idx ? frame_1 : 8'haa; // @[src/main/scala/device/StatsUart.scala 29:{22,22}]
  wire [7:0] _GEN_2 = 4'h2 == idx ? frame_2 : _GEN_1; // @[src/main/scala/device/StatsUart.scala 29:{22,22}]
  wire [7:0] _GEN_3 = 4'h3 == idx ? frame_3 : _GEN_2; // @[src/main/scala/device/StatsUart.scala 29:{22,22}]
  wire [7:0] _GEN_4 = 4'h4 == idx ? frame_4 : _GEN_3; // @[src/main/scala/device/StatsUart.scala 29:{22,22}]
  wire [7:0] _GEN_5 = 4'h5 == idx ? frame_5 : _GEN_4; // @[src/main/scala/device/StatsUart.scala 29:{22,22}]
  wire [7:0] _GEN_6 = 4'h6 == idx ? frame_6 : _GEN_5; // @[src/main/scala/device/StatsUart.scala 29:{22,22}]
  wire [7:0] _GEN_7 = 4'h7 == idx ? frame_7 : _GEN_6; // @[src/main/scala/device/StatsUart.scala 29:{22,22}]
  wire [23:0] _timer_T_1 = timer + 24'h1; // @[src/main/scala/device/StatsUart.scala 32:20]
  wire  _GEN_20 = timer == 24'h98967f | sending; // @[src/main/scala/device/StatsUart.scala 33:42 41:15 26:24]
  wire [3:0] _idx_T_1 = idx + 4'h1; // @[src/main/scala/device/StatsUart.scala 46:18]
  BufferedTx tx ( // @[src/main/scala/device/StatsUart.scala 20:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  assign io_txd = tx_io_txd; // @[src/main/scala/device/StatsUart.scala 21:10]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = ~sending ? 1'h0 : 1'h1; // @[src/main/scala/device/StatsUart.scala 31:18 28:23 44:25]
  assign tx_io_channel_bits = 4'h8 == idx ? frame_8 : _GEN_7; // @[src/main/scala/device/StatsUart.scala 29:{22,22}]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/device/StatsUart.scala 23:22]
      timer <= 24'h0; // @[src/main/scala/device/StatsUart.scala 23:22]
    end else if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        timer <= 24'h0; // @[src/main/scala/device/StatsUart.scala 34:13]
      end else begin
        timer <= _timer_T_1; // @[src/main/scala/device/StatsUart.scala 32:11]
      end
    end
    if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        frame_1 <= io_hits[7:0]; // @[src/main/scala/device/StatsUart.scala 37:22]
      end
    end
    if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        frame_2 <= io_hits[15:8]; // @[src/main/scala/device/StatsUart.scala 37:22]
      end
    end
    if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        frame_3 <= io_hits[23:16]; // @[src/main/scala/device/StatsUart.scala 37:22]
      end
    end
    if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        frame_4 <= io_hits[31:24]; // @[src/main/scala/device/StatsUart.scala 37:22]
      end
    end
    if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        frame_5 <= io_misses[7:0]; // @[src/main/scala/device/StatsUart.scala 38:22]
      end
    end
    if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        frame_6 <= io_misses[15:8]; // @[src/main/scala/device/StatsUart.scala 38:22]
      end
    end
    if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        frame_7 <= io_misses[23:16]; // @[src/main/scala/device/StatsUart.scala 38:22]
      end
    end
    if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        frame_8 <= io_misses[31:24]; // @[src/main/scala/device/StatsUart.scala 38:22]
      end
    end
    if (reset) begin // @[src/main/scala/device/StatsUart.scala 25:20]
      idx <= 4'h0; // @[src/main/scala/device/StatsUart.scala 25:20]
    end else if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      if (timer == 24'h98967f) begin // @[src/main/scala/device/StatsUart.scala 33:42]
        idx <= 4'h0; // @[src/main/scala/device/StatsUart.scala 40:11]
      end
    end else if (tx_io_channel_ready) begin // @[src/main/scala/device/StatsUart.scala 45:31]
      idx <= _idx_T_1; // @[src/main/scala/device/StatsUart.scala 46:11]
    end
    if (reset) begin // @[src/main/scala/device/StatsUart.scala 26:24]
      sending <= 1'h0; // @[src/main/scala/device/StatsUart.scala 26:24]
    end else if (~sending) begin // @[src/main/scala/device/StatsUart.scala 31:18]
      sending <= _GEN_20;
    end else if (tx_io_channel_ready) begin // @[src/main/scala/device/StatsUart.scala 45:31]
      if (idx == 4'h8) begin // @[src/main/scala/device/StatsUart.scala 47:25]
        sending <= 1'h0; // @[src/main/scala/device/StatsUart.scala 47:35]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  timer = _RAND_0[23:0];
  _RAND_1 = {1{`RANDOM}};
  frame_1 = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  frame_2 = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  frame_3 = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  frame_4 = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  frame_5 = _RAND_5[7:0];
  _RAND_6 = {1{`RANDOM}};
  frame_6 = _RAND_6[7:0];
  _RAND_7 = {1{`RANDOM}};
  frame_7 = _RAND_7[7:0];
  _RAND_8 = {1{`RANDOM}};
  frame_8 = _RAND_8[7:0];
  _RAND_9 = {1{`RANDOM}};
  idx = _RAND_9[3:0];
  _RAND_10 = {1{`RANDOM}};
  sending = _RAND_10[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module LittleCat(
  input         clock,
  input         reset,
  output [15:0] io_out, // @[src/main/scala/wildcat/pipeline/LittleCat.scala 14:14]
  input  [1:0]  io_in, // @[src/main/scala/wildcat/pipeline/LittleCat.scala 14:14]
  input         io_rx, // @[src/main/scala/wildcat/pipeline/LittleCat.scala 14:14]
  output        io_tx, // @[src/main/scala/wildcat/pipeline/LittleCat.scala 14:14]
  input         io_rxConf, // @[src/main/scala/wildcat/pipeline/LittleCat.scala 14:14]
  output        io_txConf // @[src/main/scala/wildcat/pipeline/LittleCat.scala 14:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  wire  cpu_clock; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire  cpu_reset; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire [31:0] cpu_io_imem_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire [31:0] cpu_io_imem_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire  cpu_io_imem_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire [31:0] cpu_io_dmem_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire  cpu_io_dmem_rd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire  cpu_io_dmem_wr; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire [31:0] cpu_io_dmem_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire [31:0] cpu_io_dmem_wrData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire [3:0] cpu_io_dmem_wrMask; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire  cpu_io_dmem_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
  wire  imem_clock; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 28:20]
  wire  imem_reset; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 28:20]
  wire [31:0] imem_cpuPort_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 28:20]
  wire [31:0] imem_cpuPort_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 28:20]
  wire  imem_cpuPort_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 28:20]
  wire  cacheAdapter_clock; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  cacheAdapter_reset; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire [31:0] cacheAdapter_cpuPort_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  cacheAdapter_cpuPort_rd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  cacheAdapter_cpuPort_wr; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire [31:0] cacheAdapter_cpuPort_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire [31:0] cacheAdapter_cpuPort_wrData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire [3:0] cacheAdapter_cpuPort_wrMask; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  cacheAdapter_cpuPort_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire [31:0] cacheAdapter_mem_port_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  cacheAdapter_mem_port_rd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  cacheAdapter_mem_port_wr; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire [31:0] cacheAdapter_mem_port_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire [31:0] cacheAdapter_mem_port_wrData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire [3:0] cacheAdapter_mem_port_wrMask; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  cacheAdapter_mem_port_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  cacheAdapter_debug_hit; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  cacheAdapter_debug_miss; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
  wire  dmem_clock; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
  wire  dmem_reset; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
  wire [31:0] dmem_cpuPort_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
  wire  dmem_cpuPort_rd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
  wire  dmem_cpuPort_wr; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
  wire [31:0] dmem_cpuPort_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
  wire [31:0] dmem_cpuPort_wrData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
  wire [3:0] dmem_cpuPort_wrMask; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
  wire  dmem_cpuPort_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
  wire  ioDevice_clock; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
  wire  ioDevice_reset; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
  wire  ioDevice_cpuPort_rd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
  wire  ioDevice_cpuPort_wr; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
  wire [31:0] ioDevice_cpuPort_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
  wire [31:0] ioDevice_cpuPort_wrData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
  wire  ioDevice_cpuPort_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
  wire [15:0] ioDevice_io_out; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
  wire [1:0] ioDevice_io_in; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
  wire  statsUART_clock; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 84:25]
  wire  statsUART_reset; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 84:25]
  wire [31:0] statsUART_io_hits; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 84:25]
  wire [31:0] statsUART_io_misses; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 84:25]
  wire  statsUART_io_txd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 84:25]
  wire  csMem = cpu_io_dmem_address[31:28] == 4'h0; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 33:43]
  reg [31:0] memAddressReg; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 55:32]
  wire  csIO = cpu_io_dmem_address[31:28] == 4'hf; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 56:42]
  wire  csIOReg = memAddressReg[31:28] == 4'hf; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 57:39]
  wire  csIODev = csIO & cpu_io_dmem_address[19:16] == 4'h1; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 58:22]
  wire  muxIODev = csIOReg & memAddressReg[19:16] == 4'h1; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 59:26]
  reg [26:0] heartbeat; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 72:26]
  wire [26:0] _heartbeat_T_1 = heartbeat + 27'h1; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 73:26]
  reg [31:0] hitCount; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 75:25]
  reg [31:0] missCount; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 76:26]
  wire [31:0] _hitCount_T_1 = hitCount + 32'h1; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 77:55]
  wire [31:0] _missCount_T_1 = missCount + 32'h1; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 78:58]
  wire [14:0] stats = {missCount[6:0],hitCount[7:0]}; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 81:18]
  wire [14:0] _io_out_T_3 = io_in[0] ? stats : ioDevice_io_out[14:0]; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 82:35]
  ThreeCats cpu ( // @[src/main/scala/wildcat/pipeline/LittleCat.scala 26:19]
    .clock(cpu_clock),
    .reset(cpu_reset),
    .io_imem_address(cpu_io_imem_address),
    .io_imem_rdData(cpu_io_imem_rdData),
    .io_imem_ack(cpu_io_imem_ack),
    .io_dmem_address(cpu_io_dmem_address),
    .io_dmem_rd(cpu_io_dmem_rd),
    .io_dmem_wr(cpu_io_dmem_wr),
    .io_dmem_rdData(cpu_io_dmem_rdData),
    .io_dmem_wrData(cpu_io_dmem_wrData),
    .io_dmem_wrMask(cpu_io_dmem_wrMask),
    .io_dmem_ack(cpu_io_dmem_ack)
  );
  InstructionROM imem ( // @[src/main/scala/wildcat/pipeline/LittleCat.scala 28:20]
    .clock(imem_clock),
    .reset(imem_reset),
    .cpuPort_address(imem_cpuPort_address),
    .cpuPort_rdData(imem_cpuPort_rdData),
    .cpuPort_ack(imem_cpuPort_ack)
  );
  CacheAdapter cacheAdapter ( // @[src/main/scala/wildcat/pipeline/LittleCat.scala 32:28]
    .clock(cacheAdapter_clock),
    .reset(cacheAdapter_reset),
    .cpuPort_address(cacheAdapter_cpuPort_address),
    .cpuPort_rd(cacheAdapter_cpuPort_rd),
    .cpuPort_wr(cacheAdapter_cpuPort_wr),
    .cpuPort_rdData(cacheAdapter_cpuPort_rdData),
    .cpuPort_wrData(cacheAdapter_cpuPort_wrData),
    .cpuPort_wrMask(cacheAdapter_cpuPort_wrMask),
    .cpuPort_ack(cacheAdapter_cpuPort_ack),
    .mem_port_address(cacheAdapter_mem_port_address),
    .mem_port_rd(cacheAdapter_mem_port_rd),
    .mem_port_wr(cacheAdapter_mem_port_wr),
    .mem_port_rdData(cacheAdapter_mem_port_rdData),
    .mem_port_wrData(cacheAdapter_mem_port_wrData),
    .mem_port_wrMask(cacheAdapter_mem_port_wrMask),
    .mem_port_ack(cacheAdapter_mem_port_ack),
    .debug_hit(cacheAdapter_debug_hit),
    .debug_miss(cacheAdapter_debug_miss)
  );
  ScratchPadMem dmem ( // @[src/main/scala/wildcat/pipeline/LittleCat.scala 40:20]
    .clock(dmem_clock),
    .reset(dmem_reset),
    .cpuPort_address(dmem_cpuPort_address),
    .cpuPort_rd(dmem_cpuPort_rd),
    .cpuPort_wr(dmem_cpuPort_wr),
    .cpuPort_rdData(dmem_cpuPort_rdData),
    .cpuPort_wrData(dmem_cpuPort_wrData),
    .cpuPort_wrMask(dmem_cpuPort_wrMask),
    .cpuPort_ack(dmem_cpuPort_ack)
  );
  IODevice ioDevice ( // @[src/main/scala/wildcat/pipeline/LittleCat.scala 61:24]
    .clock(ioDevice_clock),
    .reset(ioDevice_reset),
    .cpuPort_rd(ioDevice_cpuPort_rd),
    .cpuPort_wr(ioDevice_cpuPort_wr),
    .cpuPort_rdData(ioDevice_cpuPort_rdData),
    .cpuPort_wrData(ioDevice_cpuPort_wrData),
    .cpuPort_ack(ioDevice_cpuPort_ack),
    .io_out(ioDevice_io_out),
    .io_in(ioDevice_io_in)
  );
  StatsUART statsUART ( // @[src/main/scala/wildcat/pipeline/LittleCat.scala 84:25]
    .clock(statsUART_clock),
    .reset(statsUART_reset),
    .io_hits(statsUART_io_hits),
    .io_misses(statsUART_io_misses),
    .io_txd(statsUART_io_txd)
  );
  assign io_out = {heartbeat[26],_io_out_T_3}; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 82:16]
  assign io_tx = statsUART_io_txd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 87:9]
  assign io_txConf = 1'h0; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 22:13]
  assign cpu_clock = clock;
  assign cpu_reset = reset;
  assign cpu_io_imem_rdData = imem_cpuPort_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 29:15]
  assign cpu_io_imem_ack = imem_cpuPort_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 29:15]
  assign cpu_io_dmem_rdData = muxIODev ? ioDevice_cpuPort_rdData : cacheAdapter_cpuPort_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 68:18 67:22 68:39]
  assign cpu_io_dmem_ack = cacheAdapter_cpuPort_ack | ioDevice_cpuPort_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 69:47]
  assign imem_clock = clock;
  assign imem_reset = reset;
  assign imem_cpuPort_address = cpu_io_imem_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 29:15]
  assign cacheAdapter_clock = clock;
  assign cacheAdapter_reset = reset;
  assign cacheAdapter_cpuPort_address = cpu_io_dmem_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 34:32]
  assign cacheAdapter_cpuPort_rd = csMem & cpu_io_dmem_rd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 37:36]
  assign cacheAdapter_cpuPort_wr = csMem & cpu_io_dmem_wr; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 38:36]
  assign cacheAdapter_cpuPort_wrData = cpu_io_dmem_wrData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 35:31]
  assign cacheAdapter_cpuPort_wrMask = cpu_io_dmem_wrMask; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 36:31]
  assign cacheAdapter_mem_port_rdData = dmem_cpuPort_rdData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 41:16]
  assign cacheAdapter_mem_port_ack = dmem_cpuPort_ack; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 41:16]
  assign dmem_clock = clock;
  assign dmem_reset = reset;
  assign dmem_cpuPort_address = cacheAdapter_mem_port_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 41:16]
  assign dmem_cpuPort_rd = cacheAdapter_mem_port_rd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 41:16]
  assign dmem_cpuPort_wr = cacheAdapter_mem_port_wr; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 41:16]
  assign dmem_cpuPort_wrData = cacheAdapter_mem_port_wrData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 41:16]
  assign dmem_cpuPort_wrMask = cacheAdapter_mem_port_wrMask; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 41:16]
  assign ioDevice_clock = clock;
  assign ioDevice_reset = reset;
  assign ioDevice_cpuPort_rd = csIODev & cpu_io_dmem_rd; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 64:34]
  assign ioDevice_cpuPort_wr = csIODev & cpu_io_dmem_wr; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 65:34]
  assign ioDevice_cpuPort_wrData = cpu_io_dmem_wrData; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 63:20]
  assign ioDevice_io_in = io_in; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 62:18]
  assign statsUART_clock = clock;
  assign statsUART_reset = reset;
  assign statsUART_io_hits = hitCount; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 85:21]
  assign statsUART_io_misses = missCount; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 86:23]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 55:32]
      memAddressReg <= 32'h0; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 55:32]
    end else if (cpu_io_dmem_rd) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 55:32]
      memAddressReg <= cpu_io_dmem_address; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 55:32]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 72:26]
      heartbeat <= 27'h0; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 72:26]
    end else begin
      heartbeat <= _heartbeat_T_1; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 73:13]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 75:25]
      hitCount <= 32'h0; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 75:25]
    end else if (cacheAdapter_debug_hit) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 77:32]
      hitCount <= _hitCount_T_1; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 77:43]
    end
    if (reset) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 76:26]
      missCount <= 32'h0; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 76:26]
    end else if (cacheAdapter_debug_miss) begin // @[src/main/scala/wildcat/pipeline/LittleCat.scala 78:33]
      missCount <= _missCount_T_1; // @[src/main/scala/wildcat/pipeline/LittleCat.scala 78:45]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  memAddressReg = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  heartbeat = _RAND_1[26:0];
  _RAND_2 = {1{`RANDOM}};
  hitCount = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  missCount = _RAND_3[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
