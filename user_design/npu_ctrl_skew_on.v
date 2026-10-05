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
