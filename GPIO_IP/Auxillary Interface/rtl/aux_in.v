module aux_in (
    input  wire        sys_clk,   // System clock
    input  wire        sys_rst,   // Asynchronous active-high reset
    input  wire [31:0] aux_in,    // Auxiliary input
    output wire [31:0] aux_i      // Auxiliary output
);

    reg [31:0] aux_reg;
      always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            aux_reg <= 32'b0;
        else
            aux_reg <= aux_in;
    end
    assign aux_i = aux_reg;
endmodule
