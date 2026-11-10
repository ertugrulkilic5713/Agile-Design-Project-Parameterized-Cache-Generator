module BindsTo_2_ScratchPadMem(
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

initial begin
  $readmemh("data2.hex", ScratchPadMem.MEM_2);
end
                      endmodule

bind ScratchPadMem BindsTo_2_ScratchPadMem BindsTo_2_ScratchPadMem_Inst(.*);