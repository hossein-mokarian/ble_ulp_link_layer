`timescale 1ns/1ps

module tb_aon_ctrl;

    logic clk;
    logic rst_n;

    logic wake_req;
    logic pwr_good;

    logic core_pwr_en;
    logic iso_en_core;
    logic ret_save_n;
    logic ret_restore_n;


    aon_ctrl u_aon_ctrl (
        .clk_aon        (clk),
        .rst_n          (rst_n),

        .wake_req       (wake_req),
        .pwr_good       (pwr_good),
        
        .core_pwr_en    (core_pwr_en),
        .iso_en_core    (iso_en_core),
        .ret_save_n     (ret_save_n),
        .ret_restore_n  (ret_restore_n)
    );


    initial clk = 0;
    always #5 clk = ~clk;


    initial begin

        //--- init ---
        wake_req = 1'b1;
        pwr_good = 1'b1;

        //--- reset ---
        rst_n = 1'b0;
        repeat(5) @(posedge clk);
        rst_n = 1'b1;
        repeat(5) @(posedge clk);

        //--- Test ---
        repeat(2) @(posedge clk);
        wake_req = 1'b0;
        pwr_good = 1'b0;

        while(core_pwr_en) @(posedge clk);

        @(posedge clk);
        wake_req = 1'b1;
        @(posedge clk);
        pwr_good = 1'b1;

        repeat(10) @(posedge clk);
        $finish;

    end

    initial begin
        $dumpfile("tb_aon_ctrl.vcd");
        $dumpvars(0, tb_aon_ctrl);
    end

endmodule
