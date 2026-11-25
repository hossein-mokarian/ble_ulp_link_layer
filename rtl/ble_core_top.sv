
module ble_core_top (
    input logic         clk_core,
    input logic         rst_n_core,

    input logic         pkt_start,
    input logic         pkt_done,
    input logic [6:0]   whit_seed,
    input logic         tx_bit,
    input logic         tx_data_valid,
    input logic         rx_bit,
    input logic         rx_data_valid,

    output logic [15:0] timer_interval,       // connection interval in AON ticks
    output logic        timer_load,
    output logic [23:0] crc_out,
    output logic        whitened_out
);

    // PD_CORE: switchable
    ble_baseband u_ble_baseband (
        .clk_core       (clk_core),
        .rst_n_core     (rst_n_core),

        .pkt_start      (pkt_start),
        .pkt_done       (pkt_done),
        .whit_seed      (whit_seed),
        .tx_bit         (tx_bit),
        .tx_data_valid  (tx_data_valid),
        .rx_bit         (rx_bit),
        .rx_data_valid  (rx_data_valid),

        .crc_out        (crc_out),
        .whitened_out   (whitened_out),
        .pwr_good       ()
    );

endmodule