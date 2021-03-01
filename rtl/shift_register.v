`default_nettype none

module shift_register #(
    parameter WIDTH = 8,
    parameter COVER = 0
) (
    input wire clk_i,
    input wire rst_i,
    input wire advance_i,
    input wire bit_i,
    output wire [WIDTH-1:0] value_o
);

    reg [WIDTH-1:0] value;
    assign value_o = value;
    always @(posedge clk_i)
        if (rst_i)
            value <= 0;
        else if (advance_i)
            value <= {value[WIDTH-2:0],bit_i};
        else
            value <= value;

`ifdef FORMAL
    // Keep track of whether or not $past() is valid
    reg f_past_valid = 0;
    always @(posedge clk_i)
        f_past_valid <= 1;

    // Create a testbench that writes the value 0xa5 to the shift register
    generate if (COVER==1 && WIDTH >= 8) begin
        reg [5:0] f_num_advance = 0;
        reg [5:0] f_num_reset = 0;
        always @(posedge clk_i) begin
            f_num_advance <= f_num_advance + advance_i;
            f_num_reset <= f_num_reset + rst_i;
        end
        always @(posedge clk_i)
            cover(f_num_reset>=1 && f_num_advance>=16 && value_o==8'ha5);
    end endgenerate

    // Check that the shift register advances if and only if requested
    always @(posedge clk_i)
        if (f_past_valid)
            if ($past(rst_i))
                assert(value_o == 0);
            else if ($past(advance_i))
                assert(value_o == $past({value_o[WIDTH-2:0],bit_i}));
            else
                assert(value_o == $past(value_o));
`endif

endmodule

`default_nettype wire
