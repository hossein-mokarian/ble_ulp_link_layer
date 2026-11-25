`timescale 1ns/1ps

module tb_ble_soc;

    logic         clk_aon;
    logic         rst_n;

    logic         clk_core;
    logic         rst_n_core;

    logic         pkt_start;
    logic         pkt_done;
    logic [6:0]   whit_seed;
    logic         tx_bit;
    logic         tx_data_valid;
    logic         rx_bit;
    logic         rx_data_valid;

    logic [23:0] crc_out;
    logic        whitened_out;

    logic        core_pwr_en;
    logic        iso_en_core;
    logic        ret_save_n;
    logic        ret_restore_n;

    ble_soc_top u_ble_soc_top (
    .clk_aon        (clk_aon),
    .rst_n          (rst_n),

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

    .core_pwr_en    (core_pwr_en),
    .iso_en_core    (iso_en_core),
    .ret_save_n     (ret_save_n),
    .ret_restore_n  (ret_restore_n)
);

    initial clk_core = 0;
    always #5 clk_core = ~clk_core;

    assign clk_aon = clk_core;

    initial begin

        //--- init ---
        pkt_start = 1'b0;
        pkt_done = 1'b0;
        whit_seed = 'd38;
        tx_bit = 1'b0;
        tx_data_valid = 1'b0;
        rx_bit = 1'b0;
        rx_data_valid = 1'b0;

        //--- reset ---
        rst_n = 1'b0;
        rst_n_core = 1'b0;
        repeat(5) @(posedge clk_core);
        rst_n = 1'b1;
        rst_n_core = 1'b1;
        repeat(5) @(posedge clk_core);

        //--- Test ---

        repeat(10) @(posedge clk_core);
        $finish;
    end

    initial begin
        $dumpfile("tb_ble_soc.vcd");
        $dumpvars(0, tb_ble_soc);
    end

endmodule
