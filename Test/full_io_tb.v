`timescale 1ps / 1ps
`default_nettype none

// Combined all-IO functional test: loads the full_io bitstream (every IO BEL
// in use at once), drives random values on every IO input of eFPGA_top each
// cycle and checks every IO output against the per-BEL reference models
// (taken from the single-BEL test generators). Checked before and right
// after each input change, so registered and combinational paths are covered.
// Build: task build-test-design run-simulation DESIGN=full_io
//        TOP_WRAPPER=full_io_top
module full_io_tb;
    // AXI_M
    reg  [0:0] am_AWREADY = 0;
    reg  [0:0] am_WREADY = 0;
    reg  [1:0] am_BRESP = 0;
    reg  [0:0] am_BVALID = 0;
    reg  [0:0] am_ARREADY = 0;
    reg  [31:0] am_RDATA = 0;
    reg  [1:0] am_RRESP = 0;
    reg  [0:0] am_RLAST = 0;
    reg  [0:0] am_RVALID = 0;
    wire [31:0] am_AWADDR;
    wire [31:0] am_WDATA;
    wire [31:0] am_ARADDR;
    wire [7:0] am_AWLEN;
    wire [2:0] am_AWSIZE;
    wire [1:0] am_AWBURST;
    wire [0:0] am_AWLOCK;
    wire [3:0] am_AWCACHE;
    wire [0:0] am_AWVALID;
    wire [3:0] am_WSTRB;
    wire [0:0] am_WLAST;
    wire [0:0] am_WVALID;
    wire [0:0] am_BREADY;
    wire [7:0] am_ARLEN;
    wire [2:0] am_ARSIZE;
    wire [1:0] am_ARBURST;
    wire [0:0] am_ARLOCK;
    wire [3:0] am_ARCACHE;
    wire [0:0] am_ARVALID;
    wire [0:0] am_RREADY;
    // AXIL_S
    reg  [9:0] al_AWADDR = 0;
    reg  [2:0] al_AWPROT = 0;
    reg  [0:0] al_AWVALID = 0;
    reg  [31:0] al_WDATA = 0;
    reg  [3:0] al_WSTRB = 0;
    reg  [0:0] al_WVALID = 0;
    reg  [0:0] al_BREADY = 0;
    reg  [9:0] al_ARADDR = 0;
    reg  [2:0] al_ARPROT = 0;
    reg  [0:0] al_ARVALID = 0;
    reg  [0:0] al_RREADY = 0;
    wire [0:0] al_AWREADY;
    wire [0:0] al_WREADY;
    wire [1:0] al_BRESP;
    wire [0:0] al_BVALID;
    wire [0:0] al_ARREADY;
    wire [31:0] al_RDATA;
    wire [1:0] al_RRESP;
    wire [0:0] al_RVALID;
    // NPU_CTRL_CFG
    wire [29:0] NPU_QUANT_SHIFT_IN;
    wire [0:0] NPU_QUANT_SHIFT_EN;
    wire [0:0] NPU_ARRAY_EN;
    wire [0:0] NPU_PSUM_SYSTOLIC_EN;
    wire [0:0] NPU_PSUM_LUT_EN;
    wire [0:0] NPU_SWAP_WEIGHTS;
    wire [0:0] NPU_PSUM_SKEW_EN;
    wire [0:0] NPU_COMPUTE_BANK_SWAP;
    // SOC_DEBUG
    reg  [31:0] DEBUG_OUT = 0;
    reg  [3:0]  SLOT_SOFT_RST_N = 0;
    wire [31:0] DEBUG_IN;
    wire [3:0]  USR_IRQ;
    // EXT_PMOD
    reg  [7:0]  PAD_I = 0;
    wire [7:0]  PAD_O, PAD_OE;
    // NPU_ACCUM
    reg  [63:0] NPU_RDATA = 0;
    wire [15:0] NPU_ADDR, NPU_WE;
    wire [63:0] NPU_WDATA;
    wire [5:0]  NPU_READ_BANK_SEL;
    // NPU_SLICE
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
        .AXI_M_SOC_AWREADY(am_AWREADY),
        .AXI_M_SOC_WREADY(am_WREADY),
        .AXI_M_SOC_BRESP(am_BRESP),
        .AXI_M_SOC_BVALID(am_BVALID),
        .AXI_M_SOC_ARREADY(am_ARREADY),
        .AXI_M_SOC_RDATA(am_RDATA),
        .AXI_M_SOC_RRESP(am_RRESP),
        .AXI_M_SOC_RLAST(am_RLAST),
        .AXI_M_SOC_RVALID(am_RVALID),
        .AXI_M_SOC_AWADDR(am_AWADDR),
        .AXI_M_SOC_WDATA(am_WDATA),
        .AXI_M_SOC_ARADDR(am_ARADDR),
        .AXI_M_SOC_AWLEN(am_AWLEN),
        .AXI_M_SOC_AWSIZE(am_AWSIZE),
        .AXI_M_SOC_AWBURST(am_AWBURST),
        .AXI_M_SOC_AWLOCK(am_AWLOCK),
        .AXI_M_SOC_AWCACHE(am_AWCACHE),
        .AXI_M_SOC_AWVALID(am_AWVALID),
        .AXI_M_SOC_WSTRB(am_WSTRB),
        .AXI_M_SOC_WLAST(am_WLAST),
        .AXI_M_SOC_WVALID(am_WVALID),
        .AXI_M_SOC_BREADY(am_BREADY),
        .AXI_M_SOC_ARLEN(am_ARLEN),
        .AXI_M_SOC_ARSIZE(am_ARSIZE),
        .AXI_M_SOC_ARBURST(am_ARBURST),
        .AXI_M_SOC_ARLOCK(am_ARLOCK),
        .AXI_M_SOC_ARCACHE(am_ARCACHE),
        .AXI_M_SOC_ARVALID(am_ARVALID),
        .AXI_M_SOC_RREADY(am_RREADY),
        .AXIL_S_SOC_AWADDR(al_AWADDR),
        .AXIL_S_SOC_AWPROT(al_AWPROT),
        .AXIL_S_SOC_AWVALID(al_AWVALID),
        .AXIL_S_SOC_WDATA(al_WDATA),
        .AXIL_S_SOC_WSTRB(al_WSTRB),
        .AXIL_S_SOC_WVALID(al_WVALID),
        .AXIL_S_SOC_BREADY(al_BREADY),
        .AXIL_S_SOC_ARADDR(al_ARADDR),
        .AXIL_S_SOC_ARPROT(al_ARPROT),
        .AXIL_S_SOC_ARVALID(al_ARVALID),
        .AXIL_S_SOC_RREADY(al_RREADY),
        .AXIL_S_SOC_AWREADY(al_AWREADY),
        .AXIL_S_SOC_WREADY(al_WREADY),
        .AXIL_S_SOC_BRESP(al_BRESP),
        .AXIL_S_SOC_BVALID(al_BVALID),
        .AXIL_S_SOC_ARREADY(al_ARREADY),
        .AXIL_S_SOC_RDATA(al_RDATA),
        .AXIL_S_SOC_RRESP(al_RRESP),
        .AXIL_S_SOC_RVALID(al_RVALID),
        .NPU_QUANT_SHIFT_IN(NPU_QUANT_SHIFT_IN),
        .NPU_QUANT_SHIFT_EN(NPU_QUANT_SHIFT_EN),
        .NPU_ARRAY_EN(NPU_ARRAY_EN),
        .NPU_PSUM_SYSTOLIC_EN(NPU_PSUM_SYSTOLIC_EN),
        .NPU_PSUM_LUT_EN(NPU_PSUM_LUT_EN),
        .NPU_SWAP_WEIGHTS(NPU_SWAP_WEIGHTS),
        .NPU_PSUM_SKEW_EN(NPU_PSUM_SKEW_EN),
        .NPU_COMPUTE_BANK_SWAP(NPU_COMPUTE_BANK_SWAP),
        .DEBUG_OUT(DEBUG_OUT),
        .SLOT_SOFT_RST_N(SLOT_SOFT_RST_N),
        .DEBUG_IN(DEBUG_IN),
        .USR_IRQ(USR_IRQ),
        .PMOD_IO_I(PAD_I),
        .PMOD_IO_O(PAD_O),
        .PMOD_IO_OE_O(PAD_OE),
        .NPU_RDATA(NPU_RDATA),
        .NPU_ADDR(NPU_ADDR),
        .NPU_WE(NPU_WE),
        .NPU_WDATA(NPU_WDATA),
        .NPU_READ_BANK_SEL(NPU_READ_BANK_SEL),
        .NPU_ACT_RDATA(NPU_ACT_RDATA),
        .NPU_OUT_ACT(NPU_OUT_ACT),
        .NPU_ACT_ADDR(NPU_ACT_ADDR),
        .NPU_ACT_WDATA(NPU_ACT_WDATA),
        .NPU_ACT_WE(NPU_ACT_WE),
        .NPU_WEIGHT_IN(NPU_WEIGHT_IN),
        .NPU_WEIGHT_SHIFT_EN(NPU_WEIGHT_SHIFT_EN),
        .NPU_XBAR_SEL(NPU_XBAR_SEL),
        .CLK            (CLK),
        .resetn         (resetn),
        .SelfWriteStrobe(self_write_strobe),
        .SelfWriteData  (self_write_data),
        .Rx             (1'b1),
        .ComActive      (),
        .ReceiveLED     (),
        .s_clk          (1'b0),
        .s_data         (1'b0)
    );

    // ---- AXI_M
    wire [31:0] am_rd = am_RDATA;
    wire [9:0]  am_c = {am_RVALID, am_RLAST, am_RRESP[1], am_RRESP[0], am_ARREADY, am_BVALID, am_BRESP[1], am_BRESP[0], am_WREADY, am_AWREADY};
    wire [45:0] am_ctrl;
    assign am_ctrl[0] = am_c[0] ^ am_rd[0];
    assign am_ctrl[1] = am_c[1] ^ am_rd[1];
    assign am_ctrl[2] = am_c[2] ^ am_rd[2];
    assign am_ctrl[3] = am_c[3] ^ am_rd[3];
    assign am_ctrl[4] = am_c[4] ^ am_rd[4];
    assign am_ctrl[5] = am_c[5] ^ am_rd[5];
    assign am_ctrl[6] = am_c[6] ^ am_rd[6];
    assign am_ctrl[7] = am_c[7] ^ am_rd[7];
    assign am_ctrl[8] = am_c[8] ^ am_rd[8];
    assign am_ctrl[9] = am_c[9] ^ am_rd[9];
    assign am_ctrl[10] = am_c[0] ^ am_rd[10];
    assign am_ctrl[11] = am_c[1] ^ am_rd[11];
    assign am_ctrl[12] = am_c[2] ^ am_rd[12];
    assign am_ctrl[13] = am_c[3] ^ am_rd[13];
    assign am_ctrl[14] = am_c[4] ^ am_rd[14];
    assign am_ctrl[15] = am_c[5] ^ am_rd[15];
    assign am_ctrl[16] = am_c[6] ^ am_rd[16];
    assign am_ctrl[17] = am_c[7] ^ am_rd[17];
    assign am_ctrl[18] = am_c[8] ^ am_rd[18];
    assign am_ctrl[19] = am_c[9] ^ am_rd[19];
    assign am_ctrl[20] = am_c[0] ^ am_rd[20];
    assign am_ctrl[21] = am_c[1] ^ am_rd[21];
    assign am_ctrl[22] = am_c[2] ^ am_rd[22];
    assign am_ctrl[23] = am_c[3] ^ am_rd[23];
    assign am_ctrl[24] = am_c[4] ^ am_rd[24];
    assign am_ctrl[25] = am_c[5] ^ am_rd[25];
    assign am_ctrl[26] = am_c[6] ^ am_rd[26];
    assign am_ctrl[27] = am_c[7] ^ am_rd[27];
    assign am_ctrl[28] = am_c[8] ^ am_rd[28];
    assign am_ctrl[29] = am_c[9] ^ am_rd[29];
    assign am_ctrl[30] = am_c[0] ^ am_rd[30];
    assign am_ctrl[31] = am_c[1] ^ am_rd[31];
    assign am_ctrl[32] = am_c[2] ^ am_rd[0];
    assign am_ctrl[33] = am_c[3] ^ am_rd[1];
    assign am_ctrl[34] = am_c[4] ^ am_rd[2];
    assign am_ctrl[35] = am_c[5] ^ am_rd[3];
    assign am_ctrl[36] = am_c[6] ^ am_rd[4];
    assign am_ctrl[37] = am_c[7] ^ am_rd[5];
    assign am_ctrl[38] = am_c[8] ^ am_rd[6];
    assign am_ctrl[39] = am_c[9] ^ am_rd[7];
    assign am_ctrl[40] = am_c[0] ^ am_rd[8];
    assign am_ctrl[41] = am_c[1] ^ am_rd[9];
    assign am_ctrl[42] = am_c[2] ^ am_rd[10];
    assign am_ctrl[43] = am_c[3] ^ am_rd[11];
    assign am_ctrl[44] = am_c[4] ^ am_rd[12];
    assign am_ctrl[45] = am_c[5] ^ am_rd[13];

    // ---- AXIL_S (its outputs o also feed NPU_CTRL_CFG)
    wire [66:0] o = {al_RREADY, al_ARVALID, al_ARPROT, al_ARADDR, al_BREADY, al_WVALID, al_WSTRB, al_WDATA, al_AWVALID, al_AWPROT, al_AWADDR};
    wire [40:0] al_got = {al_RVALID, al_RRESP, al_RDATA, al_ARREADY, al_BVALID, al_BRESP, al_WREADY, al_AWREADY};
    wire [40:0] al_exp;
    assign al_exp[0] = o[0] ^ (o[41] & o[7]);
    assign al_exp[1] = o[1] ^ (o[42] & o[8]);
    assign al_exp[2] = o[2] ^ (o[43] & o[9]);
    assign al_exp[3] = o[3] ^ (o[44] & o[10]);
    assign al_exp[4] = o[4] ^ (o[45] & o[11]);
    assign al_exp[5] = o[5] ^ (o[46] & o[12]);
    assign al_exp[6] = o[6] ^ (o[47] & o[13]);
    assign al_exp[7] = o[7] ^ (o[48] & o[14]);
    assign al_exp[8] = o[8] ^ (o[49] & o[15]);
    assign al_exp[9] = o[9] ^ (o[50] & o[16]);
    assign al_exp[10] = o[10] ^ (o[51] & o[17]);
    assign al_exp[11] = o[11] ^ (o[52] & o[18]);
    assign al_exp[12] = o[12] ^ (o[53] & o[19]);
    assign al_exp[13] = o[13] ^ (o[54] & o[20]);
    assign al_exp[14] = o[14] ^ (o[55] & o[21]);
    assign al_exp[15] = o[15] ^ (o[56] & o[22]);
    assign al_exp[16] = o[16] ^ (o[57] & o[23]);
    assign al_exp[17] = o[17] ^ (o[58] & o[24]);
    assign al_exp[18] = o[18] ^ (o[59] & o[25]);
    assign al_exp[19] = o[19] ^ (o[60] & o[26]);
    assign al_exp[20] = o[20] ^ (o[61] & o[27]);
    assign al_exp[21] = o[21] ^ (o[62] & o[28]);
    assign al_exp[22] = o[22] ^ (o[63] & o[29]);
    assign al_exp[23] = o[23] ^ (o[64] & o[30]);
    assign al_exp[24] = o[24] ^ (o[65] & o[31]);
    assign al_exp[25] = o[25] ^ (o[66] & o[32]);
    assign al_exp[26] = o[26] ^ (o[41] & o[33]);
    assign al_exp[27] = o[27] ^ (o[42] & o[34]);
    assign al_exp[28] = o[28] ^ (o[43] & o[35]);
    assign al_exp[29] = o[29] ^ (o[44] & o[36]);
    assign al_exp[30] = o[30] ^ (o[45] & o[37]);
    assign al_exp[31] = o[31] ^ (o[46] & o[38]);
    assign al_exp[32] = o[32] ^ (o[47] & o[39]);
    assign al_exp[33] = o[33] ^ (o[48] & o[40]);
    assign al_exp[34] = o[34] ^ (o[49] & o[0]);
    assign al_exp[35] = o[35] ^ (o[50] & o[1]);
    assign al_exp[36] = o[36] ^ (o[51] & o[2]);
    assign al_exp[37] = o[37] ^ (o[52] & o[3]);
    assign al_exp[38] = o[38] ^ (o[53] & o[4]);
    assign al_exp[39] = o[39] ^ (o[54] & o[5]);
    assign al_exp[40] = o[40] ^ (o[55] & o[6]);

    // ---- NPU_CTRL_CFG
    // Model: the BEL registers every input once; TIE_OFF_SKEW_EN clamps
    // PSUM_SKEW_EN to 1.
    wire [36:0] nc_got = {NPU_COMPUTE_BANK_SWAP, NPU_PSUM_SKEW_EN, NPU_SWAP_WEIGHTS, NPU_PSUM_LUT_EN, NPU_PSUM_SYSTOLIC_EN, NPU_ARRAY_EN, NPU_QUANT_SHIFT_EN, NPU_QUANT_SHIFT_IN};
    reg  [36:0] nc_exp;
    wire [36:0] nc_want = nc_exp | (37'b1 << 35);
    always @(posedge CLK) begin
            nc_exp[0] <= o[0] ^ (o[37] & o[5]);
            nc_exp[1] <= o[1] ^ (o[38] & o[6]);
            nc_exp[2] <= o[2] ^ (o[39] & o[7]);
            nc_exp[3] <= o[3] ^ (o[40] & o[8]);
            nc_exp[4] <= o[4] ^ (o[41] & o[9]);
            nc_exp[5] <= o[5] ^ (o[42] & o[10]);
            nc_exp[6] <= o[6] ^ (o[43] & o[11]);
            nc_exp[7] <= o[7] ^ (o[44] & o[12]);
            nc_exp[8] <= o[8] ^ (o[45] & o[13]);
            nc_exp[9] <= o[9] ^ (o[46] & o[14]);
            nc_exp[10] <= o[10] ^ (o[47] & o[15]);
            nc_exp[11] <= o[11] ^ (o[48] & o[16]);
            nc_exp[12] <= o[12] ^ (o[49] & o[17]);
            nc_exp[13] <= o[13] ^ (o[50] & o[18]);
            nc_exp[14] <= o[14] ^ (o[51] & o[19]);
            nc_exp[15] <= o[15] ^ (o[52] & o[20]);
            nc_exp[16] <= o[16] ^ (o[53] & o[21]);
            nc_exp[17] <= o[17] ^ (o[54] & o[22]);
            nc_exp[18] <= o[18] ^ (o[55] & o[23]);
            nc_exp[19] <= o[19] ^ (o[56] & o[24]);
            nc_exp[20] <= o[20] ^ (o[57] & o[25]);
            nc_exp[21] <= o[21] ^ (o[58] & o[26]);
            nc_exp[22] <= o[22] ^ (o[59] & o[27]);
            nc_exp[23] <= o[23] ^ (o[60] & o[28]);
            nc_exp[24] <= o[24] ^ (o[61] & o[29]);
            nc_exp[25] <= o[25] ^ (o[62] & o[30]);
            nc_exp[26] <= o[26] ^ (o[63] & o[31]);
            nc_exp[27] <= o[27] ^ (o[64] & o[32]);
            nc_exp[28] <= o[28] ^ (o[65] & o[33]);
            nc_exp[29] <= o[29] ^ (o[66] & o[34]);
            nc_exp[30] <= o[30] ^ (o[37] & o[35]);
            nc_exp[31] <= o[31] ^ (o[38] & o[36]);
            nc_exp[32] <= o[32] ^ (o[39] & o[0]);
            nc_exp[33] <= o[33] ^ (o[40] & o[1]);
            nc_exp[34] <= o[34] ^ (o[41] & o[2]);
            nc_exp[35] <= o[35] ^ (o[42] & o[3]);
            nc_exp[36] <= o[36] ^ (o[43] & o[4]);
    end

    // ---- SOC_DEBUG
    // instance 0: no config bits
    reg  [7:0] m_fab_out0, m_dbg_in0;
    reg        m_rst0, m_irq0;
    wire       raw_rst0 = SLOT_SOFT_RST_N[0];
    wire       fab_rst0 = m_rst0;
    wire       fab_irq0 = fab_rst0 ^ m_fab_out0[0];
    wire       raw_irq0 = fab_irq0;
    wire [7:0] exp_dbg_in0 = m_dbg_in0;
    wire       exp_irq0 = m_irq0;
    always @(posedge CLK) begin
        m_fab_out0 <= DEBUG_OUT[7:0];
        m_dbg_in0  <= {m_fab_out0[6:0], m_fab_out0[7:7]} ^ 8'hA5;
        m_rst0     <= raw_rst0;
        m_irq0     <= raw_irq0;
    end
    // instance 1: INV_RESET, INV_IRQ
    reg  [7:0] m_fab_out1, m_dbg_in1;
    reg        m_rst1, m_irq1;
    wire       raw_rst1 = ~SLOT_SOFT_RST_N[1];
    wire       fab_rst1 = m_rst1;
    wire       fab_irq1 = fab_rst1 ^ m_fab_out1[2];
    wire       raw_irq1 = ~fab_irq1;
    wire [7:0] exp_dbg_in1 = m_dbg_in1;
    wire       exp_irq1 = m_irq1;
    always @(posedge CLK) begin
        m_fab_out1 <= DEBUG_OUT[15:8];
        m_dbg_in1  <= {m_fab_out1[5:0], m_fab_out1[7:6]} ^ 8'h3C;
        m_rst1     <= raw_rst1;
        m_irq1     <= raw_irq1;
    end
    // instance 2: BYPASS_RST, BYPASS_IRQ
    reg  [7:0] m_fab_out2, m_dbg_in2;
    reg        m_rst2, m_irq2;
    wire       raw_rst2 = SLOT_SOFT_RST_N[2];
    wire       fab_rst2 = raw_rst2;
    wire       fab_irq2 = fab_rst2 ^ m_fab_out2[4];
    wire       raw_irq2 = fab_irq2;
    wire [7:0] exp_dbg_in2 = m_dbg_in2;
    wire       exp_irq2 = raw_irq2;
    always @(posedge CLK) begin
        m_fab_out2 <= DEBUG_OUT[23:16];
        m_dbg_in2  <= {m_fab_out2[4:0], m_fab_out2[7:5]} ^ 8'h0F;
        m_rst2     <= raw_rst2;
        m_irq2     <= raw_irq2;
    end
    // instance 3: INV_RESET, INV_IRQ, BYPASS_RST, BYPASS_IRQ
    reg  [7:0] m_fab_out3, m_dbg_in3;
    reg        m_rst3, m_irq3;
    wire       raw_rst3 = ~SLOT_SOFT_RST_N[3];
    wire       fab_rst3 = raw_rst3;
    wire       fab_irq3 = fab_rst3 ^ m_fab_out3[6];
    wire       raw_irq3 = ~fab_irq3;
    wire [7:0] exp_dbg_in3 = m_dbg_in3;
    wire       exp_irq3 = raw_irq3;
    always @(posedge CLK) begin
        m_fab_out3 <= DEBUG_OUT[31:24];
        m_dbg_in3  <= {m_fab_out3[3:0], m_fab_out3[7:4]} ^ 8'hF0;
        m_rst3     <= raw_rst3;
        m_irq3     <= raw_irq3;
    end

    // ---- model of EXT_PMOD_BEL plus the fabric logic ----
    localparam BYPASS_IN_REG  = 1;
    localparam BYPASS_OUT_REG = 1;
    localparam TIE_OFF_OE     = 1;
    localparam OPEN_DRAIN_EN  = 1;
    localparam LOOPBACK_EN    = 0;
    localparam [7:0] STATIC_OE = 8'hA6;
    reg  [7:0] r_o, r_oe, r_fab_i;
    wire [7:0] fab_i;
    wire [7:0] fab_o  = {fab_i[6:0], fab_i[7]} ^ 8'h5A;
    wire [7:0] fab_oe = {fab_i[4:0], fab_i[7:5]} ^ fab_i;
    wire [7:0] eff_oe = TIE_OFF_OE ? STATIC_OE : fab_oe;
    assign fab_i = BYPASS_IN_REG ? (LOOPBACK_EN ? fab_o : PAD_I) : r_fab_i;
    always @(posedge CLK) begin
        r_o     <= fab_o;
        r_oe    <= eff_oe;
        r_fab_i <= LOOPBACK_EN ? fab_o : PAD_I;
    end
    wire [7:0] act_o  = BYPASS_OUT_REG ? fab_o : r_o;
    wire [7:0] act_oe = BYPASS_OUT_REG ? eff_oe : r_oe;
    wire [7:0] exp_o  = OPEN_DRAIN_EN ? 8'b0 : act_o;
    wire [7:0] exp_oe = OPEN_DRAIN_EN ? (act_oe & ~act_o) : act_oe;

    // ---- NPU_ACCUM
    // bank A (slice 1, WRITE_LOCK=8'h00)
    reg  [31:0] m_ra;
    reg  [50:0] m_ia;
    always @(posedge CLK) begin
        m_ra <= NPU_RDATA[63:32];
        m_ia[0] <= m_ra[0] ^ (m_ra[1] & m_ra[2]);
        m_ia[1] <= m_ra[1] ^ (m_ra[4] & m_ra[7]);
        m_ia[2] <= m_ra[2] ^ (m_ra[7] & m_ra[12]);
        m_ia[3] <= m_ra[3] ^ (m_ra[10] & m_ra[17]);
        m_ia[4] <= m_ra[4] ^ (m_ra[13] & m_ra[22]);
        m_ia[5] <= m_ra[5] ^ (m_ra[16] & m_ra[27]);
        m_ia[6] <= m_ra[6] ^ (m_ra[19] & m_ra[0]);
        m_ia[7] <= m_ra[7] ^ (m_ra[22] & m_ra[5]);
        m_ia[8] <= m_ra[8] ^ (m_ra[25] & m_ra[10]);
        m_ia[9] <= m_ra[9] ^ (m_ra[28] & m_ra[15]);
        m_ia[10] <= m_ra[10] ^ (m_ra[31] & m_ra[20]);
        m_ia[11] <= m_ra[11] ^ (m_ra[2] & m_ra[25]);
        m_ia[12] <= m_ra[12] ^ (m_ra[5] & m_ra[30]);
        m_ia[13] <= m_ra[13] ^ (m_ra[8] & m_ra[3]);
        m_ia[14] <= m_ra[14] ^ (m_ra[11] & m_ra[8]);
        m_ia[15] <= m_ra[15] ^ (m_ra[14] & m_ra[13]);
        m_ia[16] <= m_ra[16] ^ (m_ra[17] & m_ra[18]);
        m_ia[17] <= m_ra[17] ^ (m_ra[20] & m_ra[23]);
        m_ia[18] <= m_ra[18] ^ (m_ra[23] & m_ra[28]);
        m_ia[19] <= m_ra[19] ^ (m_ra[26] & m_ra[1]);
        m_ia[20] <= m_ra[20] ^ (m_ra[29] & m_ra[6]);
        m_ia[21] <= m_ra[21] ^ (m_ra[0] & m_ra[11]);
        m_ia[22] <= m_ra[22] ^ (m_ra[3] & m_ra[16]);
        m_ia[23] <= m_ra[23] ^ (m_ra[6] & m_ra[21]);
        m_ia[24] <= m_ra[24] ^ (m_ra[9] & m_ra[26]);
        m_ia[25] <= m_ra[25] ^ (m_ra[12] & m_ra[31]);
        m_ia[26] <= m_ra[26] ^ (m_ra[15] & m_ra[4]);
        m_ia[27] <= m_ra[27] ^ (m_ra[18] & m_ra[9]);
        m_ia[28] <= m_ra[28] ^ (m_ra[21] & m_ra[14]);
        m_ia[29] <= m_ra[29] ^ (m_ra[24] & m_ra[19]);
        m_ia[30] <= m_ra[30] ^ (m_ra[27] & m_ra[24]);
        m_ia[31] <= m_ra[31] ^ (m_ra[30] & m_ra[29]);
        m_ia[32] <= m_ra[0] ^ (m_ra[1] & m_ra[2]);
        m_ia[33] <= m_ra[1] ^ (m_ra[4] & m_ra[7]);
        m_ia[34] <= m_ra[2] ^ (m_ra[7] & m_ra[12]);
        m_ia[35] <= m_ra[3] ^ (m_ra[10] & m_ra[17]);
        m_ia[36] <= m_ra[4] ^ (m_ra[13] & m_ra[22]);
        m_ia[37] <= m_ra[5] ^ (m_ra[16] & m_ra[27]);
        m_ia[38] <= m_ra[6] ^ (m_ra[19] & m_ra[0]);
        m_ia[39] <= m_ra[7] ^ (m_ra[22] & m_ra[5]);
        m_ia[40] <= m_ra[8] ^ (m_ra[25] & m_ra[10]);
        m_ia[41] <= m_ra[9] ^ (m_ra[28] & m_ra[15]);
        m_ia[42] <= m_ra[10] ^ (m_ra[31] & m_ra[20]);
        m_ia[43] <= m_ra[11] ^ (m_ra[2] & m_ra[25]);
        m_ia[44] <= m_ra[12] ^ (m_ra[5] & m_ra[30]);
        m_ia[45] <= m_ra[13] ^ (m_ra[8] & m_ra[3]);
        m_ia[46] <= m_ra[14] ^ (m_ra[11] & m_ra[8]);
        m_ia[47] <= m_ra[15] ^ (m_ra[14] & m_ra[13]);
        m_ia[48] <= m_ra[16] ^ (m_ra[17] & m_ra[18]);
        m_ia[49] <= m_ra[17] ^ (m_ra[20] & m_ra[23]);
        m_ia[50] <= m_ra[18] ^ (m_ra[23] & m_ra[28]);
    end
    wire [7:0]  exp_addr_a  = m_ia[7:0];
    wire [7:0]  exp_we_a    = m_ia[15:8] & ~8'h00;
    wire [31:0] exp_wdata_a = m_ia[47:16];
    wire [2:0]  exp_rbs_a   = m_ia[50:48];
    // bank B (slice 0, WRITE_LOCK=8'h5A)
    reg  [31:0] m_rb;
    reg  [50:0] m_ib;
    always @(posedge CLK) begin
        m_rb <= NPU_RDATA[31:0];
        m_ib[0] <= m_rb[0] ^ (m_rb[3] & m_rb[5]);
        m_ib[1] <= m_rb[1] ^ (m_rb[10] & m_rb[16]);
        m_ib[2] <= m_rb[2] ^ (m_rb[17] & m_rb[27]);
        m_ib[3] <= m_rb[3] ^ (m_rb[24] & m_rb[6]);
        m_ib[4] <= m_rb[4] ^ (m_rb[31] & m_rb[17]);
        m_ib[5] <= m_rb[5] ^ (m_rb[6] & m_rb[28]);
        m_ib[6] <= m_rb[6] ^ (m_rb[13] & m_rb[7]);
        m_ib[7] <= m_rb[7] ^ (m_rb[20] & m_rb[18]);
        m_ib[8] <= m_rb[8] ^ (m_rb[27] & m_rb[29]);
        m_ib[9] <= m_rb[9] ^ (m_rb[2] & m_rb[8]);
        m_ib[10] <= m_rb[10] ^ (m_rb[9] & m_rb[19]);
        m_ib[11] <= m_rb[11] ^ (m_rb[16] & m_rb[30]);
        m_ib[12] <= m_rb[12] ^ (m_rb[23] & m_rb[9]);
        m_ib[13] <= m_rb[13] ^ (m_rb[30] & m_rb[20]);
        m_ib[14] <= m_rb[14] ^ (m_rb[5] & m_rb[31]);
        m_ib[15] <= m_rb[15] ^ (m_rb[12] & m_rb[10]);
        m_ib[16] <= m_rb[16] ^ (m_rb[19] & m_rb[21]);
        m_ib[17] <= m_rb[17] ^ (m_rb[26] & m_rb[0]);
        m_ib[18] <= m_rb[18] ^ (m_rb[1] & m_rb[11]);
        m_ib[19] <= m_rb[19] ^ (m_rb[8] & m_rb[22]);
        m_ib[20] <= m_rb[20] ^ (m_rb[15] & m_rb[1]);
        m_ib[21] <= m_rb[21] ^ (m_rb[22] & m_rb[12]);
        m_ib[22] <= m_rb[22] ^ (m_rb[29] & m_rb[23]);
        m_ib[23] <= m_rb[23] ^ (m_rb[4] & m_rb[2]);
        m_ib[24] <= m_rb[24] ^ (m_rb[11] & m_rb[13]);
        m_ib[25] <= m_rb[25] ^ (m_rb[18] & m_rb[24]);
        m_ib[26] <= m_rb[26] ^ (m_rb[25] & m_rb[3]);
        m_ib[27] <= m_rb[27] ^ (m_rb[0] & m_rb[14]);
        m_ib[28] <= m_rb[28] ^ (m_rb[7] & m_rb[25]);
        m_ib[29] <= m_rb[29] ^ (m_rb[14] & m_rb[4]);
        m_ib[30] <= m_rb[30] ^ (m_rb[21] & m_rb[15]);
        m_ib[31] <= m_rb[31] ^ (m_rb[28] & m_rb[26]);
        m_ib[32] <= m_rb[0] ^ (m_rb[3] & m_rb[5]);
        m_ib[33] <= m_rb[1] ^ (m_rb[10] & m_rb[16]);
        m_ib[34] <= m_rb[2] ^ (m_rb[17] & m_rb[27]);
        m_ib[35] <= m_rb[3] ^ (m_rb[24] & m_rb[6]);
        m_ib[36] <= m_rb[4] ^ (m_rb[31] & m_rb[17]);
        m_ib[37] <= m_rb[5] ^ (m_rb[6] & m_rb[28]);
        m_ib[38] <= m_rb[6] ^ (m_rb[13] & m_rb[7]);
        m_ib[39] <= m_rb[7] ^ (m_rb[20] & m_rb[18]);
        m_ib[40] <= m_rb[8] ^ (m_rb[27] & m_rb[29]);
        m_ib[41] <= m_rb[9] ^ (m_rb[2] & m_rb[8]);
        m_ib[42] <= m_rb[10] ^ (m_rb[9] & m_rb[19]);
        m_ib[43] <= m_rb[11] ^ (m_rb[16] & m_rb[30]);
        m_ib[44] <= m_rb[12] ^ (m_rb[23] & m_rb[9]);
        m_ib[45] <= m_rb[13] ^ (m_rb[30] & m_rb[20]);
        m_ib[46] <= m_rb[14] ^ (m_rb[5] & m_rb[31]);
        m_ib[47] <= m_rb[15] ^ (m_rb[12] & m_rb[10]);
        m_ib[48] <= m_rb[16] ^ (m_rb[19] & m_rb[21]);
        m_ib[49] <= m_rb[17] ^ (m_rb[26] & m_rb[0]);
        m_ib[50] <= m_rb[18] ^ (m_rb[1] & m_rb[11]);
    end
    wire [7:0]  exp_addr_b  = m_ib[7:0];
    wire [7:0]  exp_we_b    = m_ib[15:8] & ~8'h5A;
    wire [31:0] exp_wdata_b = m_ib[47:16];
    wire [2:0]  exp_rbs_b   = m_ib[50:48];

    // ---- NPU_SLICE
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

    localparam integer MAX_BITBYTES = 32768;  // must match MAX_BITBYTES in Test/Taskfile.yml
    reg [7:0] bitstream[MAX_BITBYTES];
    reg [2047:0] bitstream_hex_arg;
    reg [2047:0] output_waveform_arg;
    always #500000 CLK = (CLK === 1'b0);

    integer n, errors = 0, failing = 0;
    reg cycle_bad;

    task automatic check(input [8*32-1:0] label, input [127:0] got, input [127:0] exp);
        if (got !== exp) begin
            cycle_bad = 1'b1;
            if (errors < 30)
                $display("MISMATCH cycle %0d: %0s got %h expected %h (diff %h)", n, label, got, exp, got ^ exp);
            errors = errors + 1;
        end
    endtask

    initial begin
        if ($value$plusargs("output_waveform=%s", output_waveform_arg)) begin
            $dumpfile(output_waveform_arg);
            $dumpvars(0, full_io_tb);
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

        // Inputs change on the falling edge; all outputs are checked just
        // before the change and again right after it. The first cycles fill
        // the uninitialised pipeline registers and are not checked.
        for (n = 0; n < 300; n = n + 1) begin
            @(negedge CLK);
            cycle_bad = 1'b0;
            if (n >= 4) begin
            check("AXI_M WDATA", {am_WDATA}, {am_rd});
            check("AXI_M AWADDR", {am_AWADDR}, {am_rd ^ {am_rd[0], am_rd[31:1]}});
            check("AXI_M ARADDR", {am_ARADDR}, {~am_rd});
            check("AXI_M AWLEN", {am_AWLEN}, {{am_ctrl[7], am_ctrl[6], am_ctrl[5], am_ctrl[4], am_ctrl[3], am_ctrl[2], am_ctrl[1], am_ctrl[0]}});
            check("AXI_M AWSIZE", {am_AWSIZE}, {{am_ctrl[10], am_ctrl[9], am_ctrl[8]}});
            check("AXI_M AWBURST", {am_AWBURST}, {{am_ctrl[12], am_ctrl[11]}});
            check("AXI_M AWLOCK", {am_AWLOCK}, {{am_ctrl[13]}});
            check("AXI_M AWCACHE", {am_AWCACHE}, {4'b0011});
            check("AXI_M AWVALID", {am_AWVALID}, {{am_ctrl[18]}});
            check("AXI_M WSTRB", {am_WSTRB}, {4'b1111});
            check("AXI_M WLAST", {am_WLAST}, {{am_ctrl[23]}});
            check("AXI_M WVALID", {am_WVALID}, {{am_ctrl[24]}});
            check("AXI_M BREADY", {am_BREADY}, {{am_ctrl[25]}});
            check("AXI_M ARLEN", {am_ARLEN}, {{am_ctrl[33], am_ctrl[32], am_ctrl[31], am_ctrl[30], am_ctrl[29], am_ctrl[28], am_ctrl[27], am_ctrl[26]}});
            check("AXI_M ARSIZE", {am_ARSIZE}, {3'b010});
            check("AXI_M ARBURST", {am_ARBURST}, {{am_ctrl[38], am_ctrl[37]}});
            check("AXI_M ARLOCK", {am_ARLOCK}, {{am_ctrl[39]}});
            check("AXI_M ARCACHE", {am_ARCACHE}, {{am_ctrl[43], am_ctrl[42], am_ctrl[41], am_ctrl[40]}});
            check("AXI_M ARVALID", {am_ARVALID}, {{am_ctrl[44]}});
            check("AXI_M RREADY", {am_RREADY}, {{am_ctrl[45]}});
            check("AXIL_S", {al_got}, {al_exp});
            check("NPU_CTRL_CFG", {nc_got}, {nc_want});
            check("SOC_DEBUG DEBUG_IN", {DEBUG_IN}, {{exp_dbg_in3, exp_dbg_in2, exp_dbg_in1, exp_dbg_in0}});
            check("SOC_DEBUG USR_IRQ", {USR_IRQ}, {{exp_irq3, exp_irq2, exp_irq1, exp_irq0}});
            check("EXT_PMOD O", {PAD_O}, {exp_o});
            check("EXT_PMOD OE", {PAD_OE}, {exp_oe});
            check("NPU_ACCUM ADDR", {NPU_ADDR}, {{exp_addr_a, exp_addr_b}});
            check("NPU_ACCUM WE", {NPU_WE}, {{exp_we_a, exp_we_b}});
            check("NPU_ACCUM WDATA", {NPU_WDATA}, {{exp_wdata_a, exp_wdata_b}});
            check("NPU_ACCUM RBS", {NPU_READ_BANK_SEL}, {{exp_rbs_a, exp_rbs_b}});
            check("NPU_SLICE ADDR", {NPU_ACT_ADDR}, {{e_addr0, e_addr1, e_addr2, e_addr3, e_addr4, e_addr5, e_addr6, e_addr7}});
            check("NPU_SLICE WDATA", {NPU_ACT_WDATA}, {{e_wdata0, e_wdata1, e_wdata2, e_wdata3, e_wdata4, e_wdata5, e_wdata6, e_wdata7}});
            check("NPU_SLICE WE", {NPU_ACT_WE}, {{e_we0, e_we1, e_we2, e_we3, e_we4, e_we5, e_we6, e_we7}});
            check("NPU_SLICE WEIGHT_IN", {NPU_WEIGHT_IN}, {{e_wt0, e_wt1, e_wt2, e_wt3, e_wt4, e_wt5, e_wt6, e_wt7}});
            check("NPU_SLICE WEIGHT_SHIFT_EN", {NPU_WEIGHT_SHIFT_EN}, {{e_wse0, e_wse1, e_wse2, e_wse3, e_wse4, e_wse5, e_wse6, e_wse7}});
            check("NPU_SLICE XBAR_SEL", {NPU_XBAR_SEL}, {{e_xbar0, e_xbar1, e_xbar2, e_xbar3, e_xbar4, e_xbar5, e_xbar6, e_xbar7}});
            end
            am_AWREADY = {$random, $random, $random};
            am_WREADY = {$random, $random, $random};
            am_BRESP = {$random, $random, $random};
            am_BVALID = {$random, $random, $random};
            am_ARREADY = {$random, $random, $random};
            am_RDATA = {$random, $random, $random};
            am_RRESP = {$random, $random, $random};
            am_RLAST = {$random, $random, $random};
            am_RVALID = {$random, $random, $random};
            al_AWADDR = {$random, $random, $random};
            al_AWPROT = {$random, $random, $random};
            al_AWVALID = {$random, $random, $random};
            al_WDATA = {$random, $random, $random};
            al_WSTRB = {$random, $random, $random};
            al_WVALID = {$random, $random, $random};
            al_BREADY = {$random, $random, $random};
            al_ARADDR = {$random, $random, $random};
            al_ARPROT = {$random, $random, $random};
            al_ARVALID = {$random, $random, $random};
            al_RREADY = {$random, $random, $random};
            DEBUG_OUT = {$random, $random, $random};
            SLOT_SOFT_RST_N = {$random, $random, $random};
            PAD_I = {$random, $random, $random};
            NPU_RDATA = {$random, $random, $random};
            NPU_ACT_RDATA = {$random, $random, $random};
            NPU_OUT_ACT = {$random, $random, $random};
            #1000;
            if (n >= 4) begin
            check("AXI_M WDATA", {am_WDATA}, {am_rd});
            check("AXI_M AWADDR", {am_AWADDR}, {am_rd ^ {am_rd[0], am_rd[31:1]}});
            check("AXI_M ARADDR", {am_ARADDR}, {~am_rd});
            check("AXI_M AWLEN", {am_AWLEN}, {{am_ctrl[7], am_ctrl[6], am_ctrl[5], am_ctrl[4], am_ctrl[3], am_ctrl[2], am_ctrl[1], am_ctrl[0]}});
            check("AXI_M AWSIZE", {am_AWSIZE}, {{am_ctrl[10], am_ctrl[9], am_ctrl[8]}});
            check("AXI_M AWBURST", {am_AWBURST}, {{am_ctrl[12], am_ctrl[11]}});
            check("AXI_M AWLOCK", {am_AWLOCK}, {{am_ctrl[13]}});
            check("AXI_M AWCACHE", {am_AWCACHE}, {4'b0011});
            check("AXI_M AWVALID", {am_AWVALID}, {{am_ctrl[18]}});
            check("AXI_M WSTRB", {am_WSTRB}, {4'b1111});
            check("AXI_M WLAST", {am_WLAST}, {{am_ctrl[23]}});
            check("AXI_M WVALID", {am_WVALID}, {{am_ctrl[24]}});
            check("AXI_M BREADY", {am_BREADY}, {{am_ctrl[25]}});
            check("AXI_M ARLEN", {am_ARLEN}, {{am_ctrl[33], am_ctrl[32], am_ctrl[31], am_ctrl[30], am_ctrl[29], am_ctrl[28], am_ctrl[27], am_ctrl[26]}});
            check("AXI_M ARSIZE", {am_ARSIZE}, {3'b010});
            check("AXI_M ARBURST", {am_ARBURST}, {{am_ctrl[38], am_ctrl[37]}});
            check("AXI_M ARLOCK", {am_ARLOCK}, {{am_ctrl[39]}});
            check("AXI_M ARCACHE", {am_ARCACHE}, {{am_ctrl[43], am_ctrl[42], am_ctrl[41], am_ctrl[40]}});
            check("AXI_M ARVALID", {am_ARVALID}, {{am_ctrl[44]}});
            check("AXI_M RREADY", {am_RREADY}, {{am_ctrl[45]}});
            check("AXIL_S", {al_got}, {al_exp});
            check("NPU_CTRL_CFG", {nc_got}, {nc_want});
            check("SOC_DEBUG DEBUG_IN", {DEBUG_IN}, {{exp_dbg_in3, exp_dbg_in2, exp_dbg_in1, exp_dbg_in0}});
            check("SOC_DEBUG USR_IRQ", {USR_IRQ}, {{exp_irq3, exp_irq2, exp_irq1, exp_irq0}});
            check("EXT_PMOD O", {PAD_O}, {exp_o});
            check("EXT_PMOD OE", {PAD_OE}, {exp_oe});
            check("NPU_ACCUM ADDR", {NPU_ADDR}, {{exp_addr_a, exp_addr_b}});
            check("NPU_ACCUM WE", {NPU_WE}, {{exp_we_a, exp_we_b}});
            check("NPU_ACCUM WDATA", {NPU_WDATA}, {{exp_wdata_a, exp_wdata_b}});
            check("NPU_ACCUM RBS", {NPU_READ_BANK_SEL}, {{exp_rbs_a, exp_rbs_b}});
            check("NPU_SLICE ADDR", {NPU_ACT_ADDR}, {{e_addr0, e_addr1, e_addr2, e_addr3, e_addr4, e_addr5, e_addr6, e_addr7}});
            check("NPU_SLICE WDATA", {NPU_ACT_WDATA}, {{e_wdata0, e_wdata1, e_wdata2, e_wdata3, e_wdata4, e_wdata5, e_wdata6, e_wdata7}});
            check("NPU_SLICE WE", {NPU_ACT_WE}, {{e_we0, e_we1, e_we2, e_we3, e_we4, e_we5, e_we6, e_we7}});
            check("NPU_SLICE WEIGHT_IN", {NPU_WEIGHT_IN}, {{e_wt0, e_wt1, e_wt2, e_wt3, e_wt4, e_wt5, e_wt6, e_wt7}});
            check("NPU_SLICE WEIGHT_SHIFT_EN", {NPU_WEIGHT_SHIFT_EN}, {{e_wse0, e_wse1, e_wse2, e_wse3, e_wse4, e_wse5, e_wse6, e_wse7}});
            check("NPU_SLICE XBAR_SEL", {NPU_XBAR_SEL}, {{e_xbar0, e_xbar1, e_xbar2, e_xbar3, e_xbar4, e_xbar5, e_xbar6, e_xbar7}});
            end
            if (cycle_bad) failing = failing + 1;
        end

        $display("296 cycles x 36 output groups checked twice, %0d failing cycles, %0d mismatches",
                 failing, errors);
        if (errors != 0) $fatal;
        $display("TEST PASSED");
        $finish;
    end
endmodule
`resetall
