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
