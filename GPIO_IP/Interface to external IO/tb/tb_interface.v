module tb_interface;

    reg         sys_clk;
    reg         sys_rst;
    reg  [31:0] gpio_data_out;
    reg  [31:0] gpio_oe;
    wire [31:0] gpio_data_in;
    wire [31:0] pad_io;

    reg  [31:0] pad_driver;
    reg  [31:0] pad_drive_en;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : pad_model
            assign pad_io[i] = pad_drive_en[i] ? pad_driver[i] : 1'bz;
        end
    endgenerate

    interface dut (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .gpio_data_out(gpio_data_out),
        .gpio_oe(gpio_oe),
        .gpio_data_in(gpio_data_in),
        .pad_io(pad_io)
    );

    initial sys_clk = 0;
    always #5 sys_clk = ~sys_clk;

    initial begin
        sys_rst = 1;
        gpio_data_out = 32'b0;
        gpio_oe = 32'b0;
        pad_driver = 32'b0;
        pad_drive_en = 32'b0;

        #10 sys_rst = 0;

        // Test 1: Drive all outputs
        gpio_data_out = 32'hA5A5A5A5;
        gpio_oe = 32'hFFFFFFFF;
        #10;

        // Test 2: All inputs from external
        gpio_oe = 32'h00000000;
        pad_drive_en = 32'hFFFFFFFF;
        pad_driver = 32'h12345678;
        #10;

        // Test 3: Mixed mode
        gpio_oe = 32'hFFFF0000;
        gpio_data_out = 32'hDEADBEEF;
        pad_driver = 32'hCAFEBABE;
        pad_drive_en = 32'h0000FFFF;
        #10;

        $finish;
    end

endmodule
