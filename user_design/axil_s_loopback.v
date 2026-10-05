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
