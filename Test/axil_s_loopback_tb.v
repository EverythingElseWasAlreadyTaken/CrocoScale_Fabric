`timescale 1ps / 1ps
`default_nettype none

// Loads the axil_s_loopback bitstream, then drives random values on every SoC
// input of AXIL_S_BEL and checks every SoC output against the loopback
// functions in user_design/axil_s_loopback.v (generated from one mapping).
// Build: task build-test-design run-simulation DESIGN=axil_s_loopback
//        TOP_WRAPPER=axil_s_loopback_top
module axil_s_loopback_tb;
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
    wire [0:0] AWREADY;
    wire [0:0] WREADY;
    wire [1:0] BRESP;
    wire [0:0] BVALID;
    wire [0:0] ARREADY;
    wire [31:0] RDATA;
    wire [1:0] RRESP;
    wire [0:0] RVALID;

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
        .AXIL_S_SOC_AWREADY(AWREADY),
        .AXIL_S_SOC_WREADY(WREADY),
        .AXIL_S_SOC_BRESP(BRESP),
        .AXIL_S_SOC_BVALID(BVALID),
        .AXIL_S_SOC_ARREADY(ARREADY),
        .AXIL_S_SOC_RDATA(RDATA),
        .AXIL_S_SOC_RRESP(RRESP),
        .AXIL_S_SOC_RVALID(RVALID),
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

    localparam integer MAX_BITBYTES = 32768;  // must match MAX_BITBYTES in Test/Taskfile.yml
    reg [7:0] bitstream[MAX_BITBYTES];
    reg [2047:0] bitstream_hex_arg;
    reg [2047:0] output_waveform_arg;
    always #500000 CLK = (CLK === 1'b0);

    integer n, errors = 0;
    wire [66:0] o = {RREADY, ARVALID, ARPROT, ARADDR, BREADY, WVALID, WSTRB, WDATA, AWVALID, AWPROT, AWADDR};
    wire [40:0] got = {RVALID, RRESP, RDATA, ARREADY, BVALID, BRESP, WREADY, AWREADY};
    reg  [40:0] exp;

    initial begin
        if ($value$plusargs("output_waveform=%s", output_waveform_arg)) begin
            $dumpfile(output_waveform_arg);
            $dumpvars(0, axil_s_loopback_tb);
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

        for (n = 0; n < 200; n = n + 1) begin
            {RREADY, ARVALID, ARPROT, ARADDR, BREADY, WVALID, WSTRB, WDATA, AWVALID, AWPROT, AWADDR} = {$random, $random, $random};
            #1000;
            exp[0] = o[0] ^ (o[41] & o[7]);
            exp[1] = o[1] ^ (o[42] & o[8]);
            exp[2] = o[2] ^ (o[43] & o[9]);
            exp[3] = o[3] ^ (o[44] & o[10]);
            exp[4] = o[4] ^ (o[45] & o[11]);
            exp[5] = o[5] ^ (o[46] & o[12]);
            exp[6] = o[6] ^ (o[47] & o[13]);
            exp[7] = o[7] ^ (o[48] & o[14]);
            exp[8] = o[8] ^ (o[49] & o[15]);
            exp[9] = o[9] ^ (o[50] & o[16]);
            exp[10] = o[10] ^ (o[51] & o[17]);
            exp[11] = o[11] ^ (o[52] & o[18]);
            exp[12] = o[12] ^ (o[53] & o[19]);
            exp[13] = o[13] ^ (o[54] & o[20]);
            exp[14] = o[14] ^ (o[55] & o[21]);
            exp[15] = o[15] ^ (o[56] & o[22]);
            exp[16] = o[16] ^ (o[57] & o[23]);
            exp[17] = o[17] ^ (o[58] & o[24]);
            exp[18] = o[18] ^ (o[59] & o[25]);
            exp[19] = o[19] ^ (o[60] & o[26]);
            exp[20] = o[20] ^ (o[61] & o[27]);
            exp[21] = o[21] ^ (o[62] & o[28]);
            exp[22] = o[22] ^ (o[63] & o[29]);
            exp[23] = o[23] ^ (o[64] & o[30]);
            exp[24] = o[24] ^ (o[65] & o[31]);
            exp[25] = o[25] ^ (o[66] & o[32]);
            exp[26] = o[26] ^ (o[41] & o[33]);
            exp[27] = o[27] ^ (o[42] & o[34]);
            exp[28] = o[28] ^ (o[43] & o[35]);
            exp[29] = o[29] ^ (o[44] & o[36]);
            exp[30] = o[30] ^ (o[45] & o[37]);
            exp[31] = o[31] ^ (o[46] & o[38]);
            exp[32] = o[32] ^ (o[47] & o[39]);
            exp[33] = o[33] ^ (o[48] & o[40]);
            exp[34] = o[34] ^ (o[49] & o[0]);
            exp[35] = o[35] ^ (o[50] & o[1]);
            exp[36] = o[36] ^ (o[51] & o[2]);
            exp[37] = o[37] ^ (o[52] & o[3]);
            exp[38] = o[38] ^ (o[53] & o[4]);
            exp[39] = o[39] ^ (o[54] & o[5]);
            exp[40] = o[40] ^ (o[55] & o[6]);
            if (got !== exp) begin
                errors = errors + 1;
                if (errors <= 5) begin
                    $display("MISMATCH vector %0d:", n);
                    if (got[0] !== exp[0]) $display("  AWREADY: got %b expected %b", got[0], exp[0]);
                    if (got[1] !== exp[1]) $display("  WREADY: got %b expected %b", got[1], exp[1]);
                    if (got[2] !== exp[2]) $display("  BRESP[0]: got %b expected %b", got[2], exp[2]);
                    if (got[3] !== exp[3]) $display("  BRESP[1]: got %b expected %b", got[3], exp[3]);
                    if (got[4] !== exp[4]) $display("  BVALID: got %b expected %b", got[4], exp[4]);
                    if (got[5] !== exp[5]) $display("  ARREADY: got %b expected %b", got[5], exp[5]);
                    if (got[6] !== exp[6]) $display("  RDATA[0]: got %b expected %b", got[6], exp[6]);
                    if (got[7] !== exp[7]) $display("  RDATA[1]: got %b expected %b", got[7], exp[7]);
                    if (got[8] !== exp[8]) $display("  RDATA[2]: got %b expected %b", got[8], exp[8]);
                    if (got[9] !== exp[9]) $display("  RDATA[3]: got %b expected %b", got[9], exp[9]);
                    if (got[10] !== exp[10]) $display("  RDATA[4]: got %b expected %b", got[10], exp[10]);
                    if (got[11] !== exp[11]) $display("  RDATA[5]: got %b expected %b", got[11], exp[11]);
                    if (got[12] !== exp[12]) $display("  RDATA[6]: got %b expected %b", got[12], exp[12]);
                    if (got[13] !== exp[13]) $display("  RDATA[7]: got %b expected %b", got[13], exp[13]);
                    if (got[14] !== exp[14]) $display("  RDATA[8]: got %b expected %b", got[14], exp[14]);
                    if (got[15] !== exp[15]) $display("  RDATA[9]: got %b expected %b", got[15], exp[15]);
                    if (got[16] !== exp[16]) $display("  RDATA[10]: got %b expected %b", got[16], exp[16]);
                    if (got[17] !== exp[17]) $display("  RDATA[11]: got %b expected %b", got[17], exp[17]);
                    if (got[18] !== exp[18]) $display("  RDATA[12]: got %b expected %b", got[18], exp[18]);
                    if (got[19] !== exp[19]) $display("  RDATA[13]: got %b expected %b", got[19], exp[19]);
                    if (got[20] !== exp[20]) $display("  RDATA[14]: got %b expected %b", got[20], exp[20]);
                    if (got[21] !== exp[21]) $display("  RDATA[15]: got %b expected %b", got[21], exp[21]);
                    if (got[22] !== exp[22]) $display("  RDATA[16]: got %b expected %b", got[22], exp[22]);
                    if (got[23] !== exp[23]) $display("  RDATA[17]: got %b expected %b", got[23], exp[23]);
                    if (got[24] !== exp[24]) $display("  RDATA[18]: got %b expected %b", got[24], exp[24]);
                    if (got[25] !== exp[25]) $display("  RDATA[19]: got %b expected %b", got[25], exp[25]);
                    if (got[26] !== exp[26]) $display("  RDATA[20]: got %b expected %b", got[26], exp[26]);
                    if (got[27] !== exp[27]) $display("  RDATA[21]: got %b expected %b", got[27], exp[27]);
                    if (got[28] !== exp[28]) $display("  RDATA[22]: got %b expected %b", got[28], exp[28]);
                    if (got[29] !== exp[29]) $display("  RDATA[23]: got %b expected %b", got[29], exp[29]);
                    if (got[30] !== exp[30]) $display("  RDATA[24]: got %b expected %b", got[30], exp[30]);
                    if (got[31] !== exp[31]) $display("  RDATA[25]: got %b expected %b", got[31], exp[31]);
                    if (got[32] !== exp[32]) $display("  RDATA[26]: got %b expected %b", got[32], exp[32]);
                    if (got[33] !== exp[33]) $display("  RDATA[27]: got %b expected %b", got[33], exp[33]);
                    if (got[34] !== exp[34]) $display("  RDATA[28]: got %b expected %b", got[34], exp[34]);
                    if (got[35] !== exp[35]) $display("  RDATA[29]: got %b expected %b", got[35], exp[35]);
                    if (got[36] !== exp[36]) $display("  RDATA[30]: got %b expected %b", got[36], exp[36]);
                    if (got[37] !== exp[37]) $display("  RDATA[31]: got %b expected %b", got[37], exp[37]);
                    if (got[38] !== exp[38]) $display("  RRESP[0]: got %b expected %b", got[38], exp[38]);
                    if (got[39] !== exp[39]) $display("  RRESP[1]: got %b expected %b", got[39], exp[39]);
                    if (got[40] !== exp[40]) $display("  RVALID: got %b expected %b", got[40], exp[40]);
                end
            end
        end

        $display("200 vectors x 41 outputs, %0d failing vectors", errors);
        if (errors != 0) $fatal;
        $display("TEST PASSED");
        $finish;
    end
endmodule
`resetall
