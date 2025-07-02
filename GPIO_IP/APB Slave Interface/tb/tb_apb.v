
module apb_slave_tb;

    // Inputs
    reg pclk;
    reg presetn;
    reg psel;
    reg penable;
    reg pwrite;
    reg [31:0] paddr;
    reg [31:0] pwdata;
    reg gpio_dat_o;
    reg gpio_inta_o;

    // Outputs
    wire pready;
    wire sysclk;
    wire sysrst;
    wire gpio_we;
    wire [31:0] gpio_addr;
    wire [31:0] gpio_dat_i;
    wire [31:0] prdata;
    wire irq;

    // Instantiate the Unit Under Test (UUT)
    APB_slave_interface uut (
        .pclk(pclk), 
        .presetn(presetn), 
        .psel(psel), 
        .penable(penable), 
        .pwrite(pwrite), 
        .paddr(paddr), 
        .pwdata(pwdata), 
        .gpio_dat_o(gpio_dat_o), 
        .gpio_inta_o(gpio_inta_o), 
        .pready(pready), 
        .sysclk(sysclk), 
        .sysrst(sysrst), 
        .gpio_we(gpio_we), 
        .gpio_addr(gpio_addr), 
        .gpio_dat_i(gpio_dat_i), 
        .prdata(prdata), 
        .irq(irq)
    );

    // Clock generation
    always #5 pclk = ~pclk;

    initial begin
        // Initialize Inputs
        pclk = 0;
        presetn = 0;
        psel = 0;
        penable = 0;
        pwrite = 0;
        paddr = 0;
        pwdata = 0;
        gpio_dat_o = 32'hA5A5A5A5;
        gpio_inta_o = 1;

        // Reset pulse
        #10 presetn = 1;

        // Write transaction
        #10;
        paddr = 32'h00000004;
        pwdata = 32'h12345678;
        psel = 1; 
        penable = 0; 
        pwrite = 1; 
        #10;
        penable = 1; 
        #10;
        psel = 0; 
        penable = 0;

        // Wait
        #20;

        // Read transaction
        paddr = 32'h00000004;
        psel = 1; 
        penable = 0; 
        pwrite = 0; 
        #10;
        penable = 1; 
        #10;
        psel = 0; 
        penable = 0;

        // Wait and finish
        #30;
        $finish;
    end

endmodule
