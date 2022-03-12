`default_nettype none

/*
 * shift_register_piso - A simple parallel-in serial-out shift register module
 *
 * Parameters:
 *  WIDTH - The bit width of the shift register
 *  COVER - For testing use only. Set to 1 to include cover properties during formal verification
 *
 * Ports:
 *  clk_i - The system clock
 *  rst_i - An active high, synchronus reset that sets the internal register value to 0. Asserting this is the same as
 *          asserting set_i with value_i equal to 0.
 *  set_i - Asserting loads the internal register with the value of value_i. Takes precedence over advance_i.
 *  bit_o - The output bit. Is equal to the least-significant bit of the internal register value.
 *  advance_i - Shifts over the internal register one value to the right
 *  value_i - See set_i.
 */
module shift_register_piso #(
    parameter WIDTH = 8,
    parameter COVER = 0
) (
    input wire  clk_i,
    input wire  rst_i,
    input wire  set_i,
    input wire  advance_i,
    output wire bit_o,
    input wire  [WIDTH-1:0] value_i
);

    reg [WIDTH-1:0] value;
    always @(posedge clk_i)
        if (rst_i)
            value <= 0;
        else if (set_i)
            value <= value_i;
        else if (advance_i)
            value <= {1'b0,value[WIDTH-1:1]};
        else
            value <= value;

    assign bit_o = value[0];

`ifdef FORMAL
    // Keep track of whether or not $past() is valid
    reg f_past_valid = 0;
    always @(posedge clk_i)
        f_past_valid <= 1;

`endif

endmodule

`default_nettype wire
