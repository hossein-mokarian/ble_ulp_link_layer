
module checker_isolation #(
    parameter string ELEM_NAME = "",
    parameter int ELEM_MSB = 0,
    parameter int ELEM_LSB = 0
)(
    input logic [ELEM_MSB:ELEM_LSB] iso_out,
    input logic iso_ctrl,
    input logic iso_clamp
);

    always_ff @(posedge iso_ctrl) begin
        assert (iso_out[ELEM_LSB] == iso_clamp)
            else $error("Incorrect clamp value for isolated port: %s[%d:%d]\n",
                        ELEM_NAME, ELEM_MSB, ELEM_LSB);
    end

endmodule
