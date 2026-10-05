`default_nettype none

// Loopback logic for the AXI_M_IO_W functional test (see
// axi_m_loopback_top.v). Each AXI_M_BEL input gets a distinct function of
// the BEL outputs so a swapped or misrouted pin changes some result.
// Generated together with Test/axi_m_loopback_tb.v; keep them in sync.
module axi_m_loopback (
    input  wire [31:0] rd,
    input  wire [9:0]  c,
    output wire [31:0] wdata,
    output wire [31:0] awaddr,
    output wire [31:0] araddr,
    output wire [45:0] ctrl
);
    assign wdata  = rd;
    assign awaddr = rd ^ {rd[0], rd[31:1]};
    assign araddr = ~rd;
    assign ctrl[0] = c[0] ^ rd[0];  // AWLEN[0]
    assign ctrl[1] = c[1] ^ rd[1];  // AWLEN[1]
    assign ctrl[2] = c[2] ^ rd[2];  // AWLEN[2]
    assign ctrl[3] = c[3] ^ rd[3];  // AWLEN[3]
    assign ctrl[4] = c[4] ^ rd[4];  // AWLEN[4]
    assign ctrl[5] = c[5] ^ rd[5];  // AWLEN[5]
    assign ctrl[6] = c[6] ^ rd[6];  // AWLEN[6]
    assign ctrl[7] = c[7] ^ rd[7];  // AWLEN[7]
    assign ctrl[8] = c[8] ^ rd[8];  // AWSIZE[0]
    assign ctrl[9] = c[9] ^ rd[9];  // AWSIZE[1]
    assign ctrl[10] = c[0] ^ rd[10];  // AWSIZE[2]
    assign ctrl[11] = c[1] ^ rd[11];  // AWBURST[0]
    assign ctrl[12] = c[2] ^ rd[12];  // AWBURST[1]
    assign ctrl[13] = c[3] ^ rd[13];  // AWLOCK
    assign ctrl[14] = c[4] ^ rd[14];  // AWCACHE[0]
    assign ctrl[15] = c[5] ^ rd[15];  // AWCACHE[1]
    assign ctrl[16] = c[6] ^ rd[16];  // AWCACHE[2]
    assign ctrl[17] = c[7] ^ rd[17];  // AWCACHE[3]
    assign ctrl[18] = c[8] ^ rd[18];  // AWVALID
    assign ctrl[19] = c[9] ^ rd[19];  // WSTRB[0]
    assign ctrl[20] = c[0] ^ rd[20];  // WSTRB[1]
    assign ctrl[21] = c[1] ^ rd[21];  // WSTRB[2]
    assign ctrl[22] = c[2] ^ rd[22];  // WSTRB[3]
    assign ctrl[23] = c[3] ^ rd[23];  // WLAST
    assign ctrl[24] = c[4] ^ rd[24];  // WVALID
    assign ctrl[25] = c[5] ^ rd[25];  // BREADY
    assign ctrl[26] = c[6] ^ rd[26];  // ARLEN[0]
    assign ctrl[27] = c[7] ^ rd[27];  // ARLEN[1]
    assign ctrl[28] = c[8] ^ rd[28];  // ARLEN[2]
    assign ctrl[29] = c[9] ^ rd[29];  // ARLEN[3]
    assign ctrl[30] = c[0] ^ rd[30];  // ARLEN[4]
    assign ctrl[31] = c[1] ^ rd[31];  // ARLEN[5]
    assign ctrl[32] = c[2] ^ rd[0];  // ARLEN[6]
    assign ctrl[33] = c[3] ^ rd[1];  // ARLEN[7]
    assign ctrl[34] = c[4] ^ rd[2];  // ARSIZE[0]
    assign ctrl[35] = c[5] ^ rd[3];  // ARSIZE[1]
    assign ctrl[36] = c[6] ^ rd[4];  // ARSIZE[2]
    assign ctrl[37] = c[7] ^ rd[5];  // ARBURST[0]
    assign ctrl[38] = c[8] ^ rd[6];  // ARBURST[1]
    assign ctrl[39] = c[9] ^ rd[7];  // ARLOCK
    assign ctrl[40] = c[0] ^ rd[8];  // ARCACHE[0]
    assign ctrl[41] = c[1] ^ rd[9];  // ARCACHE[1]
    assign ctrl[42] = c[2] ^ rd[10];  // ARCACHE[2]
    assign ctrl[43] = c[3] ^ rd[11];  // ARCACHE[3]
    assign ctrl[44] = c[4] ^ rd[12];  // ARVALID
    assign ctrl[45] = c[5] ^ rd[13];  // RREADY
endmodule
`resetall

`default_nettype none

// Loopback logic for the AXIL_S_IO_W functional test (see
// axil_s_loopback_top.v). Each AXIL_S_BEL input is a distinct function of
// the BEL outputs, and every output feeds some input, so a swapped or
// misrouted pin changes some result. Generated together with
// Test/axil_s_loopback_tb.v; keep them in sync.
module axil_s_loopback (
    input  wire [66:0] o,
    output wire [40:0] i
);
    assign i[0] = o[0] ^ (o[41] & o[7]);  // FAB_AWREADY
    assign i[1] = o[1] ^ (o[42] & o[8]);  // FAB_WREADY
    assign i[2] = o[2] ^ (o[43] & o[9]);  // FAB_BRESP0
    assign i[3] = o[3] ^ (o[44] & o[10]);  // FAB_BRESP1
    assign i[4] = o[4] ^ (o[45] & o[11]);  // FAB_BVALID
    assign i[5] = o[5] ^ (o[46] & o[12]);  // FAB_ARREADY
    assign i[6] = o[6] ^ (o[47] & o[13]);  // FAB_RDATA0
    assign i[7] = o[7] ^ (o[48] & o[14]);  // FAB_RDATA1
    assign i[8] = o[8] ^ (o[49] & o[15]);  // FAB_RDATA2
    assign i[9] = o[9] ^ (o[50] & o[16]);  // FAB_RDATA3
    assign i[10] = o[10] ^ (o[51] & o[17]);  // FAB_RDATA4
    assign i[11] = o[11] ^ (o[52] & o[18]);  // FAB_RDATA5
    assign i[12] = o[12] ^ (o[53] & o[19]);  // FAB_RDATA6
    assign i[13] = o[13] ^ (o[54] & o[20]);  // FAB_RDATA7
    assign i[14] = o[14] ^ (o[55] & o[21]);  // FAB_RDATA8
    assign i[15] = o[15] ^ (o[56] & o[22]);  // FAB_RDATA9
    assign i[16] = o[16] ^ (o[57] & o[23]);  // FAB_RDATA10
    assign i[17] = o[17] ^ (o[58] & o[24]);  // FAB_RDATA11
    assign i[18] = o[18] ^ (o[59] & o[25]);  // FAB_RDATA12
    assign i[19] = o[19] ^ (o[60] & o[26]);  // FAB_RDATA13
    assign i[20] = o[20] ^ (o[61] & o[27]);  // FAB_RDATA14
    assign i[21] = o[21] ^ (o[62] & o[28]);  // FAB_RDATA15
    assign i[22] = o[22] ^ (o[63] & o[29]);  // FAB_RDATA16
    assign i[23] = o[23] ^ (o[64] & o[30]);  // FAB_RDATA17
    assign i[24] = o[24] ^ (o[65] & o[31]);  // FAB_RDATA18
    assign i[25] = o[25] ^ (o[66] & o[32]);  // FAB_RDATA19
    assign i[26] = o[26] ^ (o[41] & o[33]);  // FAB_RDATA20
    assign i[27] = o[27] ^ (o[42] & o[34]);  // FAB_RDATA21
    assign i[28] = o[28] ^ (o[43] & o[35]);  // FAB_RDATA22
    assign i[29] = o[29] ^ (o[44] & o[36]);  // FAB_RDATA23
    assign i[30] = o[30] ^ (o[45] & o[37]);  // FAB_RDATA24
    assign i[31] = o[31] ^ (o[46] & o[38]);  // FAB_RDATA25
    assign i[32] = o[32] ^ (o[47] & o[39]);  // FAB_RDATA26
    assign i[33] = o[33] ^ (o[48] & o[40]);  // FAB_RDATA27
    assign i[34] = o[34] ^ (o[49] & o[0]);  // FAB_RDATA28
    assign i[35] = o[35] ^ (o[50] & o[1]);  // FAB_RDATA29
    assign i[36] = o[36] ^ (o[51] & o[2]);  // FAB_RDATA30
    assign i[37] = o[37] ^ (o[52] & o[3]);  // FAB_RDATA31
    assign i[38] = o[38] ^ (o[53] & o[4]);  // FAB_RRESP0
    assign i[39] = o[39] ^ (o[54] & o[5]);  // FAB_RRESP1
    assign i[40] = o[40] ^ (o[55] & o[6]);  // FAB_RVALID
endmodule
`resetall

`default_nettype none

// Loopback logic for the SOC_DEBUG_IO functional test (see
// soc_debug_loopback_top.v): per instance k, DEBUG_IN is a rotated and
// XORed copy of DEBUG_OUT and USR_IRQ mixes the soft reset with one
// DEBUG_OUT bit, both distinct per instance. Generated together with
// Test/soc_debug_loopback_tb.v; keep them in sync.
module soc_debug_loopback (
    input  wire [31:0] fab_dbg_out,
    input  wire [3:0]  fab_rst_n,
    output wire [31:0] fab_dbg_in,
    output wire [3:0]  fab_irq
);
    wire [7:0] out0 = fab_dbg_out[7:0];
    assign fab_dbg_in[7:0] = {out0[6:0], out0[7:7]} ^ 8'hA5;
    assign fab_irq[0] = fab_rst_n[0] ^ out0[0];
    wire [7:0] out1 = fab_dbg_out[15:8];
    assign fab_dbg_in[15:8] = {out1[5:0], out1[7:6]} ^ 8'h3C;
    assign fab_irq[1] = fab_rst_n[1] ^ out1[2];
    wire [7:0] out2 = fab_dbg_out[23:16];
    assign fab_dbg_in[23:16] = {out2[4:0], out2[7:5]} ^ 8'h0F;
    assign fab_irq[2] = fab_rst_n[2] ^ out2[4];
    wire [7:0] out3 = fab_dbg_out[31:24];
    assign fab_dbg_in[31:24] = {out3[3:0], out3[7:4]} ^ 8'hF0;
    assign fab_irq[3] = fab_rst_n[3] ^ out3[6];
endmodule
`resetall

`default_nettype none

// Fabric logic for the EXT_PMOD functional test 'bypass' (see
// ext_pmod_bypass_top.v). Generated together with
// Test/ext_pmod_bypass_tb.v; keep them in sync.
module ext_pmod_bypass (
    input  wire [7:0]  fab_i,
    input  wire [15:0] wdata,
    output wire [7:0]  fab_o,
    output wire [7:0]  fab_oe
);
    assign fab_o  = {fab_i[6:0], fab_i[7]} ^ 8'h5A;
    assign fab_oe = {fab_i[4:0], fab_i[7:5]} ^ fab_i;
endmodule
`resetall

`default_nettype none

// Fabric logic for the NPU_CTRL_CFG functional test 'skew_on': every
// NPU_CTRL_CFG_BEL input is a distinct function of the AXIL_S stimulus.
// Generated together with Test/npu_ctrl_skew_on_tb.v; keep them in sync.
module npu_ctrl_skew_on (
    input  wire [66:0] o,
    output wire [36:0] i
);
    assign i[0] = o[0] ^ (o[37] & o[5]);  // FAB_QUANT_SHIFT_IN0
    assign i[1] = o[1] ^ (o[38] & o[6]);  // FAB_QUANT_SHIFT_IN1
    assign i[2] = o[2] ^ (o[39] & o[7]);  // FAB_QUANT_SHIFT_IN2
    assign i[3] = o[3] ^ (o[40] & o[8]);  // FAB_QUANT_SHIFT_IN3
    assign i[4] = o[4] ^ (o[41] & o[9]);  // FAB_QUANT_SHIFT_IN4
    assign i[5] = o[5] ^ (o[42] & o[10]);  // FAB_QUANT_SHIFT_IN5
    assign i[6] = o[6] ^ (o[43] & o[11]);  // FAB_QUANT_SHIFT_IN6
    assign i[7] = o[7] ^ (o[44] & o[12]);  // FAB_QUANT_SHIFT_IN7
    assign i[8] = o[8] ^ (o[45] & o[13]);  // FAB_QUANT_SHIFT_IN8
    assign i[9] = o[9] ^ (o[46] & o[14]);  // FAB_QUANT_SHIFT_IN9
    assign i[10] = o[10] ^ (o[47] & o[15]);  // FAB_QUANT_SHIFT_IN10
    assign i[11] = o[11] ^ (o[48] & o[16]);  // FAB_QUANT_SHIFT_IN11
    assign i[12] = o[12] ^ (o[49] & o[17]);  // FAB_QUANT_SHIFT_IN12
    assign i[13] = o[13] ^ (o[50] & o[18]);  // FAB_QUANT_SHIFT_IN13
    assign i[14] = o[14] ^ (o[51] & o[19]);  // FAB_QUANT_SHIFT_IN14
    assign i[15] = o[15] ^ (o[52] & o[20]);  // FAB_QUANT_SHIFT_IN15
    assign i[16] = o[16] ^ (o[53] & o[21]);  // FAB_QUANT_SHIFT_IN16
    assign i[17] = o[17] ^ (o[54] & o[22]);  // FAB_QUANT_SHIFT_IN17
    assign i[18] = o[18] ^ (o[55] & o[23]);  // FAB_QUANT_SHIFT_IN18
    assign i[19] = o[19] ^ (o[56] & o[24]);  // FAB_QUANT_SHIFT_IN19
    assign i[20] = o[20] ^ (o[57] & o[25]);  // FAB_QUANT_SHIFT_IN20
    assign i[21] = o[21] ^ (o[58] & o[26]);  // FAB_QUANT_SHIFT_IN21
    assign i[22] = o[22] ^ (o[59] & o[27]);  // FAB_QUANT_SHIFT_IN22
    assign i[23] = o[23] ^ (o[60] & o[28]);  // FAB_QUANT_SHIFT_IN23
    assign i[24] = o[24] ^ (o[61] & o[29]);  // FAB_QUANT_SHIFT_IN24
    assign i[25] = o[25] ^ (o[62] & o[30]);  // FAB_QUANT_SHIFT_IN25
    assign i[26] = o[26] ^ (o[63] & o[31]);  // FAB_QUANT_SHIFT_IN26
    assign i[27] = o[27] ^ (o[64] & o[32]);  // FAB_QUANT_SHIFT_IN27
    assign i[28] = o[28] ^ (o[65] & o[33]);  // FAB_QUANT_SHIFT_IN28
    assign i[29] = o[29] ^ (o[66] & o[34]);  // FAB_QUANT_SHIFT_IN29
    assign i[30] = o[30] ^ (o[37] & o[35]);  // FAB_QUANT_SHIFT_EN
    assign i[31] = o[31] ^ (o[38] & o[36]);  // FAB_ARRAY_EN
    assign i[32] = o[32] ^ (o[39] & o[0]);  // FAB_PSUM_SYSTOLIC_EN
    assign i[33] = o[33] ^ (o[40] & o[1]);  // FAB_PSUM_LUT_EN
    assign i[34] = o[34] ^ (o[41] & o[2]);  // FAB_SWAP_WEIGHTS
    assign i[35] = o[35] ^ (o[42] & o[3]);  // FAB_PSUM_SKEW_EN
    assign i[36] = o[36] ^ (o[43] & o[4]);  // FAB_COMPUTE_BANK_SWAP
endmodule
`resetall

`default_nettype none

// Loopback logic for the NPU_ACCUM functional test (see
// npu_accum_loopback_top.v): every BEL input of a bank is a distinct
// function of that bank's RDATA. Generated together with
// Test/npu_accum_loopback_tb.v; keep them in sync.
module npu_accum_loopback (
    input  wire [31:0] ra, rb,
    output wire [50:0] ia, ib
);
    assign ia[0] = ra[0] ^ (ra[1] & ra[2]);  // FAB_ADDR0
    assign ia[1] = ra[1] ^ (ra[4] & ra[7]);  // FAB_ADDR1
    assign ia[2] = ra[2] ^ (ra[7] & ra[12]);  // FAB_ADDR2
    assign ia[3] = ra[3] ^ (ra[10] & ra[17]);  // FAB_ADDR3
    assign ia[4] = ra[4] ^ (ra[13] & ra[22]);  // FAB_ADDR4
    assign ia[5] = ra[5] ^ (ra[16] & ra[27]);  // FAB_ADDR5
    assign ia[6] = ra[6] ^ (ra[19] & ra[0]);  // FAB_ADDR6
    assign ia[7] = ra[7] ^ (ra[22] & ra[5]);  // FAB_ADDR7
    assign ia[8] = ra[8] ^ (ra[25] & ra[10]);  // FAB_WE0
    assign ia[9] = ra[9] ^ (ra[28] & ra[15]);  // FAB_WE1
    assign ia[10] = ra[10] ^ (ra[31] & ra[20]);  // FAB_WE2
    assign ia[11] = ra[11] ^ (ra[2] & ra[25]);  // FAB_WE3
    assign ia[12] = ra[12] ^ (ra[5] & ra[30]);  // FAB_WE4
    assign ia[13] = ra[13] ^ (ra[8] & ra[3]);  // FAB_WE5
    assign ia[14] = ra[14] ^ (ra[11] & ra[8]);  // FAB_WE6
    assign ia[15] = ra[15] ^ (ra[14] & ra[13]);  // FAB_WE7
    assign ia[16] = ra[16] ^ (ra[17] & ra[18]);  // FAB_WDATA0
    assign ia[17] = ra[17] ^ (ra[20] & ra[23]);  // FAB_WDATA1
    assign ia[18] = ra[18] ^ (ra[23] & ra[28]);  // FAB_WDATA2
    assign ia[19] = ra[19] ^ (ra[26] & ra[1]);  // FAB_WDATA3
    assign ia[20] = ra[20] ^ (ra[29] & ra[6]);  // FAB_WDATA4
    assign ia[21] = ra[21] ^ (ra[0] & ra[11]);  // FAB_WDATA5
    assign ia[22] = ra[22] ^ (ra[3] & ra[16]);  // FAB_WDATA6
    assign ia[23] = ra[23] ^ (ra[6] & ra[21]);  // FAB_WDATA7
    assign ia[24] = ra[24] ^ (ra[9] & ra[26]);  // FAB_WDATA8
    assign ia[25] = ra[25] ^ (ra[12] & ra[31]);  // FAB_WDATA9
    assign ia[26] = ra[26] ^ (ra[15] & ra[4]);  // FAB_WDATA10
    assign ia[27] = ra[27] ^ (ra[18] & ra[9]);  // FAB_WDATA11
    assign ia[28] = ra[28] ^ (ra[21] & ra[14]);  // FAB_WDATA12
    assign ia[29] = ra[29] ^ (ra[24] & ra[19]);  // FAB_WDATA13
    assign ia[30] = ra[30] ^ (ra[27] & ra[24]);  // FAB_WDATA14
    assign ia[31] = ra[31] ^ (ra[30] & ra[29]);  // FAB_WDATA15
    assign ia[32] = ra[0] ^ (ra[1] & ra[2]);  // FAB_WDATA16
    assign ia[33] = ra[1] ^ (ra[4] & ra[7]);  // FAB_WDATA17
    assign ia[34] = ra[2] ^ (ra[7] & ra[12]);  // FAB_WDATA18
    assign ia[35] = ra[3] ^ (ra[10] & ra[17]);  // FAB_WDATA19
    assign ia[36] = ra[4] ^ (ra[13] & ra[22]);  // FAB_WDATA20
    assign ia[37] = ra[5] ^ (ra[16] & ra[27]);  // FAB_WDATA21
    assign ia[38] = ra[6] ^ (ra[19] & ra[0]);  // FAB_WDATA22
    assign ia[39] = ra[7] ^ (ra[22] & ra[5]);  // FAB_WDATA23
    assign ia[40] = ra[8] ^ (ra[25] & ra[10]);  // FAB_WDATA24
    assign ia[41] = ra[9] ^ (ra[28] & ra[15]);  // FAB_WDATA25
    assign ia[42] = ra[10] ^ (ra[31] & ra[20]);  // FAB_WDATA26
    assign ia[43] = ra[11] ^ (ra[2] & ra[25]);  // FAB_WDATA27
    assign ia[44] = ra[12] ^ (ra[5] & ra[30]);  // FAB_WDATA28
    assign ia[45] = ra[13] ^ (ra[8] & ra[3]);  // FAB_WDATA29
    assign ia[46] = ra[14] ^ (ra[11] & ra[8]);  // FAB_WDATA30
    assign ia[47] = ra[15] ^ (ra[14] & ra[13]);  // FAB_WDATA31
    assign ia[48] = ra[16] ^ (ra[17] & ra[18]);  // FAB_READ_BANK_SEL0
    assign ia[49] = ra[17] ^ (ra[20] & ra[23]);  // FAB_READ_BANK_SEL1
    assign ia[50] = ra[18] ^ (ra[23] & ra[28]);  // FAB_READ_BANK_SEL2
    assign ib[0] = rb[0] ^ (rb[3] & rb[5]);  // FAB_ADDR0
    assign ib[1] = rb[1] ^ (rb[10] & rb[16]);  // FAB_ADDR1
    assign ib[2] = rb[2] ^ (rb[17] & rb[27]);  // FAB_ADDR2
    assign ib[3] = rb[3] ^ (rb[24] & rb[6]);  // FAB_ADDR3
    assign ib[4] = rb[4] ^ (rb[31] & rb[17]);  // FAB_ADDR4
    assign ib[5] = rb[5] ^ (rb[6] & rb[28]);  // FAB_ADDR5
    assign ib[6] = rb[6] ^ (rb[13] & rb[7]);  // FAB_ADDR6
    assign ib[7] = rb[7] ^ (rb[20] & rb[18]);  // FAB_ADDR7
    assign ib[8] = rb[8] ^ (rb[27] & rb[29]);  // FAB_WE0
    assign ib[9] = rb[9] ^ (rb[2] & rb[8]);  // FAB_WE1
    assign ib[10] = rb[10] ^ (rb[9] & rb[19]);  // FAB_WE2
    assign ib[11] = rb[11] ^ (rb[16] & rb[30]);  // FAB_WE3
    assign ib[12] = rb[12] ^ (rb[23] & rb[9]);  // FAB_WE4
    assign ib[13] = rb[13] ^ (rb[30] & rb[20]);  // FAB_WE5
    assign ib[14] = rb[14] ^ (rb[5] & rb[31]);  // FAB_WE6
    assign ib[15] = rb[15] ^ (rb[12] & rb[10]);  // FAB_WE7
    assign ib[16] = rb[16] ^ (rb[19] & rb[21]);  // FAB_WDATA0
    assign ib[17] = rb[17] ^ (rb[26] & rb[0]);  // FAB_WDATA1
    assign ib[18] = rb[18] ^ (rb[1] & rb[11]);  // FAB_WDATA2
    assign ib[19] = rb[19] ^ (rb[8] & rb[22]);  // FAB_WDATA3
    assign ib[20] = rb[20] ^ (rb[15] & rb[1]);  // FAB_WDATA4
    assign ib[21] = rb[21] ^ (rb[22] & rb[12]);  // FAB_WDATA5
    assign ib[22] = rb[22] ^ (rb[29] & rb[23]);  // FAB_WDATA6
    assign ib[23] = rb[23] ^ (rb[4] & rb[2]);  // FAB_WDATA7
    assign ib[24] = rb[24] ^ (rb[11] & rb[13]);  // FAB_WDATA8
    assign ib[25] = rb[25] ^ (rb[18] & rb[24]);  // FAB_WDATA9
    assign ib[26] = rb[26] ^ (rb[25] & rb[3]);  // FAB_WDATA10
    assign ib[27] = rb[27] ^ (rb[0] & rb[14]);  // FAB_WDATA11
    assign ib[28] = rb[28] ^ (rb[7] & rb[25]);  // FAB_WDATA12
    assign ib[29] = rb[29] ^ (rb[14] & rb[4]);  // FAB_WDATA13
    assign ib[30] = rb[30] ^ (rb[21] & rb[15]);  // FAB_WDATA14
    assign ib[31] = rb[31] ^ (rb[28] & rb[26]);  // FAB_WDATA15
    assign ib[32] = rb[0] ^ (rb[3] & rb[5]);  // FAB_WDATA16
    assign ib[33] = rb[1] ^ (rb[10] & rb[16]);  // FAB_WDATA17
    assign ib[34] = rb[2] ^ (rb[17] & rb[27]);  // FAB_WDATA18
    assign ib[35] = rb[3] ^ (rb[24] & rb[6]);  // FAB_WDATA19
    assign ib[36] = rb[4] ^ (rb[31] & rb[17]);  // FAB_WDATA20
    assign ib[37] = rb[5] ^ (rb[6] & rb[28]);  // FAB_WDATA21
    assign ib[38] = rb[6] ^ (rb[13] & rb[7]);  // FAB_WDATA22
    assign ib[39] = rb[7] ^ (rb[20] & rb[18]);  // FAB_WDATA23
    assign ib[40] = rb[8] ^ (rb[27] & rb[29]);  // FAB_WDATA24
    assign ib[41] = rb[9] ^ (rb[2] & rb[8]);  // FAB_WDATA25
    assign ib[42] = rb[10] ^ (rb[9] & rb[19]);  // FAB_WDATA26
    assign ib[43] = rb[11] ^ (rb[16] & rb[30]);  // FAB_WDATA27
    assign ib[44] = rb[12] ^ (rb[23] & rb[9]);  // FAB_WDATA28
    assign ib[45] = rb[13] ^ (rb[30] & rb[20]);  // FAB_WDATA29
    assign ib[46] = rb[14] ^ (rb[5] & rb[31]);  // FAB_WDATA30
    assign ib[47] = rb[15] ^ (rb[12] & rb[10]);  // FAB_WDATA31
    assign ib[48] = rb[16] ^ (rb[19] & rb[21]);  // FAB_READ_BANK_SEL0
    assign ib[49] = rb[17] ^ (rb[26] & rb[0]);  // FAB_READ_BANK_SEL1
    assign ib[50] = rb[18] ^ (rb[1] & rb[11]);  // FAB_READ_BANK_SEL2
endmodule
`resetall

`default_nettype none

// Loopback logic for the NPU_SLICE functional test (see
// npu_slice_loopback_top.v): every BEL input of slice s is a distinct
// function of that slice's {OUT_ACT, ACT_RDATA}. Generated together with
// Test/npu_slice_loopback_tb.v; keep them in sync.
module npu_slice_loopback (
    input  wire [127:0] r,  // slice s: r[16*s +: 16]
    output wire [247:0] i  // slice s: i[31*s +: 31]
);
    assign i[0] = r[0] ^ (r[1] & r[2]);  // slice 0 FAB_ACT_ADDR0
    assign i[1] = r[1] ^ (r[4] & r[7]);  // slice 0 FAB_ACT_ADDR1
    assign i[2] = r[2] ^ (r[7] & r[12]);  // slice 0 FAB_ACT_ADDR2
    assign i[3] = r[3] ^ (r[10] & r[1]);  // slice 0 FAB_ACT_ADDR3
    assign i[4] = r[4] ^ (r[13] & r[6]);  // slice 0 FAB_ACT_ADDR4
    assign i[5] = r[5] ^ (r[0] & r[11]);  // slice 0 FAB_ACT_ADDR5
    assign i[6] = r[6] ^ (r[3] & r[0]);  // slice 0 FAB_ACT_ADDR6
    assign i[7] = r[7] ^ (r[6] & r[5]);  // slice 0 FAB_ACT_ADDR7
    assign i[8] = r[8] ^ (r[9] & r[10]);  // slice 0 FAB_ACT_ADDR8
    assign i[9] = r[9] ^ (r[12] & r[15]);  // slice 0 FAB_ACT_WDATA0
    assign i[10] = r[10] ^ (r[15] & r[4]);  // slice 0 FAB_ACT_WDATA1
    assign i[11] = r[11] ^ (r[2] & r[9]);  // slice 0 FAB_ACT_WDATA2
    assign i[12] = r[12] ^ (r[5] & r[14]);  // slice 0 FAB_ACT_WDATA3
    assign i[13] = r[13] ^ (r[8] & r[3]);  // slice 0 FAB_ACT_WDATA4
    assign i[14] = r[14] ^ (r[11] & r[8]);  // slice 0 FAB_ACT_WDATA5
    assign i[15] = r[15] ^ (r[14] & r[13]);  // slice 0 FAB_ACT_WDATA6
    assign i[16] = r[0] ^ (r[1] & r[2]);  // slice 0 FAB_ACT_WDATA7
    assign i[17] = r[1] ^ (r[4] & r[7]);  // slice 0 FAB_ACT_WE
    assign i[18] = r[2] ^ (r[7] & r[12]);  // slice 0 FAB_WEIGHT_IN0
    assign i[19] = r[3] ^ (r[10] & r[1]);  // slice 0 FAB_WEIGHT_IN1
    assign i[20] = r[4] ^ (r[13] & r[6]);  // slice 0 FAB_WEIGHT_IN2
    assign i[21] = r[5] ^ (r[0] & r[11]);  // slice 0 FAB_WEIGHT_IN3
    assign i[22] = r[6] ^ (r[3] & r[0]);  // slice 0 FAB_WEIGHT_IN4
    assign i[23] = r[7] ^ (r[6] & r[5]);  // slice 0 FAB_WEIGHT_IN5
    assign i[24] = r[8] ^ (r[9] & r[10]);  // slice 0 FAB_WEIGHT_IN6
    assign i[25] = r[9] ^ (r[12] & r[15]);  // slice 0 FAB_WEIGHT_IN7
    assign i[26] = r[10] ^ (r[15] & r[4]);  // slice 0 FAB_WEIGHT_SHIFT_EN
    assign i[27] = r[11] ^ (r[2] & r[9]);  // slice 0 FAB_XBAR_SEL0
    assign i[28] = r[12] ^ (r[5] & r[14]);  // slice 0 FAB_XBAR_SEL1
    assign i[29] = r[13] ^ (r[8] & r[3]);  // slice 0 FAB_XBAR_SEL2
    assign i[30] = r[14] ^ (r[11] & r[8]);  // slice 0 FAB_XBAR_SEL3
    assign i[31] = r[16] ^ (r[18] & r[20]);  // slice 1 FAB_ACT_ADDR0
    assign i[32] = r[17] ^ (r[23] & r[27]);  // slice 1 FAB_ACT_ADDR1
    assign i[33] = r[18] ^ (r[28] & r[18]);  // slice 1 FAB_ACT_ADDR2
    assign i[34] = r[19] ^ (r[17] & r[25]);  // slice 1 FAB_ACT_ADDR3
    assign i[35] = r[20] ^ (r[22] & r[16]);  // slice 1 FAB_ACT_ADDR4
    assign i[36] = r[21] ^ (r[27] & r[23]);  // slice 1 FAB_ACT_ADDR5
    assign i[37] = r[22] ^ (r[16] & r[30]);  // slice 1 FAB_ACT_ADDR6
    assign i[38] = r[23] ^ (r[21] & r[21]);  // slice 1 FAB_ACT_ADDR7
    assign i[39] = r[24] ^ (r[26] & r[28]);  // slice 1 FAB_ACT_ADDR8
    assign i[40] = r[25] ^ (r[31] & r[19]);  // slice 1 FAB_ACT_WDATA0
    assign i[41] = r[26] ^ (r[20] & r[26]);  // slice 1 FAB_ACT_WDATA1
    assign i[42] = r[27] ^ (r[25] & r[17]);  // slice 1 FAB_ACT_WDATA2
    assign i[43] = r[28] ^ (r[30] & r[24]);  // slice 1 FAB_ACT_WDATA3
    assign i[44] = r[29] ^ (r[19] & r[31]);  // slice 1 FAB_ACT_WDATA4
    assign i[45] = r[30] ^ (r[24] & r[22]);  // slice 1 FAB_ACT_WDATA5
    assign i[46] = r[31] ^ (r[29] & r[29]);  // slice 1 FAB_ACT_WDATA6
    assign i[47] = r[16] ^ (r[18] & r[20]);  // slice 1 FAB_ACT_WDATA7
    assign i[48] = r[17] ^ (r[23] & r[27]);  // slice 1 FAB_ACT_WE
    assign i[49] = r[18] ^ (r[28] & r[18]);  // slice 1 FAB_WEIGHT_IN0
    assign i[50] = r[19] ^ (r[17] & r[25]);  // slice 1 FAB_WEIGHT_IN1
    assign i[51] = r[20] ^ (r[22] & r[16]);  // slice 1 FAB_WEIGHT_IN2
    assign i[52] = r[21] ^ (r[27] & r[23]);  // slice 1 FAB_WEIGHT_IN3
    assign i[53] = r[22] ^ (r[16] & r[30]);  // slice 1 FAB_WEIGHT_IN4
    assign i[54] = r[23] ^ (r[21] & r[21]);  // slice 1 FAB_WEIGHT_IN5
    assign i[55] = r[24] ^ (r[26] & r[28]);  // slice 1 FAB_WEIGHT_IN6
    assign i[56] = r[25] ^ (r[31] & r[19]);  // slice 1 FAB_WEIGHT_IN7
    assign i[57] = r[26] ^ (r[20] & r[26]);  // slice 1 FAB_WEIGHT_SHIFT_EN
    assign i[58] = r[27] ^ (r[25] & r[17]);  // slice 1 FAB_XBAR_SEL0
    assign i[59] = r[28] ^ (r[30] & r[24]);  // slice 1 FAB_XBAR_SEL1
    assign i[60] = r[29] ^ (r[19] & r[31]);  // slice 1 FAB_XBAR_SEL2
    assign i[61] = r[30] ^ (r[24] & r[22]);  // slice 1 FAB_XBAR_SEL3
    assign i[62] = r[32] ^ (r[35] & r[38]);  // slice 2 FAB_ACT_ADDR0
    assign i[63] = r[33] ^ (r[42] & r[47]);  // slice 2 FAB_ACT_ADDR1
    assign i[64] = r[34] ^ (r[33] & r[40]);  // slice 2 FAB_ACT_ADDR2
    assign i[65] = r[35] ^ (r[40] & r[33]);  // slice 2 FAB_ACT_ADDR3
    assign i[66] = r[36] ^ (r[47] & r[42]);  // slice 2 FAB_ACT_ADDR4
    assign i[67] = r[37] ^ (r[38] & r[35]);  // slice 2 FAB_ACT_ADDR5
    assign i[68] = r[38] ^ (r[45] & r[44]);  // slice 2 FAB_ACT_ADDR6
    assign i[69] = r[39] ^ (r[36] & r[37]);  // slice 2 FAB_ACT_ADDR7
    assign i[70] = r[40] ^ (r[43] & r[46]);  // slice 2 FAB_ACT_ADDR8
    assign i[71] = r[41] ^ (r[34] & r[39]);  // slice 2 FAB_ACT_WDATA0
    assign i[72] = r[42] ^ (r[41] & r[32]);  // slice 2 FAB_ACT_WDATA1
    assign i[73] = r[43] ^ (r[32] & r[41]);  // slice 2 FAB_ACT_WDATA2
    assign i[74] = r[44] ^ (r[39] & r[34]);  // slice 2 FAB_ACT_WDATA3
    assign i[75] = r[45] ^ (r[46] & r[43]);  // slice 2 FAB_ACT_WDATA4
    assign i[76] = r[46] ^ (r[37] & r[36]);  // slice 2 FAB_ACT_WDATA5
    assign i[77] = r[47] ^ (r[44] & r[45]);  // slice 2 FAB_ACT_WDATA6
    assign i[78] = r[32] ^ (r[35] & r[38]);  // slice 2 FAB_ACT_WDATA7
    assign i[79] = r[33] ^ (r[42] & r[47]);  // slice 2 FAB_ACT_WE
    assign i[80] = r[34] ^ (r[33] & r[40]);  // slice 2 FAB_WEIGHT_IN0
    assign i[81] = r[35] ^ (r[40] & r[33]);  // slice 2 FAB_WEIGHT_IN1
    assign i[82] = r[36] ^ (r[47] & r[42]);  // slice 2 FAB_WEIGHT_IN2
    assign i[83] = r[37] ^ (r[38] & r[35]);  // slice 2 FAB_WEIGHT_IN3
    assign i[84] = r[38] ^ (r[45] & r[44]);  // slice 2 FAB_WEIGHT_IN4
    assign i[85] = r[39] ^ (r[36] & r[37]);  // slice 2 FAB_WEIGHT_IN5
    assign i[86] = r[40] ^ (r[43] & r[46]);  // slice 2 FAB_WEIGHT_IN6
    assign i[87] = r[41] ^ (r[34] & r[39]);  // slice 2 FAB_WEIGHT_IN7
    assign i[88] = r[42] ^ (r[41] & r[32]);  // slice 2 FAB_WEIGHT_SHIFT_EN
    assign i[89] = r[43] ^ (r[32] & r[41]);  // slice 2 FAB_XBAR_SEL0
    assign i[90] = r[44] ^ (r[39] & r[34]);  // slice 2 FAB_XBAR_SEL1
    assign i[91] = r[45] ^ (r[46] & r[43]);  // slice 2 FAB_XBAR_SEL2
    assign i[92] = r[46] ^ (r[37] & r[36]);  // slice 2 FAB_XBAR_SEL3
    assign i[93] = r[48] ^ (r[52] & r[56]);  // slice 3 FAB_ACT_ADDR0
    assign i[94] = r[49] ^ (r[61] & r[51]);  // slice 3 FAB_ACT_ADDR1
    assign i[95] = r[50] ^ (r[54] & r[62]);  // slice 3 FAB_ACT_ADDR2
    assign i[96] = r[51] ^ (r[63] & r[57]);  // slice 3 FAB_ACT_ADDR3
    assign i[97] = r[52] ^ (r[56] & r[52]);  // slice 3 FAB_ACT_ADDR4
    assign i[98] = r[53] ^ (r[49] & r[63]);  // slice 3 FAB_ACT_ADDR5
    assign i[99] = r[54] ^ (r[58] & r[58]);  // slice 3 FAB_ACT_ADDR6
    assign i[100] = r[55] ^ (r[51] & r[53]);  // slice 3 FAB_ACT_ADDR7
    assign i[101] = r[56] ^ (r[60] & r[48]);  // slice 3 FAB_ACT_ADDR8
    assign i[102] = r[57] ^ (r[53] & r[59]);  // slice 3 FAB_ACT_WDATA0
    assign i[103] = r[58] ^ (r[62] & r[54]);  // slice 3 FAB_ACT_WDATA1
    assign i[104] = r[59] ^ (r[55] & r[49]);  // slice 3 FAB_ACT_WDATA2
    assign i[105] = r[60] ^ (r[48] & r[60]);  // slice 3 FAB_ACT_WDATA3
    assign i[106] = r[61] ^ (r[57] & r[55]);  // slice 3 FAB_ACT_WDATA4
    assign i[107] = r[62] ^ (r[50] & r[50]);  // slice 3 FAB_ACT_WDATA5
    assign i[108] = r[63] ^ (r[59] & r[61]);  // slice 3 FAB_ACT_WDATA6
    assign i[109] = r[48] ^ (r[52] & r[56]);  // slice 3 FAB_ACT_WDATA7
    assign i[110] = r[49] ^ (r[61] & r[51]);  // slice 3 FAB_ACT_WE
    assign i[111] = r[50] ^ (r[54] & r[62]);  // slice 3 FAB_WEIGHT_IN0
    assign i[112] = r[51] ^ (r[63] & r[57]);  // slice 3 FAB_WEIGHT_IN1
    assign i[113] = r[52] ^ (r[56] & r[52]);  // slice 3 FAB_WEIGHT_IN2
    assign i[114] = r[53] ^ (r[49] & r[63]);  // slice 3 FAB_WEIGHT_IN3
    assign i[115] = r[54] ^ (r[58] & r[58]);  // slice 3 FAB_WEIGHT_IN4
    assign i[116] = r[55] ^ (r[51] & r[53]);  // slice 3 FAB_WEIGHT_IN5
    assign i[117] = r[56] ^ (r[60] & r[48]);  // slice 3 FAB_WEIGHT_IN6
    assign i[118] = r[57] ^ (r[53] & r[59]);  // slice 3 FAB_WEIGHT_IN7
    assign i[119] = r[58] ^ (r[62] & r[54]);  // slice 3 FAB_WEIGHT_SHIFT_EN
    assign i[120] = r[59] ^ (r[55] & r[49]);  // slice 3 FAB_XBAR_SEL0
    assign i[121] = r[60] ^ (r[48] & r[60]);  // slice 3 FAB_XBAR_SEL1
    assign i[122] = r[61] ^ (r[57] & r[55]);  // slice 3 FAB_XBAR_SEL2
    assign i[123] = r[62] ^ (r[50] & r[50]);  // slice 3 FAB_XBAR_SEL3
    assign i[124] = r[64] ^ (r[69] & r[74]);  // slice 4 FAB_ACT_ADDR0
    assign i[125] = r[65] ^ (r[64] & r[71]);  // slice 4 FAB_ACT_ADDR1
    assign i[126] = r[66] ^ (r[75] & r[68]);  // slice 4 FAB_ACT_ADDR2
    assign i[127] = r[67] ^ (r[70] & r[65]);  // slice 4 FAB_ACT_ADDR3
    assign i[128] = r[68] ^ (r[65] & r[78]);  // slice 4 FAB_ACT_ADDR4
    assign i[129] = r[69] ^ (r[76] & r[75]);  // slice 4 FAB_ACT_ADDR5
    assign i[130] = r[70] ^ (r[71] & r[72]);  // slice 4 FAB_ACT_ADDR6
    assign i[131] = r[71] ^ (r[66] & r[69]);  // slice 4 FAB_ACT_ADDR7
    assign i[132] = r[72] ^ (r[77] & r[66]);  // slice 4 FAB_ACT_ADDR8
    assign i[133] = r[73] ^ (r[72] & r[79]);  // slice 4 FAB_ACT_WDATA0
    assign i[134] = r[74] ^ (r[67] & r[76]);  // slice 4 FAB_ACT_WDATA1
    assign i[135] = r[75] ^ (r[78] & r[73]);  // slice 4 FAB_ACT_WDATA2
    assign i[136] = r[76] ^ (r[73] & r[70]);  // slice 4 FAB_ACT_WDATA3
    assign i[137] = r[77] ^ (r[68] & r[67]);  // slice 4 FAB_ACT_WDATA4
    assign i[138] = r[78] ^ (r[79] & r[64]);  // slice 4 FAB_ACT_WDATA5
    assign i[139] = r[79] ^ (r[74] & r[77]);  // slice 4 FAB_ACT_WDATA6
    assign i[140] = r[64] ^ (r[69] & r[74]);  // slice 4 FAB_ACT_WDATA7
    assign i[141] = r[65] ^ (r[64] & r[71]);  // slice 4 FAB_ACT_WE
    assign i[142] = r[66] ^ (r[75] & r[68]);  // slice 4 FAB_WEIGHT_IN0
    assign i[143] = r[67] ^ (r[70] & r[65]);  // slice 4 FAB_WEIGHT_IN1
    assign i[144] = r[68] ^ (r[65] & r[78]);  // slice 4 FAB_WEIGHT_IN2
    assign i[145] = r[69] ^ (r[76] & r[75]);  // slice 4 FAB_WEIGHT_IN3
    assign i[146] = r[70] ^ (r[71] & r[72]);  // slice 4 FAB_WEIGHT_IN4
    assign i[147] = r[71] ^ (r[66] & r[69]);  // slice 4 FAB_WEIGHT_IN5
    assign i[148] = r[72] ^ (r[77] & r[66]);  // slice 4 FAB_WEIGHT_IN6
    assign i[149] = r[73] ^ (r[72] & r[79]);  // slice 4 FAB_WEIGHT_IN7
    assign i[150] = r[74] ^ (r[67] & r[76]);  // slice 4 FAB_WEIGHT_SHIFT_EN
    assign i[151] = r[75] ^ (r[78] & r[73]);  // slice 4 FAB_XBAR_SEL0
    assign i[152] = r[76] ^ (r[73] & r[70]);  // slice 4 FAB_XBAR_SEL1
    assign i[153] = r[77] ^ (r[68] & r[67]);  // slice 4 FAB_XBAR_SEL2
    assign i[154] = r[78] ^ (r[79] & r[64]);  // slice 4 FAB_XBAR_SEL3
    assign i[155] = r[80] ^ (r[86] & r[92]);  // slice 5 FAB_ACT_ADDR0
    assign i[156] = r[81] ^ (r[83] & r[91]);  // slice 5 FAB_ACT_ADDR1
    assign i[157] = r[82] ^ (r[80] & r[90]);  // slice 5 FAB_ACT_ADDR2
    assign i[158] = r[83] ^ (r[93] & r[89]);  // slice 5 FAB_ACT_ADDR3
    assign i[159] = r[84] ^ (r[90] & r[88]);  // slice 5 FAB_ACT_ADDR4
    assign i[160] = r[85] ^ (r[87] & r[87]);  // slice 5 FAB_ACT_ADDR5
    assign i[161] = r[86] ^ (r[84] & r[86]);  // slice 5 FAB_ACT_ADDR6
    assign i[162] = r[87] ^ (r[81] & r[85]);  // slice 5 FAB_ACT_ADDR7
    assign i[163] = r[88] ^ (r[94] & r[84]);  // slice 5 FAB_ACT_ADDR8
    assign i[164] = r[89] ^ (r[91] & r[83]);  // slice 5 FAB_ACT_WDATA0
    assign i[165] = r[90] ^ (r[88] & r[82]);  // slice 5 FAB_ACT_WDATA1
    assign i[166] = r[91] ^ (r[85] & r[81]);  // slice 5 FAB_ACT_WDATA2
    assign i[167] = r[92] ^ (r[82] & r[80]);  // slice 5 FAB_ACT_WDATA3
    assign i[168] = r[93] ^ (r[95] & r[95]);  // slice 5 FAB_ACT_WDATA4
    assign i[169] = r[94] ^ (r[92] & r[94]);  // slice 5 FAB_ACT_WDATA5
    assign i[170] = r[95] ^ (r[89] & r[93]);  // slice 5 FAB_ACT_WDATA6
    assign i[171] = r[80] ^ (r[86] & r[92]);  // slice 5 FAB_ACT_WDATA7
    assign i[172] = r[81] ^ (r[83] & r[91]);  // slice 5 FAB_ACT_WE
    assign i[173] = r[82] ^ (r[80] & r[90]);  // slice 5 FAB_WEIGHT_IN0
    assign i[174] = r[83] ^ (r[93] & r[89]);  // slice 5 FAB_WEIGHT_IN1
    assign i[175] = r[84] ^ (r[90] & r[88]);  // slice 5 FAB_WEIGHT_IN2
    assign i[176] = r[85] ^ (r[87] & r[87]);  // slice 5 FAB_WEIGHT_IN3
    assign i[177] = r[86] ^ (r[84] & r[86]);  // slice 5 FAB_WEIGHT_IN4
    assign i[178] = r[87] ^ (r[81] & r[85]);  // slice 5 FAB_WEIGHT_IN5
    assign i[179] = r[88] ^ (r[94] & r[84]);  // slice 5 FAB_WEIGHT_IN6
    assign i[180] = r[89] ^ (r[91] & r[83]);  // slice 5 FAB_WEIGHT_IN7
    assign i[181] = r[90] ^ (r[88] & r[82]);  // slice 5 FAB_WEIGHT_SHIFT_EN
    assign i[182] = r[91] ^ (r[85] & r[81]);  // slice 5 FAB_XBAR_SEL0
    assign i[183] = r[92] ^ (r[82] & r[80]);  // slice 5 FAB_XBAR_SEL1
    assign i[184] = r[93] ^ (r[95] & r[95]);  // slice 5 FAB_XBAR_SEL2
    assign i[185] = r[94] ^ (r[92] & r[94]);  // slice 5 FAB_XBAR_SEL3
    assign i[186] = r[96] ^ (r[103] & r[110]);  // slice 6 FAB_ACT_ADDR0
    assign i[187] = r[97] ^ (r[102] & r[111]);  // slice 6 FAB_ACT_ADDR1
    assign i[188] = r[98] ^ (r[101] & r[96]);  // slice 6 FAB_ACT_ADDR2
    assign i[189] = r[99] ^ (r[100] & r[97]);  // slice 6 FAB_ACT_ADDR3
    assign i[190] = r[100] ^ (r[99] & r[98]);  // slice 6 FAB_ACT_ADDR4
    assign i[191] = r[101] ^ (r[98] & r[99]);  // slice 6 FAB_ACT_ADDR5
    assign i[192] = r[102] ^ (r[97] & r[100]);  // slice 6 FAB_ACT_ADDR6
    assign i[193] = r[103] ^ (r[96] & r[101]);  // slice 6 FAB_ACT_ADDR7
    assign i[194] = r[104] ^ (r[111] & r[102]);  // slice 6 FAB_ACT_ADDR8
    assign i[195] = r[105] ^ (r[110] & r[103]);  // slice 6 FAB_ACT_WDATA0
    assign i[196] = r[106] ^ (r[109] & r[104]);  // slice 6 FAB_ACT_WDATA1
    assign i[197] = r[107] ^ (r[108] & r[105]);  // slice 6 FAB_ACT_WDATA2
    assign i[198] = r[108] ^ (r[107] & r[106]);  // slice 6 FAB_ACT_WDATA3
    assign i[199] = r[109] ^ (r[106] & r[107]);  // slice 6 FAB_ACT_WDATA4
    assign i[200] = r[110] ^ (r[105] & r[108]);  // slice 6 FAB_ACT_WDATA5
    assign i[201] = r[111] ^ (r[104] & r[109]);  // slice 6 FAB_ACT_WDATA6
    assign i[202] = r[96] ^ (r[103] & r[110]);  // slice 6 FAB_ACT_WDATA7
    assign i[203] = r[97] ^ (r[102] & r[111]);  // slice 6 FAB_ACT_WE
    assign i[204] = r[98] ^ (r[101] & r[96]);  // slice 6 FAB_WEIGHT_IN0
    assign i[205] = r[99] ^ (r[100] & r[97]);  // slice 6 FAB_WEIGHT_IN1
    assign i[206] = r[100] ^ (r[99] & r[98]);  // slice 6 FAB_WEIGHT_IN2
    assign i[207] = r[101] ^ (r[98] & r[99]);  // slice 6 FAB_WEIGHT_IN3
    assign i[208] = r[102] ^ (r[97] & r[100]);  // slice 6 FAB_WEIGHT_IN4
    assign i[209] = r[103] ^ (r[96] & r[101]);  // slice 6 FAB_WEIGHT_IN5
    assign i[210] = r[104] ^ (r[111] & r[102]);  // slice 6 FAB_WEIGHT_IN6
    assign i[211] = r[105] ^ (r[110] & r[103]);  // slice 6 FAB_WEIGHT_IN7
    assign i[212] = r[106] ^ (r[109] & r[104]);  // slice 6 FAB_WEIGHT_SHIFT_EN
    assign i[213] = r[107] ^ (r[108] & r[105]);  // slice 6 FAB_XBAR_SEL0
    assign i[214] = r[108] ^ (r[107] & r[106]);  // slice 6 FAB_XBAR_SEL1
    assign i[215] = r[109] ^ (r[106] & r[107]);  // slice 6 FAB_XBAR_SEL2
    assign i[216] = r[110] ^ (r[105] & r[108]);  // slice 6 FAB_XBAR_SEL3
    assign i[217] = r[112] ^ (r[120] & r[112]);  // slice 7 FAB_ACT_ADDR0
    assign i[218] = r[113] ^ (r[121] & r[115]);  // slice 7 FAB_ACT_ADDR1
    assign i[219] = r[114] ^ (r[122] & r[118]);  // slice 7 FAB_ACT_ADDR2
    assign i[220] = r[115] ^ (r[123] & r[121]);  // slice 7 FAB_ACT_ADDR3
    assign i[221] = r[116] ^ (r[124] & r[124]);  // slice 7 FAB_ACT_ADDR4
    assign i[222] = r[117] ^ (r[125] & r[127]);  // slice 7 FAB_ACT_ADDR5
    assign i[223] = r[118] ^ (r[126] & r[114]);  // slice 7 FAB_ACT_ADDR6
    assign i[224] = r[119] ^ (r[127] & r[117]);  // slice 7 FAB_ACT_ADDR7
    assign i[225] = r[120] ^ (r[112] & r[120]);  // slice 7 FAB_ACT_ADDR8
    assign i[226] = r[121] ^ (r[113] & r[123]);  // slice 7 FAB_ACT_WDATA0
    assign i[227] = r[122] ^ (r[114] & r[126]);  // slice 7 FAB_ACT_WDATA1
    assign i[228] = r[123] ^ (r[115] & r[113]);  // slice 7 FAB_ACT_WDATA2
    assign i[229] = r[124] ^ (r[116] & r[116]);  // slice 7 FAB_ACT_WDATA3
    assign i[230] = r[125] ^ (r[117] & r[119]);  // slice 7 FAB_ACT_WDATA4
    assign i[231] = r[126] ^ (r[118] & r[122]);  // slice 7 FAB_ACT_WDATA5
    assign i[232] = r[127] ^ (r[119] & r[125]);  // slice 7 FAB_ACT_WDATA6
    assign i[233] = r[112] ^ (r[120] & r[112]);  // slice 7 FAB_ACT_WDATA7
    assign i[234] = r[113] ^ (r[121] & r[115]);  // slice 7 FAB_ACT_WE
    assign i[235] = r[114] ^ (r[122] & r[118]);  // slice 7 FAB_WEIGHT_IN0
    assign i[236] = r[115] ^ (r[123] & r[121]);  // slice 7 FAB_WEIGHT_IN1
    assign i[237] = r[116] ^ (r[124] & r[124]);  // slice 7 FAB_WEIGHT_IN2
    assign i[238] = r[117] ^ (r[125] & r[127]);  // slice 7 FAB_WEIGHT_IN3
    assign i[239] = r[118] ^ (r[126] & r[114]);  // slice 7 FAB_WEIGHT_IN4
    assign i[240] = r[119] ^ (r[127] & r[117]);  // slice 7 FAB_WEIGHT_IN5
    assign i[241] = r[120] ^ (r[112] & r[120]);  // slice 7 FAB_WEIGHT_IN6
    assign i[242] = r[121] ^ (r[113] & r[123]);  // slice 7 FAB_WEIGHT_IN7
    assign i[243] = r[122] ^ (r[114] & r[126]);  // slice 7 FAB_WEIGHT_SHIFT_EN
    assign i[244] = r[123] ^ (r[115] & r[113]);  // slice 7 FAB_XBAR_SEL0
    assign i[245] = r[124] ^ (r[116] & r[116]);  // slice 7 FAB_XBAR_SEL1
    assign i[246] = r[125] ^ (r[117] & r[119]);  // slice 7 FAB_XBAR_SEL2
    assign i[247] = r[126] ^ (r[118] & r[122]);  // slice 7 FAB_XBAR_SEL3
endmodule
`resetall
