`timescale 1ps / 1ps
`default_nettype none

// NPU_SLICE functional test: loads the bitstream, drives random NPU_ACT_RDATA
// and NPU_OUT_ACT for all 8 slices every cycle and checks every NPU output
// against a model of the eight NPU_SLICE_DATA_SRAM_BELs (capture registers,
// fabric loopback, launch registers, crossbar and write-lock config bits)
// using the functions in user_design/npu_slice_loopback.v.
// Build: task build-test-design run-simulation DESIGN=npu_slice_loopback
//        TOP_WRAPPER=npu_slice_loopback_top
module npu_slice_loopback_tb;
    reg  [63:0] NPU_ACT_RDATA = 0, NPU_OUT_ACT = 0;
    wire [71:0] NPU_ACT_ADDR;
    wire [63:0] NPU_ACT_WDATA, NPU_WEIGHT_IN;
    wire [7:0]  NPU_ACT_WE, NPU_WEIGHT_SHIFT_EN;
    wire [31:0] NPU_XBAR_SEL;

    reg         CLK = 1'b0;
    reg         resetn = 1'b1;
    reg         self_write_strobe = 1'b0;
    reg  [31:0] self_write_data = 32'b0;

    eFPGA_top top_i (
        .NPU_ACT_RDATA      (NPU_ACT_RDATA),
        .NPU_OUT_ACT        (NPU_OUT_ACT),
        .NPU_ACT_ADDR       (NPU_ACT_ADDR),
        .NPU_ACT_WDATA      (NPU_ACT_WDATA),
        .NPU_ACT_WE         (NPU_ACT_WE),
        .NPU_WEIGHT_IN      (NPU_WEIGHT_IN),
        .NPU_WEIGHT_SHIFT_EN(NPU_WEIGHT_SHIFT_EN),
        .NPU_XBAR_SEL       (NPU_XBAR_SEL),
        .CLK                (CLK),
        .resetn             (resetn),
        .SelfWriteStrobe    (self_write_strobe),
        .SelfWriteData      (self_write_data),
        .Rx                 (1'b1),
        .ComActive          (),
        .ReceiveLED         (),
        .s_clk              (1'b0),
        .s_data             (1'b0)
    );

    // slice 0 (bus slice 7): FORCE_ZERO_XBAR=0 STATIC_XBAR_EN=0 STATIC_XBAR_VAL=3'b000 WRITE_LOCK=0
    reg  [15:0] m_r0;
    reg  [30:0] m_i0;
    always @(posedge CLK) begin
        m_r0 <= {NPU_OUT_ACT[63:56], NPU_ACT_RDATA[63:56]};
        m_i0[0] <= m_r0[0] ^ (m_r0[1] & m_r0[2]);
        m_i0[1] <= m_r0[1] ^ (m_r0[4] & m_r0[7]);
        m_i0[2] <= m_r0[2] ^ (m_r0[7] & m_r0[12]);
        m_i0[3] <= m_r0[3] ^ (m_r0[10] & m_r0[1]);
        m_i0[4] <= m_r0[4] ^ (m_r0[13] & m_r0[6]);
        m_i0[5] <= m_r0[5] ^ (m_r0[0] & m_r0[11]);
        m_i0[6] <= m_r0[6] ^ (m_r0[3] & m_r0[0]);
        m_i0[7] <= m_r0[7] ^ (m_r0[6] & m_r0[5]);
        m_i0[8] <= m_r0[8] ^ (m_r0[9] & m_r0[10]);
        m_i0[9] <= m_r0[9] ^ (m_r0[12] & m_r0[15]);
        m_i0[10] <= m_r0[10] ^ (m_r0[15] & m_r0[4]);
        m_i0[11] <= m_r0[11] ^ (m_r0[2] & m_r0[9]);
        m_i0[12] <= m_r0[12] ^ (m_r0[5] & m_r0[14]);
        m_i0[13] <= m_r0[13] ^ (m_r0[8] & m_r0[3]);
        m_i0[14] <= m_r0[14] ^ (m_r0[11] & m_r0[8]);
        m_i0[15] <= m_r0[15] ^ (m_r0[14] & m_r0[13]);
        m_i0[16] <= m_r0[0] ^ (m_r0[1] & m_r0[2]);
        m_i0[17] <= m_r0[1] ^ (m_r0[4] & m_r0[7]);
        m_i0[18] <= m_r0[2] ^ (m_r0[7] & m_r0[12]);
        m_i0[19] <= m_r0[3] ^ (m_r0[10] & m_r0[1]);
        m_i0[20] <= m_r0[4] ^ (m_r0[13] & m_r0[6]);
        m_i0[21] <= m_r0[5] ^ (m_r0[0] & m_r0[11]);
        m_i0[22] <= m_r0[6] ^ (m_r0[3] & m_r0[0]);
        m_i0[23] <= m_r0[7] ^ (m_r0[6] & m_r0[5]);
        m_i0[24] <= m_r0[8] ^ (m_r0[9] & m_r0[10]);
        m_i0[25] <= m_r0[9] ^ (m_r0[12] & m_r0[15]);
        m_i0[26] <= m_r0[10] ^ (m_r0[15] & m_r0[4]);
        m_i0[27] <= m_r0[11] ^ (m_r0[2] & m_r0[9]);
        m_i0[28] <= m_r0[12] ^ (m_r0[5] & m_r0[14]);
        m_i0[29] <= m_r0[13] ^ (m_r0[8] & m_r0[3]);
        m_i0[30] <= m_r0[14] ^ (m_r0[11] & m_r0[8]);
    end
    wire [8:0] e_addr0  = m_i0[8:0];
    wire [7:0] e_wdata0 = m_i0[16:9];
    wire       e_we0    = m_i0[17];
    wire [7:0] e_wt0    = m_i0[25:18];
    wire       e_wse0   = m_i0[26];
    wire [3:0] e_xbar0  = {m_i0[30], m_i0[29:27]};
    // slice 1 (bus slice 6): FORCE_ZERO_XBAR=1 STATIC_XBAR_EN=0 STATIC_XBAR_VAL=3'b000 WRITE_LOCK=0
    reg  [15:0] m_r1;
    reg  [30:0] m_i1;
    always @(posedge CLK) begin
        m_r1 <= {NPU_OUT_ACT[55:48], NPU_ACT_RDATA[55:48]};
        m_i1[0] <= m_r1[0] ^ (m_r1[2] & m_r1[4]);
        m_i1[1] <= m_r1[1] ^ (m_r1[7] & m_r1[11]);
        m_i1[2] <= m_r1[2] ^ (m_r1[12] & m_r1[2]);
        m_i1[3] <= m_r1[3] ^ (m_r1[1] & m_r1[9]);
        m_i1[4] <= m_r1[4] ^ (m_r1[6] & m_r1[0]);
        m_i1[5] <= m_r1[5] ^ (m_r1[11] & m_r1[7]);
        m_i1[6] <= m_r1[6] ^ (m_r1[0] & m_r1[14]);
        m_i1[7] <= m_r1[7] ^ (m_r1[5] & m_r1[5]);
        m_i1[8] <= m_r1[8] ^ (m_r1[10] & m_r1[12]);
        m_i1[9] <= m_r1[9] ^ (m_r1[15] & m_r1[3]);
        m_i1[10] <= m_r1[10] ^ (m_r1[4] & m_r1[10]);
        m_i1[11] <= m_r1[11] ^ (m_r1[9] & m_r1[1]);
        m_i1[12] <= m_r1[12] ^ (m_r1[14] & m_r1[8]);
        m_i1[13] <= m_r1[13] ^ (m_r1[3] & m_r1[15]);
        m_i1[14] <= m_r1[14] ^ (m_r1[8] & m_r1[6]);
        m_i1[15] <= m_r1[15] ^ (m_r1[13] & m_r1[13]);
        m_i1[16] <= m_r1[0] ^ (m_r1[2] & m_r1[4]);
        m_i1[17] <= m_r1[1] ^ (m_r1[7] & m_r1[11]);
        m_i1[18] <= m_r1[2] ^ (m_r1[12] & m_r1[2]);
        m_i1[19] <= m_r1[3] ^ (m_r1[1] & m_r1[9]);
        m_i1[20] <= m_r1[4] ^ (m_r1[6] & m_r1[0]);
        m_i1[21] <= m_r1[5] ^ (m_r1[11] & m_r1[7]);
        m_i1[22] <= m_r1[6] ^ (m_r1[0] & m_r1[14]);
        m_i1[23] <= m_r1[7] ^ (m_r1[5] & m_r1[5]);
        m_i1[24] <= m_r1[8] ^ (m_r1[10] & m_r1[12]);
        m_i1[25] <= m_r1[9] ^ (m_r1[15] & m_r1[3]);
        m_i1[26] <= m_r1[10] ^ (m_r1[4] & m_r1[10]);
        m_i1[27] <= m_r1[11] ^ (m_r1[9] & m_r1[1]);
        m_i1[28] <= m_r1[12] ^ (m_r1[14] & m_r1[8]);
        m_i1[29] <= m_r1[13] ^ (m_r1[3] & m_r1[15]);
        m_i1[30] <= m_r1[14] ^ (m_r1[8] & m_r1[6]);
    end
    wire [8:0] e_addr1  = m_i1[8:0];
    wire [7:0] e_wdata1 = m_i1[16:9];
    wire       e_we1    = m_i1[17];
    wire [7:0] e_wt1    = m_i1[25:18];
    wire       e_wse1   = m_i1[26];
    wire [3:0] e_xbar1  = {1'b1, m_i1[29:27]};
    // slice 2 (bus slice 5): FORCE_ZERO_XBAR=0 STATIC_XBAR_EN=1 STATIC_XBAR_VAL=3'b101 WRITE_LOCK=0
    reg  [15:0] m_r2;
    reg  [30:0] m_i2;
    always @(posedge CLK) begin
        m_r2 <= {NPU_OUT_ACT[47:40], NPU_ACT_RDATA[47:40]};
        m_i2[0] <= m_r2[0] ^ (m_r2[3] & m_r2[6]);
        m_i2[1] <= m_r2[1] ^ (m_r2[10] & m_r2[15]);
        m_i2[2] <= m_r2[2] ^ (m_r2[1] & m_r2[8]);
        m_i2[3] <= m_r2[3] ^ (m_r2[8] & m_r2[1]);
        m_i2[4] <= m_r2[4] ^ (m_r2[15] & m_r2[10]);
        m_i2[5] <= m_r2[5] ^ (m_r2[6] & m_r2[3]);
        m_i2[6] <= m_r2[6] ^ (m_r2[13] & m_r2[12]);
        m_i2[7] <= m_r2[7] ^ (m_r2[4] & m_r2[5]);
        m_i2[8] <= m_r2[8] ^ (m_r2[11] & m_r2[14]);
        m_i2[9] <= m_r2[9] ^ (m_r2[2] & m_r2[7]);
        m_i2[10] <= m_r2[10] ^ (m_r2[9] & m_r2[0]);
        m_i2[11] <= m_r2[11] ^ (m_r2[0] & m_r2[9]);
        m_i2[12] <= m_r2[12] ^ (m_r2[7] & m_r2[2]);
        m_i2[13] <= m_r2[13] ^ (m_r2[14] & m_r2[11]);
        m_i2[14] <= m_r2[14] ^ (m_r2[5] & m_r2[4]);
        m_i2[15] <= m_r2[15] ^ (m_r2[12] & m_r2[13]);
        m_i2[16] <= m_r2[0] ^ (m_r2[3] & m_r2[6]);
        m_i2[17] <= m_r2[1] ^ (m_r2[10] & m_r2[15]);
        m_i2[18] <= m_r2[2] ^ (m_r2[1] & m_r2[8]);
        m_i2[19] <= m_r2[3] ^ (m_r2[8] & m_r2[1]);
        m_i2[20] <= m_r2[4] ^ (m_r2[15] & m_r2[10]);
        m_i2[21] <= m_r2[5] ^ (m_r2[6] & m_r2[3]);
        m_i2[22] <= m_r2[6] ^ (m_r2[13] & m_r2[12]);
        m_i2[23] <= m_r2[7] ^ (m_r2[4] & m_r2[5]);
        m_i2[24] <= m_r2[8] ^ (m_r2[11] & m_r2[14]);
        m_i2[25] <= m_r2[9] ^ (m_r2[2] & m_r2[7]);
        m_i2[26] <= m_r2[10] ^ (m_r2[9] & m_r2[0]);
        m_i2[27] <= m_r2[11] ^ (m_r2[0] & m_r2[9]);
        m_i2[28] <= m_r2[12] ^ (m_r2[7] & m_r2[2]);
        m_i2[29] <= m_r2[13] ^ (m_r2[14] & m_r2[11]);
        m_i2[30] <= m_r2[14] ^ (m_r2[5] & m_r2[4]);
    end
    wire [8:0] e_addr2  = m_i2[8:0];
    wire [7:0] e_wdata2 = m_i2[16:9];
    wire       e_we2    = m_i2[17];
    wire [7:0] e_wt2    = m_i2[25:18];
    wire       e_wse2   = m_i2[26];
    wire [3:0] e_xbar2  = {m_i2[30], 3'b101};
    // slice 3 (bus slice 4): FORCE_ZERO_XBAR=1 STATIC_XBAR_EN=1 STATIC_XBAR_VAL=3'b010 WRITE_LOCK=0
    reg  [15:0] m_r3;
    reg  [30:0] m_i3;
    always @(posedge CLK) begin
        m_r3 <= {NPU_OUT_ACT[39:32], NPU_ACT_RDATA[39:32]};
        m_i3[0] <= m_r3[0] ^ (m_r3[4] & m_r3[8]);
        m_i3[1] <= m_r3[1] ^ (m_r3[13] & m_r3[3]);
        m_i3[2] <= m_r3[2] ^ (m_r3[6] & m_r3[14]);
        m_i3[3] <= m_r3[3] ^ (m_r3[15] & m_r3[9]);
        m_i3[4] <= m_r3[4] ^ (m_r3[8] & m_r3[4]);
        m_i3[5] <= m_r3[5] ^ (m_r3[1] & m_r3[15]);
        m_i3[6] <= m_r3[6] ^ (m_r3[10] & m_r3[10]);
        m_i3[7] <= m_r3[7] ^ (m_r3[3] & m_r3[5]);
        m_i3[8] <= m_r3[8] ^ (m_r3[12] & m_r3[0]);
        m_i3[9] <= m_r3[9] ^ (m_r3[5] & m_r3[11]);
        m_i3[10] <= m_r3[10] ^ (m_r3[14] & m_r3[6]);
        m_i3[11] <= m_r3[11] ^ (m_r3[7] & m_r3[1]);
        m_i3[12] <= m_r3[12] ^ (m_r3[0] & m_r3[12]);
        m_i3[13] <= m_r3[13] ^ (m_r3[9] & m_r3[7]);
        m_i3[14] <= m_r3[14] ^ (m_r3[2] & m_r3[2]);
        m_i3[15] <= m_r3[15] ^ (m_r3[11] & m_r3[13]);
        m_i3[16] <= m_r3[0] ^ (m_r3[4] & m_r3[8]);
        m_i3[17] <= m_r3[1] ^ (m_r3[13] & m_r3[3]);
        m_i3[18] <= m_r3[2] ^ (m_r3[6] & m_r3[14]);
        m_i3[19] <= m_r3[3] ^ (m_r3[15] & m_r3[9]);
        m_i3[20] <= m_r3[4] ^ (m_r3[8] & m_r3[4]);
        m_i3[21] <= m_r3[5] ^ (m_r3[1] & m_r3[15]);
        m_i3[22] <= m_r3[6] ^ (m_r3[10] & m_r3[10]);
        m_i3[23] <= m_r3[7] ^ (m_r3[3] & m_r3[5]);
        m_i3[24] <= m_r3[8] ^ (m_r3[12] & m_r3[0]);
        m_i3[25] <= m_r3[9] ^ (m_r3[5] & m_r3[11]);
        m_i3[26] <= m_r3[10] ^ (m_r3[14] & m_r3[6]);
        m_i3[27] <= m_r3[11] ^ (m_r3[7] & m_r3[1]);
        m_i3[28] <= m_r3[12] ^ (m_r3[0] & m_r3[12]);
        m_i3[29] <= m_r3[13] ^ (m_r3[9] & m_r3[7]);
        m_i3[30] <= m_r3[14] ^ (m_r3[2] & m_r3[2]);
    end
    wire [8:0] e_addr3  = m_i3[8:0];
    wire [7:0] e_wdata3 = m_i3[16:9];
    wire       e_we3    = m_i3[17];
    wire [7:0] e_wt3    = m_i3[25:18];
    wire       e_wse3   = m_i3[26];
    wire [3:0] e_xbar3  = {1'b1, 3'b010};
    // slice 4 (bus slice 3): FORCE_ZERO_XBAR=0 STATIC_XBAR_EN=0 STATIC_XBAR_VAL=3'b000 WRITE_LOCK=1
    reg  [15:0] m_r4;
    reg  [30:0] m_i4;
    always @(posedge CLK) begin
        m_r4 <= {NPU_OUT_ACT[31:24], NPU_ACT_RDATA[31:24]};
        m_i4[0] <= m_r4[0] ^ (m_r4[5] & m_r4[10]);
        m_i4[1] <= m_r4[1] ^ (m_r4[0] & m_r4[7]);
        m_i4[2] <= m_r4[2] ^ (m_r4[11] & m_r4[4]);
        m_i4[3] <= m_r4[3] ^ (m_r4[6] & m_r4[1]);
        m_i4[4] <= m_r4[4] ^ (m_r4[1] & m_r4[14]);
        m_i4[5] <= m_r4[5] ^ (m_r4[12] & m_r4[11]);
        m_i4[6] <= m_r4[6] ^ (m_r4[7] & m_r4[8]);
        m_i4[7] <= m_r4[7] ^ (m_r4[2] & m_r4[5]);
        m_i4[8] <= m_r4[8] ^ (m_r4[13] & m_r4[2]);
        m_i4[9] <= m_r4[9] ^ (m_r4[8] & m_r4[15]);
        m_i4[10] <= m_r4[10] ^ (m_r4[3] & m_r4[12]);
        m_i4[11] <= m_r4[11] ^ (m_r4[14] & m_r4[9]);
        m_i4[12] <= m_r4[12] ^ (m_r4[9] & m_r4[6]);
        m_i4[13] <= m_r4[13] ^ (m_r4[4] & m_r4[3]);
        m_i4[14] <= m_r4[14] ^ (m_r4[15] & m_r4[0]);
        m_i4[15] <= m_r4[15] ^ (m_r4[10] & m_r4[13]);
        m_i4[16] <= m_r4[0] ^ (m_r4[5] & m_r4[10]);
        m_i4[17] <= m_r4[1] ^ (m_r4[0] & m_r4[7]);
        m_i4[18] <= m_r4[2] ^ (m_r4[11] & m_r4[4]);
        m_i4[19] <= m_r4[3] ^ (m_r4[6] & m_r4[1]);
        m_i4[20] <= m_r4[4] ^ (m_r4[1] & m_r4[14]);
        m_i4[21] <= m_r4[5] ^ (m_r4[12] & m_r4[11]);
        m_i4[22] <= m_r4[6] ^ (m_r4[7] & m_r4[8]);
        m_i4[23] <= m_r4[7] ^ (m_r4[2] & m_r4[5]);
        m_i4[24] <= m_r4[8] ^ (m_r4[13] & m_r4[2]);
        m_i4[25] <= m_r4[9] ^ (m_r4[8] & m_r4[15]);
        m_i4[26] <= m_r4[10] ^ (m_r4[3] & m_r4[12]);
        m_i4[27] <= m_r4[11] ^ (m_r4[14] & m_r4[9]);
        m_i4[28] <= m_r4[12] ^ (m_r4[9] & m_r4[6]);
        m_i4[29] <= m_r4[13] ^ (m_r4[4] & m_r4[3]);
        m_i4[30] <= m_r4[14] ^ (m_r4[15] & m_r4[0]);
    end
    wire [8:0] e_addr4  = m_i4[8:0];
    wire [7:0] e_wdata4 = m_i4[16:9];
    wire       e_we4    = 1'b0;
    wire [7:0] e_wt4    = m_i4[25:18];
    wire       e_wse4   = m_i4[26];
    wire [3:0] e_xbar4  = {m_i4[30], m_i4[29:27]};
    // slice 5 (bus slice 2): FORCE_ZERO_XBAR=1 STATIC_XBAR_EN=1 STATIC_XBAR_VAL=3'b111 WRITE_LOCK=1
    reg  [15:0] m_r5;
    reg  [30:0] m_i5;
    always @(posedge CLK) begin
        m_r5 <= {NPU_OUT_ACT[23:16], NPU_ACT_RDATA[23:16]};
        m_i5[0] <= m_r5[0] ^ (m_r5[6] & m_r5[12]);
        m_i5[1] <= m_r5[1] ^ (m_r5[3] & m_r5[11]);
        m_i5[2] <= m_r5[2] ^ (m_r5[0] & m_r5[10]);
        m_i5[3] <= m_r5[3] ^ (m_r5[13] & m_r5[9]);
        m_i5[4] <= m_r5[4] ^ (m_r5[10] & m_r5[8]);
        m_i5[5] <= m_r5[5] ^ (m_r5[7] & m_r5[7]);
        m_i5[6] <= m_r5[6] ^ (m_r5[4] & m_r5[6]);
        m_i5[7] <= m_r5[7] ^ (m_r5[1] & m_r5[5]);
        m_i5[8] <= m_r5[8] ^ (m_r5[14] & m_r5[4]);
        m_i5[9] <= m_r5[9] ^ (m_r5[11] & m_r5[3]);
        m_i5[10] <= m_r5[10] ^ (m_r5[8] & m_r5[2]);
        m_i5[11] <= m_r5[11] ^ (m_r5[5] & m_r5[1]);
        m_i5[12] <= m_r5[12] ^ (m_r5[2] & m_r5[0]);
        m_i5[13] <= m_r5[13] ^ (m_r5[15] & m_r5[15]);
        m_i5[14] <= m_r5[14] ^ (m_r5[12] & m_r5[14]);
        m_i5[15] <= m_r5[15] ^ (m_r5[9] & m_r5[13]);
        m_i5[16] <= m_r5[0] ^ (m_r5[6] & m_r5[12]);
        m_i5[17] <= m_r5[1] ^ (m_r5[3] & m_r5[11]);
        m_i5[18] <= m_r5[2] ^ (m_r5[0] & m_r5[10]);
        m_i5[19] <= m_r5[3] ^ (m_r5[13] & m_r5[9]);
        m_i5[20] <= m_r5[4] ^ (m_r5[10] & m_r5[8]);
        m_i5[21] <= m_r5[5] ^ (m_r5[7] & m_r5[7]);
        m_i5[22] <= m_r5[6] ^ (m_r5[4] & m_r5[6]);
        m_i5[23] <= m_r5[7] ^ (m_r5[1] & m_r5[5]);
        m_i5[24] <= m_r5[8] ^ (m_r5[14] & m_r5[4]);
        m_i5[25] <= m_r5[9] ^ (m_r5[11] & m_r5[3]);
        m_i5[26] <= m_r5[10] ^ (m_r5[8] & m_r5[2]);
        m_i5[27] <= m_r5[11] ^ (m_r5[5] & m_r5[1]);
        m_i5[28] <= m_r5[12] ^ (m_r5[2] & m_r5[0]);
        m_i5[29] <= m_r5[13] ^ (m_r5[15] & m_r5[15]);
        m_i5[30] <= m_r5[14] ^ (m_r5[12] & m_r5[14]);
    end
    wire [8:0] e_addr5  = m_i5[8:0];
    wire [7:0] e_wdata5 = m_i5[16:9];
    wire       e_we5    = 1'b0;
    wire [7:0] e_wt5    = m_i5[25:18];
    wire       e_wse5   = m_i5[26];
    wire [3:0] e_xbar5  = {1'b1, 3'b111};
    // slice 6 (bus slice 1): FORCE_ZERO_XBAR=0 STATIC_XBAR_EN=1 STATIC_XBAR_VAL=3'b000 WRITE_LOCK=0
    reg  [15:0] m_r6;
    reg  [30:0] m_i6;
    always @(posedge CLK) begin
        m_r6 <= {NPU_OUT_ACT[15:8], NPU_ACT_RDATA[15:8]};
        m_i6[0] <= m_r6[0] ^ (m_r6[7] & m_r6[14]);
        m_i6[1] <= m_r6[1] ^ (m_r6[6] & m_r6[15]);
        m_i6[2] <= m_r6[2] ^ (m_r6[5] & m_r6[0]);
        m_i6[3] <= m_r6[3] ^ (m_r6[4] & m_r6[1]);
        m_i6[4] <= m_r6[4] ^ (m_r6[3] & m_r6[2]);
        m_i6[5] <= m_r6[5] ^ (m_r6[2] & m_r6[3]);
        m_i6[6] <= m_r6[6] ^ (m_r6[1] & m_r6[4]);
        m_i6[7] <= m_r6[7] ^ (m_r6[0] & m_r6[5]);
        m_i6[8] <= m_r6[8] ^ (m_r6[15] & m_r6[6]);
        m_i6[9] <= m_r6[9] ^ (m_r6[14] & m_r6[7]);
        m_i6[10] <= m_r6[10] ^ (m_r6[13] & m_r6[8]);
        m_i6[11] <= m_r6[11] ^ (m_r6[12] & m_r6[9]);
        m_i6[12] <= m_r6[12] ^ (m_r6[11] & m_r6[10]);
        m_i6[13] <= m_r6[13] ^ (m_r6[10] & m_r6[11]);
        m_i6[14] <= m_r6[14] ^ (m_r6[9] & m_r6[12]);
        m_i6[15] <= m_r6[15] ^ (m_r6[8] & m_r6[13]);
        m_i6[16] <= m_r6[0] ^ (m_r6[7] & m_r6[14]);
        m_i6[17] <= m_r6[1] ^ (m_r6[6] & m_r6[15]);
        m_i6[18] <= m_r6[2] ^ (m_r6[5] & m_r6[0]);
        m_i6[19] <= m_r6[3] ^ (m_r6[4] & m_r6[1]);
        m_i6[20] <= m_r6[4] ^ (m_r6[3] & m_r6[2]);
        m_i6[21] <= m_r6[5] ^ (m_r6[2] & m_r6[3]);
        m_i6[22] <= m_r6[6] ^ (m_r6[1] & m_r6[4]);
        m_i6[23] <= m_r6[7] ^ (m_r6[0] & m_r6[5]);
        m_i6[24] <= m_r6[8] ^ (m_r6[15] & m_r6[6]);
        m_i6[25] <= m_r6[9] ^ (m_r6[14] & m_r6[7]);
        m_i6[26] <= m_r6[10] ^ (m_r6[13] & m_r6[8]);
        m_i6[27] <= m_r6[11] ^ (m_r6[12] & m_r6[9]);
        m_i6[28] <= m_r6[12] ^ (m_r6[11] & m_r6[10]);
        m_i6[29] <= m_r6[13] ^ (m_r6[10] & m_r6[11]);
        m_i6[30] <= m_r6[14] ^ (m_r6[9] & m_r6[12]);
    end
    wire [8:0] e_addr6  = m_i6[8:0];
    wire [7:0] e_wdata6 = m_i6[16:9];
    wire       e_we6    = m_i6[17];
    wire [7:0] e_wt6    = m_i6[25:18];
    wire       e_wse6   = m_i6[26];
    wire [3:0] e_xbar6  = {m_i6[30], 3'b000};
    // slice 7 (bus slice 0): FORCE_ZERO_XBAR=1 STATIC_XBAR_EN=0 STATIC_XBAR_VAL=3'b000 WRITE_LOCK=1
    reg  [15:0] m_r7;
    reg  [30:0] m_i7;
    always @(posedge CLK) begin
        m_r7 <= {NPU_OUT_ACT[7:0], NPU_ACT_RDATA[7:0]};
        m_i7[0] <= m_r7[0] ^ (m_r7[8] & m_r7[0]);
        m_i7[1] <= m_r7[1] ^ (m_r7[9] & m_r7[3]);
        m_i7[2] <= m_r7[2] ^ (m_r7[10] & m_r7[6]);
        m_i7[3] <= m_r7[3] ^ (m_r7[11] & m_r7[9]);
        m_i7[4] <= m_r7[4] ^ (m_r7[12] & m_r7[12]);
        m_i7[5] <= m_r7[5] ^ (m_r7[13] & m_r7[15]);
        m_i7[6] <= m_r7[6] ^ (m_r7[14] & m_r7[2]);
        m_i7[7] <= m_r7[7] ^ (m_r7[15] & m_r7[5]);
        m_i7[8] <= m_r7[8] ^ (m_r7[0] & m_r7[8]);
        m_i7[9] <= m_r7[9] ^ (m_r7[1] & m_r7[11]);
        m_i7[10] <= m_r7[10] ^ (m_r7[2] & m_r7[14]);
        m_i7[11] <= m_r7[11] ^ (m_r7[3] & m_r7[1]);
        m_i7[12] <= m_r7[12] ^ (m_r7[4] & m_r7[4]);
        m_i7[13] <= m_r7[13] ^ (m_r7[5] & m_r7[7]);
        m_i7[14] <= m_r7[14] ^ (m_r7[6] & m_r7[10]);
        m_i7[15] <= m_r7[15] ^ (m_r7[7] & m_r7[13]);
        m_i7[16] <= m_r7[0] ^ (m_r7[8] & m_r7[0]);
        m_i7[17] <= m_r7[1] ^ (m_r7[9] & m_r7[3]);
        m_i7[18] <= m_r7[2] ^ (m_r7[10] & m_r7[6]);
        m_i7[19] <= m_r7[3] ^ (m_r7[11] & m_r7[9]);
        m_i7[20] <= m_r7[4] ^ (m_r7[12] & m_r7[12]);
        m_i7[21] <= m_r7[5] ^ (m_r7[13] & m_r7[15]);
        m_i7[22] <= m_r7[6] ^ (m_r7[14] & m_r7[2]);
        m_i7[23] <= m_r7[7] ^ (m_r7[15] & m_r7[5]);
        m_i7[24] <= m_r7[8] ^ (m_r7[0] & m_r7[8]);
        m_i7[25] <= m_r7[9] ^ (m_r7[1] & m_r7[11]);
        m_i7[26] <= m_r7[10] ^ (m_r7[2] & m_r7[14]);
        m_i7[27] <= m_r7[11] ^ (m_r7[3] & m_r7[1]);
        m_i7[28] <= m_r7[12] ^ (m_r7[4] & m_r7[4]);
        m_i7[29] <= m_r7[13] ^ (m_r7[5] & m_r7[7]);
        m_i7[30] <= m_r7[14] ^ (m_r7[6] & m_r7[10]);
    end
    wire [8:0] e_addr7  = m_i7[8:0];
    wire [7:0] e_wdata7 = m_i7[16:9];
    wire       e_we7    = 1'b0;
    wire [7:0] e_wt7    = m_i7[25:18];
    wire       e_wse7   = m_i7[26];
    wire [3:0] e_xbar7  = {1'b1, m_i7[29:27]};

    // README slice 0 (top) is bus slice 7, so it is the most significant part.
    wire [71:0] exp_addr  = {e_addr0, e_addr1, e_addr2, e_addr3, e_addr4, e_addr5, e_addr6, e_addr7};
    wire [63:0] exp_wdata = {e_wdata0, e_wdata1, e_wdata2, e_wdata3, e_wdata4, e_wdata5, e_wdata6, e_wdata7};
    wire [7:0]  exp_we    = {e_we0, e_we1, e_we2, e_we3, e_we4, e_we5, e_we6, e_we7};
    wire [63:0] exp_wt    = {e_wt0, e_wt1, e_wt2, e_wt3, e_wt4, e_wt5, e_wt6, e_wt7};
    wire [7:0]  exp_wse   = {e_wse0, e_wse1, e_wse2, e_wse3, e_wse4, e_wse5, e_wse6, e_wse7};
    wire [31:0] exp_xbar  = {e_xbar0, e_xbar1, e_xbar2, e_xbar3, e_xbar4, e_xbar5, e_xbar6, e_xbar7};

    localparam integer MAX_BITBYTES = 32768;  // must match MAX_BITBYTES in Test/Taskfile.yml
    reg [7:0] bitstream[MAX_BITBYTES];
    reg [2047:0] bitstream_hex_arg;
    reg [2047:0] output_waveform_arg;
    always #500000 CLK = (CLK === 1'b0);

    integer n, errors = 0;

    initial begin
        if ($value$plusargs("output_waveform=%s", output_waveform_arg)) begin
            $dumpfile(output_waveform_arg);
            $dumpvars(0, npu_slice_loopback_tb);
        end
        if (!$value$plusargs("bitstream_hex=%s", bitstream_hex_arg)) begin
            $display("Error: No bitstream provided as $plusargs bitstream_hex.");
            $fatal;
        end
        $readmemh(bitstream_hex_arg, bitstream);

        #100;
        resetn = 1'b0;
        #10000;
        resetn = 1'b1;
        #10000;
        repeat (20) @(posedge CLK);
        for (n = 0; n < MAX_BITBYTES; n = n + 4) begin
            self_write_data <= {bitstream[n], bitstream[n+1], bitstream[n+2], bitstream[n+3]};
            repeat (2) @(posedge CLK);
            self_write_strobe <= 1'b1;
            @(posedge CLK);
            self_write_strobe <= 1'b0;
            repeat (2) @(posedge CLK);
        end
        repeat (10) @(posedge CLK);

        // Inputs change on the falling edge; outputs are checked just before
        // the next change. Two register stages fill during the first cycles.
        for (n = 0; n < 300; n = n + 1) begin
            @(negedge CLK);
            if (n >= 4) begin
                if (NPU_ACT_ADDR !== exp_addr || NPU_ACT_WDATA !== exp_wdata ||
                    NPU_ACT_WE !== exp_we || NPU_WEIGHT_IN !== exp_wt ||
                    NPU_WEIGHT_SHIFT_EN !== exp_wse || NPU_XBAR_SEL !== exp_xbar) begin
                    errors = errors + 1;
                    if (errors <= 10)
                        $display("MISMATCH cycle %0d: ADDR %h/%h WDATA %h/%h WE %h/%h WT %h/%h WSE %h/%h XBAR %h/%h (got/exp)",
                                 n, NPU_ACT_ADDR, exp_addr, NPU_ACT_WDATA, exp_wdata, NPU_ACT_WE, exp_we,
                                 NPU_WEIGHT_IN, exp_wt, NPU_WEIGHT_SHIFT_EN, exp_wse, NPU_XBAR_SEL, exp_xbar);
                end
            end
            NPU_ACT_RDATA = {$random, $random};
            NPU_OUT_ACT = {$random, $random};
        end

        $display("296 cycles checked, %0d mismatches", errors);
        if (errors != 0) $fatal;
        $display("TEST PASSED");
        $finish;
    end
endmodule
`resetall
