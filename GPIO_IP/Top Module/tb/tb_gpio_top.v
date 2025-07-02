module tb_gpio_top;

    reg         pclk;
    reg         presetn;
    reg         psel;
    reg         penable;
    reg         pwrite;
    reg  [31:0] paddr;
    reg  [31:0] pwdata;
    wire [31:0] prdata;
    wire        pready;
    wire        irq;

    reg  [31:0] aux_in;

    wire [31:0] io_pad;
    reg  [31:0] pad_driver;
    reg  [31:0] pad_drive_en;
    wire        ext_clk_pad_i;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : io_model
            assign io_pad[i] = pad_drive_en[i] ? pad_driver[i] : 1'bz;
        end
    endgenerate

    assign ext_clk_pad_i = pclk;

    gpio_top dut (
        .pclk           (pclk),
        .presetn        (presetn),
        .psel           (psel),
        .penable        (penable),
        .pwrite         (pwrite),
        .paddr          (paddr),
        .pwdata         (pwdata),
        .prdata         (prdata),
        .pready         (pready),
        .irq            (irq),
        .aux_in         (aux_in),
        .io_pad         (io_pad),
        .ext_clk_pad_i  (ext_clk_pad_i)
    );

    initial pclk = 0;
    always #5 pclk = ~pclk;

    initial begin
        presetn = 0;
        psel    = 0;
        penable = 0;
        pwrite  = 0;
        paddr   = 0;
        pwdata  = 0;
        aux_in  = 32'hCAFEBABE;
        pad_driver = 32'h0;
        pad_drive_en = 32'h0;

        #20;
        presetn = 1;

        apb_write(32'h04, 32'hAAAAAAAA);
        apb_write(32'h08, 32'hFFFFFFFF);

        #20;

        pad_drive_en = 32'hFFFFFFFF;
        pad_driver   = 32'h55AA55AA;

        apb_read(32'h00);

        apb_write(32'h0C, 32'h0000FFFF);
        apb_write(32'h10, 32'h00000000);

        #10;
        pad_driver = 32'h000000FF;
        #10;

        apb_read(32'h1C);

        #50;
        $finish;
    end

    task apb_write(input [31:0] addr, input [31:0] data);
        begin
            @(posedge pclk);
            paddr   = addr;
            pwdata  = data;
            pwrite  = 1;
            psel    = 1;
            penable = 0;

            @(posedge pclk);
            penable = 1;

            @(posedge pclk);
            psel    = 0;
            penable = 0;
            pwrite  = 0;
        end
    endtask

    task apb_read(input [31:0] addr);
        begin
            @(posedge pclk);
            paddr   = addr;
            pwrite  = 0;
            psel    = 1;
            penable = 0;

            @(posedge pclk);
            penable = 1;

            @(posedge pclk);
            psel    = 0;
            penable = 0;
        end
    endtask

endmodule
