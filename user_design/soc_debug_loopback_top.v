`default_nettype none

// Functional test wrapper for SOC_DEBUG_IO: one SOC_DEBUG_CTRL_BEL per
// south-row column X1..X4, each with a different configuration, looped
// back through soc_debug_loopback. Test/soc_debug_loopback_tb.v checks it.
module soc_debug_loopback_top;
    wire [31:0] fab_dbg_out, fab_dbg_in;
    wire [3:0]  fab_rst_n, fab_irq;

    soc_debug_loopback logic_i (.fab_dbg_out(fab_dbg_out), .fab_rst_n(fab_rst_n),
                                .fab_dbg_in(fab_dbg_in), .fab_irq(fab_irq));

    (* keep, BEL="X1Y17.A" *) SOC_DEBUG_CTRL_BEL dbg0_i (
        .FAB_DEBUG_OUT0(fab_dbg_out[0]),
        .FAB_DEBUG_OUT1(fab_dbg_out[1]),
        .FAB_DEBUG_OUT2(fab_dbg_out[2]),
        .FAB_DEBUG_OUT3(fab_dbg_out[3]),
        .FAB_DEBUG_OUT4(fab_dbg_out[4]),
        .FAB_DEBUG_OUT5(fab_dbg_out[5]),
        .FAB_DEBUG_OUT6(fab_dbg_out[6]),
        .FAB_DEBUG_OUT7(fab_dbg_out[7]),
        .FAB_DEBUG_IN0(fab_dbg_in[0]),
        .FAB_DEBUG_IN1(fab_dbg_in[1]),
        .FAB_DEBUG_IN2(fab_dbg_in[2]),
        .FAB_DEBUG_IN3(fab_dbg_in[3]),
        .FAB_DEBUG_IN4(fab_dbg_in[4]),
        .FAB_DEBUG_IN5(fab_dbg_in[5]),
        .FAB_DEBUG_IN6(fab_dbg_in[6]),
        .FAB_DEBUG_IN7(fab_dbg_in[7]),
        .FAB_SLOT_SOFT_RST_N(fab_rst_n[0]),
        .FAB_USR_IRQ(fab_irq[0])
    );

    (* keep, BEL="X2Y17.A" *) SOC_DEBUG_CTRL_BEL #(.INV_RESET(1), .INV_IRQ(1)) dbg1_i (
        .FAB_DEBUG_OUT0(fab_dbg_out[8]),
        .FAB_DEBUG_OUT1(fab_dbg_out[9]),
        .FAB_DEBUG_OUT2(fab_dbg_out[10]),
        .FAB_DEBUG_OUT3(fab_dbg_out[11]),
        .FAB_DEBUG_OUT4(fab_dbg_out[12]),
        .FAB_DEBUG_OUT5(fab_dbg_out[13]),
        .FAB_DEBUG_OUT6(fab_dbg_out[14]),
        .FAB_DEBUG_OUT7(fab_dbg_out[15]),
        .FAB_DEBUG_IN0(fab_dbg_in[8]),
        .FAB_DEBUG_IN1(fab_dbg_in[9]),
        .FAB_DEBUG_IN2(fab_dbg_in[10]),
        .FAB_DEBUG_IN3(fab_dbg_in[11]),
        .FAB_DEBUG_IN4(fab_dbg_in[12]),
        .FAB_DEBUG_IN5(fab_dbg_in[13]),
        .FAB_DEBUG_IN6(fab_dbg_in[14]),
        .FAB_DEBUG_IN7(fab_dbg_in[15]),
        .FAB_SLOT_SOFT_RST_N(fab_rst_n[1]),
        .FAB_USR_IRQ(fab_irq[1])
    );

    (* keep, BEL="X3Y17.A" *) SOC_DEBUG_CTRL_BEL #(.BYPASS_RST(1), .BYPASS_IRQ(1)) dbg2_i (
        .FAB_DEBUG_OUT0(fab_dbg_out[16]),
        .FAB_DEBUG_OUT1(fab_dbg_out[17]),
        .FAB_DEBUG_OUT2(fab_dbg_out[18]),
        .FAB_DEBUG_OUT3(fab_dbg_out[19]),
        .FAB_DEBUG_OUT4(fab_dbg_out[20]),
        .FAB_DEBUG_OUT5(fab_dbg_out[21]),
        .FAB_DEBUG_OUT6(fab_dbg_out[22]),
        .FAB_DEBUG_OUT7(fab_dbg_out[23]),
        .FAB_DEBUG_IN0(fab_dbg_in[16]),
        .FAB_DEBUG_IN1(fab_dbg_in[17]),
        .FAB_DEBUG_IN2(fab_dbg_in[18]),
        .FAB_DEBUG_IN3(fab_dbg_in[19]),
        .FAB_DEBUG_IN4(fab_dbg_in[20]),
        .FAB_DEBUG_IN5(fab_dbg_in[21]),
        .FAB_DEBUG_IN6(fab_dbg_in[22]),
        .FAB_DEBUG_IN7(fab_dbg_in[23]),
        .FAB_SLOT_SOFT_RST_N(fab_rst_n[2]),
        .FAB_USR_IRQ(fab_irq[2])
    );

    (* keep, BEL="X4Y17.A" *) SOC_DEBUG_CTRL_BEL #(.INV_RESET(1), .INV_IRQ(1), .BYPASS_RST(1), .BYPASS_IRQ(1)) dbg3_i (
        .FAB_DEBUG_OUT0(fab_dbg_out[24]),
        .FAB_DEBUG_OUT1(fab_dbg_out[25]),
        .FAB_DEBUG_OUT2(fab_dbg_out[26]),
        .FAB_DEBUG_OUT3(fab_dbg_out[27]),
        .FAB_DEBUG_OUT4(fab_dbg_out[28]),
        .FAB_DEBUG_OUT5(fab_dbg_out[29]),
        .FAB_DEBUG_OUT6(fab_dbg_out[30]),
        .FAB_DEBUG_OUT7(fab_dbg_out[31]),
        .FAB_DEBUG_IN0(fab_dbg_in[24]),
        .FAB_DEBUG_IN1(fab_dbg_in[25]),
        .FAB_DEBUG_IN2(fab_dbg_in[26]),
        .FAB_DEBUG_IN3(fab_dbg_in[27]),
        .FAB_DEBUG_IN4(fab_dbg_in[28]),
        .FAB_DEBUG_IN5(fab_dbg_in[29]),
        .FAB_DEBUG_IN6(fab_dbg_in[30]),
        .FAB_DEBUG_IN7(fab_dbg_in[31]),
        .FAB_SLOT_SOFT_RST_N(fab_rst_n[3]),
        .FAB_USR_IRQ(fab_irq[3])
    );
endmodule
`resetall
