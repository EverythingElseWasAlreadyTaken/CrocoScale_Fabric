`default_nettype none

// EXT_PMOD functional test 'bypass': EXT_PMOD_BEL at its master tile with
// the config bits under test, looped through the fabric logic.
module ext_pmod_bypass_top;
    wire [7:0]  fab_i, fab_o, fab_oe;
    wire [15:0] wdata;

    ext_pmod_bypass logic_i (.fab_i(fab_i), .wdata(wdata), .fab_o(fab_o), .fab_oe(fab_oe));

    (* keep, BEL="X2Y0.A" *) EXT_PMOD_BEL #(.BYPASS_IN_REG(1), .BYPASS_OUT_REG(1), .TIE_OFF_OE(1), .STATIC_OE(8'hA6), .OPEN_DRAIN_EN(1)) pmod_i (
        .FAB_PMOD_I0(fab_i[0]),
        .FAB_PMOD_I1(fab_i[1]),
        .FAB_PMOD_I2(fab_i[2]),
        .FAB_PMOD_I3(fab_i[3]),
        .FAB_PMOD_I4(fab_i[4]),
        .FAB_PMOD_I5(fab_i[5]),
        .FAB_PMOD_I6(fab_i[6]),
        .FAB_PMOD_I7(fab_i[7]),
        .FAB_PMOD_O0(fab_o[0]),
        .FAB_PMOD_O1(fab_o[1]),
        .FAB_PMOD_O2(fab_o[2]),
        .FAB_PMOD_O3(fab_o[3]),
        .FAB_PMOD_O4(fab_o[4]),
        .FAB_PMOD_O5(fab_o[5]),
        .FAB_PMOD_O6(fab_o[6]),
        .FAB_PMOD_O7(fab_o[7]),
        .FAB_PMOD_OE0(fab_oe[0]),
        .FAB_PMOD_OE1(fab_oe[1]),
        .FAB_PMOD_OE2(fab_oe[2]),
        .FAB_PMOD_OE3(fab_oe[3]),
        .FAB_PMOD_OE4(fab_oe[4]),
        .FAB_PMOD_OE5(fab_oe[5]),
        .FAB_PMOD_OE6(fab_oe[6]),
        .FAB_PMOD_OE7(fab_oe[7])
    );
    assign wdata = 16'b0;
endmodule
`resetall
