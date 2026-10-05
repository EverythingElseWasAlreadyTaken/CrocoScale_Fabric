`timescale 1ps / 1ps
`default_nettype none

// Loads the soc_debug_loopback bitstream, then drives random DEBUG_OUT and
// SLOT_SOFT_RST_N values each cycle and checks DEBUG_IN and USR_IRQ against a
// cycle-accurate model of the four SOC_DEBUG_CTRL_BELs (pipeline registers,
// inversion and bypass per instance) plus the loopback in
// user_design/soc_debug_loopback.v (generated from one mapping).
// Build: task build-test-design run-simulation DESIGN=soc_debug_loopback
//        TOP_WRAPPER=soc_debug_loopback_top
module soc_debug_loopback_tb;
    reg  [31:0] DEBUG_OUT = 0;
    reg  [3:0]  SLOT_SOFT_RST_N = 0;
    wire [31:0] DEBUG_IN;
    wire [3:0]  USR_IRQ;

    reg         CLK = 1'b0;
    reg         resetn = 1'b1;
    reg         self_write_strobe = 1'b0;
    reg  [31:0] self_write_data = 32'b0;

    eFPGA_top top_i (
        .DEBUG_OUT      (DEBUG_OUT),
        .SLOT_SOFT_RST_N(SLOT_SOFT_RST_N),
        .DEBUG_IN       (DEBUG_IN),
        .USR_IRQ        (USR_IRQ),
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

    localparam integer MAX_BITBYTES = 32768;  // must match MAX_BITBYTES in Test/Taskfile.yml
    reg [7:0] bitstream[MAX_BITBYTES];
    reg [2047:0] bitstream_hex_arg;
    reg [2047:0] output_waveform_arg;
    always #500000 CLK = (CLK === 1'b0);

    wire [31:0] exp_dbg_in = {exp_dbg_in3, exp_dbg_in2, exp_dbg_in1, exp_dbg_in0};
    wire [3:0]  exp_irq = {exp_irq3, exp_irq2, exp_irq1, exp_irq0};
    integer n, errors = 0;

    initial begin
        if ($value$plusargs("output_waveform=%s", output_waveform_arg)) begin
            $dumpfile(output_waveform_arg);
            $dumpvars(0, soc_debug_loopback_tb);
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
        // the next change, after the rising edge. The first cycles fill the
        // uninitialised pipeline registers and are not checked.
        for (n = 0; n < 300; n = n + 1) begin
            @(negedge CLK);
            if (n >= 3) begin
                if (DEBUG_IN !== exp_dbg_in || USR_IRQ !== exp_irq) begin
                    errors = errors + 1;
                    if (errors <= 10)
                        $display("MISMATCH cycle %0d: DEBUG_IN %h (exp %h) USR_IRQ %b (exp %b)",
                                 n, DEBUG_IN, exp_dbg_in, USR_IRQ, exp_irq);
                end
            end
            DEBUG_OUT = $random;
            SLOT_SOFT_RST_N = $random;
            #1000;
            // Bypassed paths are combinational: check them again right away.
            if (n >= 3 && USR_IRQ !== exp_irq) begin
                errors = errors + 1;
                if (errors <= 10)
                    $display("MISMATCH cycle %0d (comb): USR_IRQ %b (exp %b)", n, USR_IRQ, exp_irq);
            end
        end

        $display("297 cycles checked, %0d mismatches", errors);
        if (errors != 0) $fatal;
        $display("TEST PASSED");
        $finish;
    end
endmodule
`resetall
