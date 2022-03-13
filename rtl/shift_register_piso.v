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

    // Create a testbench that sends the value 0xa5 out on bit_o
    generate if (COVER==1 && WIDTH == 8) begin
        reg [5:0] f_num_advance = 0;
        reg [5:0] f_num_reset = 0;
        reg [7:0] f_data = 0;
        always @(posedge clk_i) begin
            if (f_past_valid && $past(advance_i))
                f_data <= {bit_o,f_data[7:1]};

            f_num_reset <= f_num_reset + rst_i;

            if (rst_i || set_i)
                f_num_advance <= 0;
            else
                f_num_advance <= f_num_advance + advance_i;
        end
        always @(posedge clk_i)
            cover(f_data==8'ha5 && f_num_advance>=8 && f_num_reset>=1);

    end endgenerate

    // Check that the shift register advances if and only if requested
    always @(posedge clk_i)
        if (f_past_valid)
            if ($past(rst_i))
                assert(bit_o == 0);
            else if ($past(set_i))
                assert(bit_o == $past(value_i[0]));
            else if ($past(advance_i))
                assert(bit_o == $past(value[1]));
            else
                assert(bit_o == $past(bit_o));

`endif

endmodule

`default_nettype wire
