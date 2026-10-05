`default_nettype none

// Loopback logic for the AXI_M_IO_W functional test (see
// axi_m_loopback_top.v). Each AXI_M_BEL input gets a distinct function of
// the BEL outputs so a swapped or misrouted pin changes some result.
// Generated together with Test/axi_m_loopback_tb.v; keep them in sync.
module axi_m_loopback (
    input  wire [31:0] rd,
    input  wire [9:0]  c,
    output wire [31:0] wdata,
    output wire [31:0] awaddr,
    output wire [31:0] araddr,
    output wire [45:0] ctrl
);
    assign wdata  = rd;
    assign awaddr = rd ^ {rd[0], rd[31:1]};
    assign araddr = ~rd;
    assign ctrl[0] = c[0] ^ rd[0];  // AWLEN[0]
    assign ctrl[1] = c[1] ^ rd[1];  // AWLEN[1]
    assign ctrl[2] = c[2] ^ rd[2];  // AWLEN[2]
    assign ctrl[3] = c[3] ^ rd[3];  // AWLEN[3]
    assign ctrl[4] = c[4] ^ rd[4];  // AWLEN[4]
    assign ctrl[5] = c[5] ^ rd[5];  // AWLEN[5]
    assign ctrl[6] = c[6] ^ rd[6];  // AWLEN[6]
    assign ctrl[7] = c[7] ^ rd[7];  // AWLEN[7]
    assign ctrl[8] = c[8] ^ rd[8];  // AWSIZE[0]
    assign ctrl[9] = c[9] ^ rd[9];  // AWSIZE[1]
    assign ctrl[10] = c[0] ^ rd[10];  // AWSIZE[2]
    assign ctrl[11] = c[1] ^ rd[11];  // AWBURST[0]
    assign ctrl[12] = c[2] ^ rd[12];  // AWBURST[1]
    assign ctrl[13] = c[3] ^ rd[13];  // AWLOCK
    assign ctrl[14] = c[4] ^ rd[14];  // AWCACHE[0]
    assign ctrl[15] = c[5] ^ rd[15];  // AWCACHE[1]
    assign ctrl[16] = c[6] ^ rd[16];  // AWCACHE[2]
    assign ctrl[17] = c[7] ^ rd[17];  // AWCACHE[3]
    assign ctrl[18] = c[8] ^ rd[18];  // AWVALID
    assign ctrl[19] = c[9] ^ rd[19];  // WSTRB[0]
    assign ctrl[20] = c[0] ^ rd[20];  // WSTRB[1]
    assign ctrl[21] = c[1] ^ rd[21];  // WSTRB[2]
    assign ctrl[22] = c[2] ^ rd[22];  // WSTRB[3]
    assign ctrl[23] = c[3] ^ rd[23];  // WLAST
    assign ctrl[24] = c[4] ^ rd[24];  // WVALID
    assign ctrl[25] = c[5] ^ rd[25];  // BREADY
    assign ctrl[26] = c[6] ^ rd[26];  // ARLEN[0]
    assign ctrl[27] = c[7] ^ rd[27];  // ARLEN[1]
    assign ctrl[28] = c[8] ^ rd[28];  // ARLEN[2]
    assign ctrl[29] = c[9] ^ rd[29];  // ARLEN[3]
    assign ctrl[30] = c[0] ^ rd[30];  // ARLEN[4]
    assign ctrl[31] = c[1] ^ rd[31];  // ARLEN[5]
    assign ctrl[32] = c[2] ^ rd[0];  // ARLEN[6]
    assign ctrl[33] = c[3] ^ rd[1];  // ARLEN[7]
    assign ctrl[34] = c[4] ^ rd[2];  // ARSIZE[0]
    assign ctrl[35] = c[5] ^ rd[3];  // ARSIZE[1]
    assign ctrl[36] = c[6] ^ rd[4];  // ARSIZE[2]
    assign ctrl[37] = c[7] ^ rd[5];  // ARBURST[0]
    assign ctrl[38] = c[8] ^ rd[6];  // ARBURST[1]
    assign ctrl[39] = c[9] ^ rd[7];  // ARLOCK
    assign ctrl[40] = c[0] ^ rd[8];  // ARCACHE[0]
    assign ctrl[41] = c[1] ^ rd[9];  // ARCACHE[1]
    assign ctrl[42] = c[2] ^ rd[10];  // ARCACHE[2]
    assign ctrl[43] = c[3] ^ rd[11];  // ARCACHE[3]
    assign ctrl[44] = c[4] ^ rd[12];  // ARVALID
    assign ctrl[45] = c[5] ^ rd[13];  // RREADY
endmodule
`resetall
