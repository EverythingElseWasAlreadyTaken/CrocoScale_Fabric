`timescale 1ps / 1ps
`default_nettype none

// NPU_CTRL_CFG functional test 'skew_off' (TIE_OFF_SKEW_EN=0): loads the
// bitstream, drives random AXIL_S SoC inputs every cycle and checks every NPU
// output one cycle later against the fabric functions in
// user_design/npu_ctrl_skew_off.v (generated from one mapping).
// Build: task build-test-design run-simulation DESIGN=npu_ctrl_skew_off
//        TOP_WRAPPER=npu_ctrl_skew_off_top
module npu_ctrl_skew_off_tb;
    reg  [9:0] AWADDR = 0;
    reg  [2:0] AWPROT = 0;
    reg  [0:0] AWVALID = 0;
    reg  [31:0] WDATA = 0;
    reg  [3:0] WSTRB = 0;
    reg  [0:0] WVALID = 0;
    reg  [0:0] BREADY = 0;
    reg  [9:0] ARADDR = 0;
    reg  [2:0] ARPROT = 0;
    reg  [0:0] ARVALID = 0;
    reg  [0:0] RREADY = 0;
    wire [29:0] NPU_QUANT_SHIFT_IN;
    wire [0:0] NPU_QUANT_SHIFT_EN;
    wire [0:0] NPU_ARRAY_EN;
    wire [0:0] NPU_PSUM_SYSTOLIC_EN;
    wire [0:0] NPU_PSUM_LUT_EN;
    wire [0:0] NPU_SWAP_WEIGHTS;
    wire [0:0] NPU_PSUM_SKEW_EN;
    wire [0:0] NPU_COMPUTE_BANK_SWAP;

    reg         CLK = 1'b0;
    reg         resetn = 1'b1;
    reg         self_write_strobe = 1'b0;
    reg  [31:0] self_write_data = 32'b0;

    eFPGA_top top_i (
        .AXIL_S_SOC_AWADDR(AWADDR),
        .AXIL_S_SOC_AWPROT(AWPROT),
        .AXIL_S_SOC_AWVALID(AWVALID),
        .AXIL_S_SOC_WDATA(WDATA),
        .AXIL_S_SOC_WSTRB(WSTRB),
        .AXIL_S_SOC_WVALID(WVALID),
        .AXIL_S_SOC_BREADY(BREADY),
        .AXIL_S_SOC_ARADDR(ARADDR),
        .AXIL_S_SOC_ARPROT(ARPROT),
        .AXIL_S_SOC_ARVALID(ARVALID),
        .AXIL_S_SOC_RREADY(RREADY),
        .NPU_QUANT_SHIFT_IN(NPU_QUANT_SHIFT_IN),
        .NPU_QUANT_SHIFT_EN(NPU_QUANT_SHIFT_EN),
        .NPU_ARRAY_EN(NPU_ARRAY_EN),
        .NPU_PSUM_SYSTOLIC_EN(NPU_PSUM_SYSTOLIC_EN),
        .NPU_PSUM_LUT_EN(NPU_PSUM_LUT_EN),
        .NPU_SWAP_WEIGHTS(NPU_SWAP_WEIGHTS),
        .NPU_PSUM_SKEW_EN(NPU_PSUM_SKEW_EN),
        .NPU_COMPUTE_BANK_SWAP(NPU_COMPUTE_BANK_SWAP),
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

    // Model: the BEL registers every input once; TIE_OFF_SKEW_EN clamps
    // PSUM_SKEW_EN to 1.
    wire [66:0] o = {RREADY, ARVALID, ARPROT, ARADDR, BREADY, WVALID, WSTRB, WDATA, AWVALID, AWPROT, AWADDR};
    wire [36:0] got = {NPU_COMPUTE_BANK_SWAP, NPU_PSUM_SKEW_EN, NPU_SWAP_WEIGHTS, NPU_PSUM_LUT_EN, NPU_PSUM_SYSTOLIC_EN, NPU_ARRAY_EN, NPU_QUANT_SHIFT_EN, NPU_QUANT_SHIFT_IN};
    reg  [36:0] exp;
    wire [36:0] want = exp;
    always @(posedge CLK) begin
            exp[0] <= o[0] ^ (o[37] & o[5]);
            exp[1] <= o[1] ^ (o[38] & o[6]);
            exp[2] <= o[2] ^ (o[39] & o[7]);
            exp[3] <= o[3] ^ (o[40] & o[8]);
            exp[4] <= o[4] ^ (o[41] & o[9]);
            exp[5] <= o[5] ^ (o[42] & o[10]);
            exp[6] <= o[6] ^ (o[43] & o[11]);
            exp[7] <= o[7] ^ (o[44] & o[12]);
            exp[8] <= o[8] ^ (o[45] & o[13]);
            exp[9] <= o[9] ^ (o[46] & o[14]);
            exp[10] <= o[10] ^ (o[47] & o[15]);
            exp[11] <= o[11] ^ (o[48] & o[16]);
            exp[12] <= o[12] ^ (o[49] & o[17]);
            exp[13] <= o[13] ^ (o[50] & o[18]);
            exp[14] <= o[14] ^ (o[51] & o[19]);
            exp[15] <= o[15] ^ (o[52] & o[20]);
            exp[16] <= o[16] ^ (o[53] & o[21]);
            exp[17] <= o[17] ^ (o[54] & o[22]);
            exp[18] <= o[18] ^ (o[55] & o[23]);
            exp[19] <= o[19] ^ (o[56] & o[24]);
            exp[20] <= o[20] ^ (o[57] & o[25]);
            exp[21] <= o[21] ^ (o[58] & o[26]);
            exp[22] <= o[22] ^ (o[59] & o[27]);
            exp[23] <= o[23] ^ (o[60] & o[28]);
            exp[24] <= o[24] ^ (o[61] & o[29]);
            exp[25] <= o[25] ^ (o[62] & o[30]);
            exp[26] <= o[26] ^ (o[63] & o[31]);
            exp[27] <= o[27] ^ (o[64] & o[32]);
            exp[28] <= o[28] ^ (o[65] & o[33]);
            exp[29] <= o[29] ^ (o[66] & o[34]);
            exp[30] <= o[30] ^ (o[37] & o[35]);
            exp[31] <= o[31] ^ (o[38] & o[36]);
            exp[32] <= o[32] ^ (o[39] & o[0]);
            exp[33] <= o[33] ^ (o[40] & o[1]);
            exp[34] <= o[34] ^ (o[41] & o[2]);
            exp[35] <= o[35] ^ (o[42] & o[3]);
            exp[36] <= o[36] ^ (o[43] & o[4]);
    end

    localparam integer MAX_BITBYTES = 32768;  // must match MAX_BITBYTES in Test/Taskfile.yml
    reg [7:0] bitstream[MAX_BITBYTES];
    reg [2047:0] bitstream_hex_arg;
    reg [2047:0] output_waveform_arg;
    always #500000 CLK = (CLK === 1'b0);

    integer n, errors = 0;

    initial begin
        if ($value$plusargs("output_waveform=%s", output_waveform_arg)) begin
            $dumpfile(output_waveform_arg);
            $dumpvars(0, npu_ctrl_skew_off_tb);
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

        // Stimulus changes on the falling edge; outputs are checked just
        // before the next change. The first cycles fill the registers.
        for (n = 0; n < 300; n = n + 1) begin
            @(negedge CLK);
            if (n >= 3 && got !== want) begin
                errors = errors + 1;
                if (errors <= 5) begin
                    $display("MISMATCH cycle %0d:", n);
                    if (got[0] !== want[0]) $display("  NPU_QUANT_SHIFT_IN[0]: got %b expected %b", got[0], want[0]);
                    if (got[1] !== want[1]) $display("  NPU_QUANT_SHIFT_IN[1]: got %b expected %b", got[1], want[1]);
                    if (got[2] !== want[2]) $display("  NPU_QUANT_SHIFT_IN[2]: got %b expected %b", got[2], want[2]);
                    if (got[3] !== want[3]) $display("  NPU_QUANT_SHIFT_IN[3]: got %b expected %b", got[3], want[3]);
                    if (got[4] !== want[4]) $display("  NPU_QUANT_SHIFT_IN[4]: got %b expected %b", got[4], want[4]);
                    if (got[5] !== want[5]) $display("  NPU_QUANT_SHIFT_IN[5]: got %b expected %b", got[5], want[5]);
                    if (got[6] !== want[6]) $display("  NPU_QUANT_SHIFT_IN[6]: got %b expected %b", got[6], want[6]);
                    if (got[7] !== want[7]) $display("  NPU_QUANT_SHIFT_IN[7]: got %b expected %b", got[7], want[7]);
                    if (got[8] !== want[8]) $display("  NPU_QUANT_SHIFT_IN[8]: got %b expected %b", got[8], want[8]);
                    if (got[9] !== want[9]) $display("  NPU_QUANT_SHIFT_IN[9]: got %b expected %b", got[9], want[9]);
                    if (got[10] !== want[10]) $display("  NPU_QUANT_SHIFT_IN[10]: got %b expected %b", got[10], want[10]);
                    if (got[11] !== want[11]) $display("  NPU_QUANT_SHIFT_IN[11]: got %b expected %b", got[11], want[11]);
                    if (got[12] !== want[12]) $display("  NPU_QUANT_SHIFT_IN[12]: got %b expected %b", got[12], want[12]);
                    if (got[13] !== want[13]) $display("  NPU_QUANT_SHIFT_IN[13]: got %b expected %b", got[13], want[13]);
                    if (got[14] !== want[14]) $display("  NPU_QUANT_SHIFT_IN[14]: got %b expected %b", got[14], want[14]);
                    if (got[15] !== want[15]) $display("  NPU_QUANT_SHIFT_IN[15]: got %b expected %b", got[15], want[15]);
                    if (got[16] !== want[16]) $display("  NPU_QUANT_SHIFT_IN[16]: got %b expected %b", got[16], want[16]);
                    if (got[17] !== want[17]) $display("  NPU_QUANT_SHIFT_IN[17]: got %b expected %b", got[17], want[17]);
                    if (got[18] !== want[18]) $display("  NPU_QUANT_SHIFT_IN[18]: got %b expected %b", got[18], want[18]);
                    if (got[19] !== want[19]) $display("  NPU_QUANT_SHIFT_IN[19]: got %b expected %b", got[19], want[19]);
                    if (got[20] !== want[20]) $display("  NPU_QUANT_SHIFT_IN[20]: got %b expected %b", got[20], want[20]);
                    if (got[21] !== want[21]) $display("  NPU_QUANT_SHIFT_IN[21]: got %b expected %b", got[21], want[21]);
                    if (got[22] !== want[22]) $display("  NPU_QUANT_SHIFT_IN[22]: got %b expected %b", got[22], want[22]);
                    if (got[23] !== want[23]) $display("  NPU_QUANT_SHIFT_IN[23]: got %b expected %b", got[23], want[23]);
                    if (got[24] !== want[24]) $display("  NPU_QUANT_SHIFT_IN[24]: got %b expected %b", got[24], want[24]);
                    if (got[25] !== want[25]) $display("  NPU_QUANT_SHIFT_IN[25]: got %b expected %b", got[25], want[25]);
                    if (got[26] !== want[26]) $display("  NPU_QUANT_SHIFT_IN[26]: got %b expected %b", got[26], want[26]);
                    if (got[27] !== want[27]) $display("  NPU_QUANT_SHIFT_IN[27]: got %b expected %b", got[27], want[27]);
                    if (got[28] !== want[28]) $display("  NPU_QUANT_SHIFT_IN[28]: got %b expected %b", got[28], want[28]);
                    if (got[29] !== want[29]) $display("  NPU_QUANT_SHIFT_IN[29]: got %b expected %b", got[29], want[29]);
                    if (got[30] !== want[30]) $display("  NPU_QUANT_SHIFT_EN: got %b expected %b", got[30], want[30]);
                    if (got[31] !== want[31]) $display("  NPU_ARRAY_EN: got %b expected %b", got[31], want[31]);
                    if (got[32] !== want[32]) $display("  NPU_PSUM_SYSTOLIC_EN: got %b expected %b", got[32], want[32]);
                    if (got[33] !== want[33]) $display("  NPU_PSUM_LUT_EN: got %b expected %b", got[33], want[33]);
                    if (got[34] !== want[34]) $display("  NPU_SWAP_WEIGHTS: got %b expected %b", got[34], want[34]);
                    if (got[35] !== want[35]) $display("  NPU_PSUM_SKEW_EN: got %b expected %b", got[35], want[35]);
                    if (got[36] !== want[36]) $display("  NPU_COMPUTE_BANK_SWAP: got %b expected %b", got[36], want[36]);
                end
            end
            {RREADY, ARVALID, ARPROT, ARADDR, BREADY, WVALID, WSTRB, WDATA, AWVALID, AWPROT, AWADDR} = {$random, $random, $random};
        end

        $display("297 cycles x 37 outputs checked, %0d failing cycles", errors);
        if (errors != 0) $fatal;
        $display("TEST PASSED");
        $finish;
    end
endmodule
`resetall
