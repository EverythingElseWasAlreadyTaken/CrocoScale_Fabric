`default_nettype none

// Loopback logic for the SOC_DEBUG_IO functional test (see
// soc_debug_loopback_top.v): per instance k, DEBUG_IN is a rotated and
// XORed copy of DEBUG_OUT and USR_IRQ mixes the soft reset with one
// DEBUG_OUT bit, both distinct per instance. Generated together with
// Test/soc_debug_loopback_tb.v; keep them in sync.
module soc_debug_loopback (
    input  wire [31:0] fab_dbg_out,
    input  wire [3:0]  fab_rst_n,
    output wire [31:0] fab_dbg_in,
    output wire [3:0]  fab_irq
);
    wire [7:0] out0 = fab_dbg_out[7:0];
    assign fab_dbg_in[7:0] = {out0[6:0], out0[7:7]} ^ 8'hA5;
    assign fab_irq[0] = fab_rst_n[0] ^ out0[0];
    wire [7:0] out1 = fab_dbg_out[15:8];
    assign fab_dbg_in[15:8] = {out1[5:0], out1[7:6]} ^ 8'h3C;
    assign fab_irq[1] = fab_rst_n[1] ^ out1[2];
    wire [7:0] out2 = fab_dbg_out[23:16];
    assign fab_dbg_in[23:16] = {out2[4:0], out2[7:5]} ^ 8'h0F;
    assign fab_irq[2] = fab_rst_n[2] ^ out2[4];
    wire [7:0] out3 = fab_dbg_out[31:24];
    assign fab_dbg_in[31:24] = {out3[3:0], out3[7:4]} ^ 8'hF0;
    assign fab_irq[3] = fab_rst_n[3] ^ out3[6];
endmodule
`resetall
