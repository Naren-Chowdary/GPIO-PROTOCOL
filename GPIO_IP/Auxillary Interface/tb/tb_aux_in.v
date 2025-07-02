module tb_aux_in;
    reg         sys_clk;
    reg         sys_rst;
    reg  [31:0] aux_in;
    wire [31:0] aux_i;

    aux_in dut (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .aux_in(aux_in),
        .aux_i(aux_i)
    );

    initial sys_clk = 0;
    always #5 sys_clk = ~sys_clk;
    initial begin
        sys_rst = 1;
        aux_in  = 32'hA5A5A5A5;
         #12;
        sys_rst = 0;
        #10 aux_in = 32'h12345678;  
        #10 aux_in = 32'hFFFFFFFF;
        #10 aux_in = 32'h00000000;
        #10 sys_rst = 1;
        #10 sys_rst = 0;
        #10 aux_in = 32'hDEADBEEF;
        #20;
        $finish;
    end
endmodule

