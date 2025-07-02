module interface (
    input        sys_clk,
    input        sys_rst,
    input  [31:0] gpio_data_out,
    input  [31:0] gpio_oe,          
    output [31:0] gpio_data_in,
    inout  [31:0] pad_io        
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : io_buf
        assign pad_io[i] = gpio_oe[i] ? gpio_data_out[i] : 1'bz;
        assign gpio_data_in[i] = pad_io[i];
    end
endgenerate
endmodule
