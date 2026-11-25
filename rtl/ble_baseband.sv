
module ble_baseband (
    input logic       clk_core,
    input logic       rst_n_core,

    input logic       pkt_start,   // from AON
    input logic       pkt_done,
    input logic [6:0] whit_seed, // channel_number + 1 ==> 7'd38
    input logic       tx_bit,
    input logic       tx_data_valid,
    input logic       rx_bit,
    input logic       rx_data_valid,

    output logic [15:0] timer_interval,       // connection interval in AON ticks
    output logic        timer_load,
    output logic [23:0] crc_out,
    output logic        whitened_out,
    output logic        pwr_good
);

    logic crc_init, whit_init;
    // logic tx_data_valid;
    // logic rx_data_valid;
    // logic pkt_done; // Todo: crc_done && whit_done
    logic buf_full;
    logic buf_empty;


    ble_ll_fsm u_fsm (
        .clk        (clk_core),
        .rst_n      (rst_n_core),

        .pkt_start  (pkt_start),     // from AON
        .pkt_done   (pkt_done),     // Todo:

        .crc_init   (crc_init),
        .whit_init  (whit_init),

        .tx_active  (), // tx_data_valid
        .rx_active  (), // rx_data_valid

        .timer_interval (timer_interval),       // connection interval in AON ticks
        .timer_load     (timer_load),
        .pwr_good      (pwr_good)
    );

    crc24 u_crc (
        .clk        (clk_core),
        .rst_n      (rst_n_core),

        .init       (crc_init),
        .data_in    (tx_bit),
        .data_valid (tx_data_valid),  // from FSM

        .crc_out    (crc_out)
    );

    whitening u_whit (
        .clk          (clk_core),
        .rst_n        (rst_n_core),

        .init         (whit_init),
        .channel_seed (whit_seed),
        .data_in      (tx_bit),
        .data_valid   (tx_data_valid),  // from FSM
        
        .data_out     (whitened_out)
    );

    // access_addr_det u_aa_det (
    //     .clk        (clk_core),
    //     .rst_n      (rst_n_core),
    //     .rx_bit     (rx_bit),
    //     .rx_valid   (rx_data_valid),    // from FSM
    //     .expected_aa(32'h8E89BED6),
    //     .aa_match   (aa_match)  // Todo:
    // );

    // pkt_buffer u_pkt_buf (
    //     .clk    (clk_core),
    //     .rst_n  (rst_n_core),
    //     .wr_en  (tx_active), // Todo:
    //     .wr_data(tx_byte), // Todo:
    //     .rd_en  (rd_active), // Todo:
    //     .rd_data(rx_byte), // Todo:
    //     .full   (buf_full),
    //     .empty  (buf_empty)
    // );

endmodule
