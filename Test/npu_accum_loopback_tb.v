`timescale 1ps / 1ps
`default_nettype none

// NPU_ACCUM functional test: loads the bitstream, drives random NPU_RDATA
// for both banks every cycle and checks NPU_ADDR, NPU_WE, NPU_WDATA and
// NPU_READ_BANK_SEL against a model of both NPU_ACCUM_SRAM_BELs (RDATA
// capture register, fabric loopback, launch registers, WRITE_LOCK) using
// the functions in user_design/npu_accum_loopback.v.
// Build: task build-test-design run-simulation DESIGN=npu_accum_loopback
//        TOP_WRAPPER=npu_accum_loopback_top
module npu_accum_loopback_tb;
    reg  [63:0] NPU_RDATA = 0;
    wire [15:0] NPU_ADDR, NPU_WE;
    wire [63:0] NPU_WDATA;
    wire [5:0]  NPU_READ_BANK_SEL;

    reg         CLK = 1'b0;
    reg         resetn = 1'b1;
    reg         self_write_strobe = 1'b0;
    reg  [31:0] self_write_data = 32'b0;

    eFPGA_top top_i (
        .NPU_RDATA        (NPU_RDATA),
        .NPU_ADDR         (NPU_ADDR),
        .NPU_WE           (NPU_WE),
        .NPU_WDATA        (NPU_WDATA),
        .NPU_READ_BANK_SEL(NPU_READ_BANK_SEL),
        .CLK              (CLK),
        .resetn           (resetn),
        .SelfWriteStrobe  (self_write_strobe),
        .SelfWriteData    (self_write_data),
        .Rx               (1'b1),
        .ComActive        (),
        .ReceiveLED       (),
        .s_clk            (1'b0),
        .s_data           (1'b0)
    );

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

    // Concatenate in eFPGA_top slice order: bank B is slice 0, bank A slice 1.
    wire [15:0] exp_addr  = {exp_addr_a, exp_addr_b};
    wire [15:0] exp_we    = {exp_we_a, exp_we_b};
    wire [63:0] exp_wdata = {exp_wdata_a, exp_wdata_b};
    wire [5:0]  exp_rbs   = {exp_rbs_a, exp_rbs_b};

    localparam integer MAX_BITBYTES = 32768;  // must match MAX_BITBYTES in Test/Taskfile.yml
    reg [7:0] bitstream[MAX_BITBYTES];
    reg [2047:0] bitstream_hex_arg;
    reg [2047:0] output_waveform_arg;
    always #500000 CLK = (CLK === 1'b0);

    integer n, errors = 0;

    initial begin
        if ($value$plusargs("output_waveform=%s", output_waveform_arg)) begin
            $dumpfile(output_waveform_arg);
            $dumpvars(0, npu_accum_loopback_tb);
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

        // RDATA changes on the falling edge; outputs are checked just before
        // the next change. Two register stages fill during the first cycles.
        for (n = 0; n < 300; n = n + 1) begin
            @(negedge CLK);
            if (n >= 4) begin
                if (NPU_ADDR !== exp_addr || NPU_WE !== exp_we ||
                    NPU_WDATA !== exp_wdata || NPU_READ_BANK_SEL !== exp_rbs) begin
                    errors = errors + 1;
                    if (errors <= 10)
                        $display("MISMATCH cycle %0d: ADDR %h/%h WE %h/%h WDATA %h/%h RBS %h/%h (got/exp)",
                                 n, NPU_ADDR, exp_addr, NPU_WE, exp_we, NPU_WDATA, exp_wdata,
                                 NPU_READ_BANK_SEL, exp_rbs);
                end
            end
            NPU_RDATA = {$random, $random};
        end

        $display("296 cycles checked, %0d mismatches", errors);
        if (errors != 0) $fatal;
        $display("TEST PASSED");
        $finish;
    end
endmodule
`resetall
