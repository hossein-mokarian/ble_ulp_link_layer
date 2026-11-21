
module ble_baseband (
    input logic clk_core,
    input logic rst_n_core,

    input logic wake_req,   // from AON

    output logic crc_done,
    output logic crc_value,
    output logic tx_bit_whitened
);

    logic crc_init, whit_init;
    logic [6:0] whit_seed = 7'd32;
    logic tx_data_valid;


    ble_ll_fsm u_fsm (
        .clk        (clk_core),
        .rst_n      (rst_n_core),
        .pkt_start  (wake_req),        // from AON
        .pkt_done   (crc_done),
        .tx_active  (tx_data_valid),
        .rx_active  ()
    );

    crc24 u_crc (
        .clk        (clk_core),
        .rst_n      (rst_n_core),
        .init       (crc_init),
        .data_in    (tx_bit),
        .data_valid (tx_data_valid),
        .crc_out    (crc_value)
    );

    whitening u_whit (
        .clk          (clk_core),
        .rst_n        (rst_n_core),
        .init         (whit_init),
        .channel_seed (whit_seed),
        .data_in      (tx_bit),
        .data_valid   (tx_data_valid),
        .data_out     (tx_bit_whitened)
    );

    access_addr_det u_aa_det (
        .clk        (clk_core),
        .rst_n      (rst_n_core),
        .rx_bit     (rx_bit),
        .rx_valid   (rx_active),           // from FSM
        .expected_aa(32'h8E89BED6),
        .aa_match   (aa_match)
    );

    pkt_buffer u_pkt_buf (
        .clk    (clk_core),
        .rst_n  (rst_n_core),
        .wr_en  (tx_active),
        .wr_data(tx_byte),
        .rd_en  (rd_active),
        .rd_data(rx_byte),
        .full   (buf_full),
        .empty  (buf_empty)
    );

endmodule
