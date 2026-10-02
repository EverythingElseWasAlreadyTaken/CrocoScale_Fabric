`timescale 1ps / 1ps
`default_nettype none

// Loads the axi_m_loopback bitstream, then drives random values on every SoC
// input of AXI_M_BEL and checks every SoC output against the loopback
// functions in user_design/axi_m_loopback.v (generated from one mapping).
// Build: task build-test-design run-simulation DESIGN=axi_m_loopback
//        TOP_WRAPPER=axi_m_loopback_top
module axi_m_loopback_tb;
    reg  [0:0] AWREADY = 0;
    reg  [0:0] WREADY = 0;
    reg  [1:0] BRESP = 0;
    reg  [0:0] BVALID = 0;
    reg  [0:0] ARREADY = 0;
    reg  [31:0] RDATA = 0;
    reg  [1:0] RRESP = 0;
    reg  [0:0] RLAST = 0;
    reg  [0:0] RVALID = 0;
    wire [31:0] AWADDR;
    wire [31:0] WDATA;
    wire [31:0] ARADDR;
    wire [7:0] AWLEN;
    wire [2:0] AWSIZE;
    wire [1:0] AWBURST;
    wire [0:0] AWLOCK;
    wire [3:0] AWCACHE;
    wire [0:0] AWVALID;
    wire [3:0] WSTRB;
    wire [0:0] WLAST;
    wire [0:0] WVALID;
    wire [0:0] BREADY;
    wire [7:0] ARLEN;
    wire [2:0] ARSIZE;
    wire [1:0] ARBURST;
    wire [0:0] ARLOCK;
    wire [3:0] ARCACHE;
    wire [0:0] ARVALID;
    wire [0:0] RREADY;

    reg         CLK = 1'b0;
    reg         resetn = 1'b1;
    reg         self_write_strobe = 1'b0;
    reg  [31:0] self_write_data = 32'b0;

    eFPGA_top top_i (
        .AXI_M_SOC_AWREADY(AWREADY),
        .AXI_M_SOC_WREADY(WREADY),
        .AXI_M_SOC_BRESP(BRESP),
        .AXI_M_SOC_BVALID(BVALID),
        .AXI_M_SOC_ARREADY(ARREADY),
        .AXI_M_SOC_RDATA(RDATA),
        .AXI_M_SOC_RRESP(RRESP),
        .AXI_M_SOC_RLAST(RLAST),
        .AXI_M_SOC_RVALID(RVALID),
        .AXI_M_SOC_AWADDR(AWADDR),
        .AXI_M_SOC_WDATA(WDATA),
        .AXI_M_SOC_ARADDR(ARADDR),
        .AXI_M_SOC_AWLEN(AWLEN),
        .AXI_M_SOC_AWSIZE(AWSIZE),
        .AXI_M_SOC_AWBURST(AWBURST),
        .AXI_M_SOC_AWLOCK(AWLOCK),
        .AXI_M_SOC_AWCACHE(AWCACHE),
        .AXI_M_SOC_AWVALID(AWVALID),
        .AXI_M_SOC_WSTRB(WSTRB),
        .AXI_M_SOC_WLAST(WLAST),
        .AXI_M_SOC_WVALID(WVALID),
        .AXI_M_SOC_BREADY(BREADY),
        .AXI_M_SOC_ARLEN(ARLEN),
        .AXI_M_SOC_ARSIZE(ARSIZE),
        .AXI_M_SOC_ARBURST(ARBURST),
        .AXI_M_SOC_ARLOCK(ARLOCK),
        .AXI_M_SOC_ARCACHE(ARCACHE),
        .AXI_M_SOC_ARVALID(ARVALID),
        .AXI_M_SOC_RREADY(RREADY),
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

    localparam integer MAX_BITBYTES = 16384;
    reg [7:0] bitstream[MAX_BITBYTES];
    reg [2047:0] bitstream_hex_arg;
    reg [2047:0] output_waveform_arg;
    always #500000 CLK = (CLK === 1'b0);

    integer i, errors = 0, checks = 0;
    reg [9:0]  c;
    reg [45:0] exp_ctrl;

    task automatic check(input [8*8-1:0] name, input [31:0] got, input [31:0] gold);
        begin
            checks = checks + 1;
            if (got !== gold) begin
                errors = errors + 1;
                if (errors <= 20) $display("MISMATCH %0s: got 0x%0h expected 0x%0h", name, got, gold);
            end
        end
    endtask

    initial begin
        if ($value$plusargs("output_waveform=%s", output_waveform_arg)) begin
            $dumpfile(output_waveform_arg);
            $dumpvars(0, axi_m_loopback_tb);
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
        for (i = 0; i < MAX_BITBYTES; i = i + 4) begin
            self_write_data <= {bitstream[i], bitstream[i+1], bitstream[i+2], bitstream[i+3]};
            repeat (2) @(posedge CLK);
            self_write_strobe <= 1'b1;
            @(posedge CLK);
            self_write_strobe <= 1'b0;
            repeat (2) @(posedge CLK);
        end
        repeat (10) @(posedge CLK);

        for (i = 0; i < 200; i = i + 1) begin
            {AWREADY, WREADY, BRESP, BVALID, ARREADY, RRESP, RLAST, RVALID} = $random;
            RDATA = $random;
            #1000;
            c = {RVALID, RLAST, RRESP[1], RRESP[0], ARREADY, BVALID, BRESP[1], BRESP[0], WREADY, AWREADY};
            exp_ctrl[0] = c[0] ^ RDATA[0];
            exp_ctrl[1] = c[1] ^ RDATA[1];
            exp_ctrl[2] = c[2] ^ RDATA[2];
            exp_ctrl[3] = c[3] ^ RDATA[3];
            exp_ctrl[4] = c[4] ^ RDATA[4];
            exp_ctrl[5] = c[5] ^ RDATA[5];
            exp_ctrl[6] = c[6] ^ RDATA[6];
            exp_ctrl[7] = c[7] ^ RDATA[7];
            exp_ctrl[8] = c[8] ^ RDATA[8];
            exp_ctrl[9] = c[9] ^ RDATA[9];
            exp_ctrl[10] = c[0] ^ RDATA[10];
            exp_ctrl[11] = c[1] ^ RDATA[11];
            exp_ctrl[12] = c[2] ^ RDATA[12];
            exp_ctrl[13] = c[3] ^ RDATA[13];
            exp_ctrl[14] = c[4] ^ RDATA[14];
            exp_ctrl[15] = c[5] ^ RDATA[15];
            exp_ctrl[16] = c[6] ^ RDATA[16];
            exp_ctrl[17] = c[7] ^ RDATA[17];
            exp_ctrl[18] = c[8] ^ RDATA[18];
            exp_ctrl[19] = c[9] ^ RDATA[19];
            exp_ctrl[20] = c[0] ^ RDATA[20];
            exp_ctrl[21] = c[1] ^ RDATA[21];
            exp_ctrl[22] = c[2] ^ RDATA[22];
            exp_ctrl[23] = c[3] ^ RDATA[23];
            exp_ctrl[24] = c[4] ^ RDATA[24];
            exp_ctrl[25] = c[5] ^ RDATA[25];
            exp_ctrl[26] = c[6] ^ RDATA[26];
            exp_ctrl[27] = c[7] ^ RDATA[27];
            exp_ctrl[28] = c[8] ^ RDATA[28];
            exp_ctrl[29] = c[9] ^ RDATA[29];
            exp_ctrl[30] = c[0] ^ RDATA[30];
            exp_ctrl[31] = c[1] ^ RDATA[31];
            exp_ctrl[32] = c[2] ^ RDATA[0];
            exp_ctrl[33] = c[3] ^ RDATA[1];
            exp_ctrl[34] = c[4] ^ RDATA[2];
            exp_ctrl[35] = c[5] ^ RDATA[3];
            exp_ctrl[36] = c[6] ^ RDATA[4];
            exp_ctrl[37] = c[7] ^ RDATA[5];
            exp_ctrl[38] = c[8] ^ RDATA[6];
            exp_ctrl[39] = c[9] ^ RDATA[7];
            exp_ctrl[40] = c[0] ^ RDATA[8];
            exp_ctrl[41] = c[1] ^ RDATA[9];
            exp_ctrl[42] = c[2] ^ RDATA[10];
            exp_ctrl[43] = c[3] ^ RDATA[11];
            exp_ctrl[44] = c[4] ^ RDATA[12];
            exp_ctrl[45] = c[5] ^ RDATA[13];
            check("WDATA", WDATA, RDATA);
            check("AWADDR", AWADDR, RDATA ^ {RDATA[0], RDATA[31:1]});
            check("ARADDR", ARADDR, ~RDATA);
            check("AWLEN", AWLEN, {exp_ctrl[7], exp_ctrl[6], exp_ctrl[5], exp_ctrl[4], exp_ctrl[3], exp_ctrl[2], exp_ctrl[1], exp_ctrl[0]});
            check("AWSIZE", AWSIZE, {exp_ctrl[10], exp_ctrl[9], exp_ctrl[8]});
            check("AWBURST", AWBURST, {exp_ctrl[12], exp_ctrl[11]});
            check("AWLOCK", AWLOCK, {exp_ctrl[13]});
            check("AWCACHE", AWCACHE, 4'b0011);
            check("AWVALID", AWVALID, {exp_ctrl[18]});
            check("WSTRB", WSTRB, 4'b1111);
            check("WLAST", WLAST, {exp_ctrl[23]});
            check("WVALID", WVALID, {exp_ctrl[24]});
            check("BREADY", BREADY, {exp_ctrl[25]});
            check("ARLEN", ARLEN, {exp_ctrl[33], exp_ctrl[32], exp_ctrl[31], exp_ctrl[30], exp_ctrl[29], exp_ctrl[28], exp_ctrl[27], exp_ctrl[26]});
            check("ARSIZE", ARSIZE, 3'b010);
            check("ARBURST", ARBURST, {exp_ctrl[38], exp_ctrl[37]});
            check("ARLOCK", ARLOCK, {exp_ctrl[39]});
            check("ARCACHE", ARCACHE, {exp_ctrl[43], exp_ctrl[42], exp_ctrl[41], exp_ctrl[40]});
            check("ARVALID", ARVALID, {exp_ctrl[44]});
            check("RREADY", RREADY, {exp_ctrl[45]});
        end

        $display("%0d checks, %0d mismatches", checks, errors);
        if (errors != 0) $fatal;
        $display("TEST PASSED");
        $finish;
    end
endmodule
`resetall
