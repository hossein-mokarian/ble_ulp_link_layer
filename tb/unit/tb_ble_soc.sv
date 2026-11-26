`timescale 1ns/1ps

module tb_ble_soc;

    localparam CRC_SEED = 24'h515555;

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

    integer failures;
    integer byte_idx;
    integer bit_idx;

    logic [23:0] exp_crc_value;
    logic fb;

    logic [7:0] golden_pdu_crc [0:20];
    logic [7:0] golden_whitened [0:20];


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

    // Self-check task
    task check;
        input expected;
        input actual;
        input [167:0] label;
        
        begin
            if (actual === expected)
                $display("PASS: %s", label);
            else begin
                $display("FAIL: %s expected=%b got=%b", label, expected, actual);
                failures = failures + 1;
            end
        end
    endtask


    initial begin

        //--- init ---
        pkt_start = 1'b0;
        pkt_done = 1'b0;
        whit_seed = 7'd38;
        tx_bit = 1'b0;
        tx_data_valid = 1'b0;
        rx_bit = 1'b0;
        rx_data_valid = 1'b0;
        failures = 0;
        byte_idx = 0;
        bit_idx = 0;
        exp_crc_value = CRC_SEED;
        fb = 1'b0;

        $readmemb("golden_pdu_crc.hex", golden_pdu_crc);
        $readmemb("golden_whitened.hex", golden_whitened);

        //--- reset ---
        rst_n = 1'b0;
        rst_n_core = 1'b0;
        repeat(5) @(posedge clk_core);
        rst_n = 1'b1;
        rst_n_core = 1'b1;
        repeat(5) @(posedge clk_core);

        
        //--- Test ---

        while(!u_ble_soc_top.u_aon_timer.wake_req) @(posedge clk_aon);
        while(!u_ble_soc_top.u_ble_baseband.pwr_good) @(posedge clk_core);
        repeat(2) @(posedge clk_aon);

        // Start packet
        @(negedge clk_core);
        pkt_start = 1;
        @(negedge clk_core);
        pkt_start = 0;

        exp_crc_value = CRC_SEED;
        fb = 1'b0;

        // Feed 216 bits (PDU 208 bits + CRC 24 bits = 232)
        for (byte_idx = 0; byte_idx < 18; byte_idx++) begin
            for (bit_idx = 7; bit_idx >= 0; bit_idx--) begin
                tx_bit = golden_pdu_crc[byte_idx][bit_idx];  // MSB-first feed
                tx_data_valid = 1;
                @(posedge clk_core);

                $display("++++++++++++++++++++++++++++++++");
                $display("crc_out = %x", crc_out);
                $display("exp_crc_value = %x", exp_crc_value);
                assert (exp_crc_value == crc_out) 
                    else $error("%t, The crc value is not correct. crc_out=%x , exp_crc_value = %x", $time, crc_out, exp_crc_value);

                fb = tx_bit ^ exp_crc_value[23];
                exp_crc_value = {exp_crc_value[22:0], 1'b0} ^ (fb ? 24'h00065B : 24'h000000);
            end
        end

        // One cycle latency
        @(posedge clk_core);
        tx_data_valid = 0;
        @(posedge clk_core);

        // Self-check CRC
        $display("========================================");
        $display("crc_out = %x", crc_out);
        check(1'b1, (crc_out == 24'h1BC475), "CRC-24 matches golden");

        $display("========================================");
        if (failures == 0)
            $display("ALL TESTS PASSED (0 failures)");
        else
            $display("TEST FAILED: %0d failures", failures);
        $display("========================================");

        
        repeat(50) @(posedge clk_core);
        $finish;

    end
    

    initial begin
        $dumpfile("tb_ble_soc.vcd");
        $dumpvars(0, tb_ble_soc);
    end

endmodule
