`timescale 1ns/1ps

module tb_power_seq;

    logic clk;
    logic rst_n;

    logic wake_req;
    logic timer_load;
    logic pwr_good;
    
    logic core_pwr_en;
    logic iso_en_core;
    logic ret_save_n;
    logic ret_restore_n;


    aon_ctrl u_aon_ctrl(
        .clk_aon(clk),
        .rst_n(rst_n),

        .wake_req(wake_req),
        .timer_load(1'b0),
        .pwr_good(1'b1),
        
        .core_pwr_en(core_pwr_en),
        .iso_en_core(iso_en_core),
        .ret_save_n(ret_save_n),
        .ret_restore_n(ret_restore_n)
    );

    checker_isolation #(
        .ELEM_NAME("iso_core_out"),
        .ELEM_MSB(0),
        .ELEM_LSB(0)
    ) u_iso_checker (
        .iso_out(), // Todo: 
        .iso_ctrl(iso_en_core),
        .iso_clamp(1'b0)
    );

    checker_retention #(
        .ELEM_NAME("ret_bank"),
        .ELEM_MSB(0),
        .ELEM_LSB(0)
    ) u_ret_checker (
        .ret_elem(),
        .restore_sig(ret_restore_n),
        .power_off(!core_pwr_en)
    );


    initial clk = 0;
    always #5 clk = ~clk;


    initial begin

        //--- init ---
        wake_req = 1'b0;

        //--- reset ---
        rst_n = 1'b0;
        repeat(5) @(posedge clk);
        rst_n = 1'b1;
        repeat(5) @(posedge clk);

        //--- Test ---

        wake_req = 1'b1;
        repeat(20) @(posedge clk);

        wake_req = 1'b0;
        repeat(20) @(posedge clk);


        repeat(10) @(posedge clk);
        $finish;

    end


    initial begin
        $dumpfile("tb_power_seq.vcd");
        $dumpvars(0, tb_power_seq);
    end

endmodule
