`default_nettype none

// Fabric logic for the EXT_PMOD functional test 'loop' (see
// ext_pmod_loop_top.v). Generated together with
// Test/ext_pmod_loop_tb.v; keep them in sync.
module ext_pmod_loop (
    input  wire [7:0]  fab_i,
    input  wire [15:0] wdata,
    output wire [7:0]  fab_o,
    output wire [7:0]  fab_oe
);
    assign fab_o  = wdata[7:0];
    assign fab_oe = fab_i ^ wdata[15:8];
endmodule
`resetall
