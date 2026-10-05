`timescale 1ps / 1ps
`default_nettype none

// EXT_PMOD functional test 'reg': loads the bitstream, drives random pad
// inputs every cycle and checks PMOD_IO_O / PMOD_IO_OE_O
// against a cycle-accurate model of EXT_PMOD_BEL with these config bits:
//   none
// Build: task build-test-design run-simulation DESIGN=ext_pmod_reg
//        TOP_WRAPPER=ext_pmod_reg_top
module ext_pmod_reg_tb;
    reg  [7:0]  PAD_I = 0;
    reg  [31:0] W32 = 0;
    wire [15:0] W = W32[15:0];
    wire [7:0]  PAD_O, PAD_OE;

    reg         CLK = 1'b0;
    reg         resetn = 1'b1;
    reg         self_write_strobe = 1'b0;
    reg  [31:0] self_write_data = 32'b0;

    eFPGA_top top_i (
        .PMOD_IO_I      (PAD_I),
        .PMOD_IO_O      (PAD_O),
        .PMOD_IO_OE_O   (PAD_OE),
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

    // ---- model of EXT_PMOD_BEL plus the fabric logic ----
    localparam BYPASS_IN_REG  = 0;
    localparam BYPASS_OUT_REG = 0;
    localparam TIE_OFF_OE     = 0;
    localparam OPEN_DRAIN_EN  = 0;
    localparam LOOPBACK_EN    = 0;
    localparam [7:0] STATIC_OE = 8'h00;
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

    localparam integer MAX_BITBYTES = 32768;  // must match MAX_BITBYTES in Test/Taskfile.yml
    reg [7:0] bitstream[MAX_BITBYTES];
    reg [2047:0] bitstream_hex_arg;
    reg [2047:0] output_waveform_arg;
    always #500000 CLK = (CLK === 1'b0);

    integer n, errors = 0;

    task automatic check(input integer cycle, input comb);
        if (PAD_O !== exp_o || PAD_OE !== exp_oe) begin
            errors = errors + 1;
            if (errors <= 10)
                $display("MISMATCH cycle %0d%0s: PMOD_IO_O %h (exp %h) PMOD_IO_OE_O %h (exp %h)",
                         cycle, comb ? " (comb)" : "", PAD_O, exp_o, PAD_OE, exp_oe);
        end
    endtask

    initial begin
        if ($value$plusargs("output_waveform=%s", output_waveform_arg)) begin
            $dumpfile(output_waveform_arg);
            $dumpvars(0, ext_pmod_reg_tb);
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

        // Inputs change on the falling edge; outputs are checked before the
        // next change and again right after it (bypassed paths are
        // combinational). The first cycles fill the uninitialised registers.
        for (n = 0; n < 300; n = n + 1) begin
            @(negedge CLK);
            if (n >= 3) check(n, 0);
            PAD_I = $random;
            W32 = $random;
            #1000;
            if (n >= 3) check(n, 1);
        end

        $display("297 cycles checked, %0d mismatches", errors);
        if (errors != 0) $fatal;
        $display("TEST PASSED");
        $finish;
    end
endmodule
`resetall
