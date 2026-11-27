
module checker_retention #(
    parameter string ELEM_NAME = "",
    parameter int ELEM_MSB = 0,
    parameter int ELEM_LSB = 0
)(
    input logic [ELEM_MSB:ELEM_LSB] ret_elem,
    input logic restore_sig,
    input logic power_off
);

    always_ff @(posedge restore_sig) begin
        assert (power_off == 1'b0)
            else $error("Incorrect restore protocol for %s[%d:%d] \n",
                        ELEM_NAME, ELEM_MSB, ELEM_LSB);
    end

endmodule
