`default_nettype none

// Fabric logic for the EXT_PMOD functional test 'reg' (see
// ext_pmod_reg_top.v). Generated together with
// Test/ext_pmod_reg_tb.v; keep them in sync.
module ext_pmod_reg (
    input  wire [7:0]  fab_i,
    input  wire [15:0] wdata,
    output wire [7:0]  fab_o,
    output wire [7:0]  fab_oe
);
    assign fab_o  = {fab_i[6:0], fab_i[7]} ^ 8'h5A;
    assign fab_oe = {fab_i[4:0], fab_i[7:5]} ^ fab_i;
endmodule
`resetall
