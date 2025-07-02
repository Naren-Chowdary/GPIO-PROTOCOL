module gpio_top (
    // APB interface
    input         pclk,
    input         presetn,
    input         psel,
    input         penable,
    input         pwrite,
    input  [31:0] paddr,
    input  [31:0] pwdata,
    output [31:0] prdata,
    output        pready,
    output        irq,

    // AUX interface
    input  [31:0] aux_in,

    // IO Pads
    inout  [31:0] io_pad,
    input         ext_clk_pad_i
);

    // Internal connections
    wire         sysclk;
    wire         sysrst;
    wire         gpio_we;
    wire [31:0]  gpio_addr;
    wire [31:0]  gpio_dat_i;
    wire [31:0]  gpio_dat_o;
    wire [31:0]  aux_i;
    wire [31:0]  in_pad_i;
    wire [31:0]  out_pad_o;
    wire [31:0]  oen_padoe_o;
    wire         gpio_inta_o;

    // APB slave interface
    APB_slave_interface u_apb_slave (
        .pclk        (pclk),
        .presetn     (presetn),
        .psel        (psel),
        .penable     (penable),
        .pwrite      (pwrite),
        .paddr       (paddr),
        .pwdata      (pwdata),
        .gpio_dat_o  (gpio_dat_o),
        .gpio_inta_o (gpio_inta_o),
        .pready      (pready),
        .sysclk      (sysclk),
        .sysrst      (sysrst),
        .gpio_we     (gpio_we),
        .gpio_addr   (gpio_addr),
        .gpio_dat_i  (gpio_dat_i),
        .prdata      (prdata),
        .irq         (irq)
    );

    // AUX input block
    aux_in u_aux (
        .sys_clk (sysclk),
        .sys_rst (sysrst),
        .aux_in  (aux_in),
        .aux_i   (aux_i)
    );

    // GPIO register block
    GPIO_register u_gpio_reg (
        .sysclk        (sysclk),
        .sysrst        (sysrst),
        .gpio_we       (gpio_we),
        .gpio_addr     (gpio_addr),
        .gpio_dat_i    (gpio_dat_i),
        .aux_i         (aux_i),
        .in_pad_i      (in_pad_i),
        .gpio_eclk     (ext_clk_pad_i),
        .gpio_inta_o   (gpio_inta_o),
        .gpio_dat_o    (gpio_dat_o),
        .out_pad_o     (out_pad_o),
        .oen_padoe_o   (oen_padoe_o)
    );

    // IO interface
    interface u_io (
        .sys_clk        (sysclk),
        .sys_rst        (sysrst),
        .gpio_data_out  (out_pad_o),
        .gpio_oe        (oen_padoe_o),
        .gpio_data_in   (in_pad_i),
        .pad_io         (io_pad)
    );

endmodule
