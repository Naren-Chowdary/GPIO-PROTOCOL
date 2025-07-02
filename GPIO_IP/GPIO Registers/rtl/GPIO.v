`define RGPIO_IN        32'h00
`define RGPIO_OUT       32'h04
`define RGPIO_OE        32'h08
`define RGPIO_INTE      32'h0C
`define RGPIO_PTRIG     32'h10
`define RGPIO_AUX       32'h14
`define RGPIO_CTRL      32'h18
`define RGPIO_INTS      32'h1C
`define RGPIO_ECLK      32'h20
`define RGPIO_NEC       32'h24

`define RGPIO_CTRL_INTE 1'b0
`define RGPIO_CTRL_INTS 1'b1

module GPIO_register (
    input         sysclk,
    input         sysrst,
    input         gpio_we,
    input  [31:0] gpio_addr,
    input  [31:0] gpio_dat_i,
    input  [31:0] aux_i,
    input  [31:0] in_pad_i,
    input         gpio_eclk,
    output        gpio_inta_o,
    output reg [31:0] gpio_dat_o,
    output [31:0] out_pad_o,
    output [31:0] oen_padoe_o
);

    reg [31:0] rgpio_in;
    reg [31:0] rgpio_out;
    reg [31:0] rgpio_oe;
    reg [31:0] rgpio_inte;
    reg [31:0] rgpio_ptrig;
    reg [31:0] rgpio_aux;
    reg [31:0] rgpio_ints;
    reg [31:0] rgpio_eclk;
    reg [31:0] rgpio_nec;
    reg [1:0]  rgpio_ctrl;
    reg [31:0] data_reg;

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_in <= 32'b0;
        else
            rgpio_in <= in_pad_i;
    end

    assign out_pad_o    = rgpio_out;
    assign oen_padoe_o  = rgpio_oe;

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_out <= 32'b0;
        else if ((gpio_addr == `RGPIO_OUT) && gpio_we)
            rgpio_out <= gpio_dat_i;
    end

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_oe <= 32'b0;
        else if ((gpio_addr == `RGPIO_OE) && gpio_we)
            rgpio_oe <= gpio_dat_i;
    end

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_inte <= 32'b0;
        else if ((gpio_addr == `RGPIO_INTE) && gpio_we)
            rgpio_inte <= gpio_dat_i;
    end

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_ptrig <= 32'b0;
        else if ((gpio_addr == `RGPIO_PTRIG) && gpio_we)
            rgpio_ptrig <= gpio_dat_i;
    end

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_aux <= 32'b0;
        else if ((gpio_addr == `RGPIO_AUX) && gpio_we)
            rgpio_aux <= gpio_dat_i;
    end

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_eclk <= 32'b0;
        else if ((gpio_addr == `RGPIO_ECLK) && gpio_we)
            rgpio_eclk <= gpio_dat_i;
    end

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_nec <= 32'b0;
        else if ((gpio_addr == `RGPIO_NEC) && gpio_we)
            rgpio_nec <= gpio_dat_i;
    end

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_ctrl <= 2'b00;
        else if ((gpio_addr == `RGPIO_CTRL) && gpio_we)
            rgpio_ctrl <= gpio_dat_i[1:0];
        else if (rgpio_ctrl[`RGPIO_CTRL_INTE])
            rgpio_ctrl[`RGPIO_CTRL_INTS] <= rgpio_ctrl[`RGPIO_CTRL_INTS] | gpio_inta_o;
    end

    always @(posedge sysclk or posedge sysrst) begin
        if (sysrst)
            rgpio_ints <= 32'b0;
        else
            rgpio_ints <= rgpio_inte & (rgpio_in ^ rgpio_ptrig);
    end

    assign gpio_inta_o = |(rgpio_ints);

    always @(*) begin
        case (gpio_addr)
            `RGPIO_IN:     gpio_dat_o = rgpio_in;
            `RGPIO_OUT:    gpio_dat_o = rgpio_out;
            `RGPIO_OE:     gpio_dat_o = rgpio_oe;
            `RGPIO_INTE:   gpio_dat_o = rgpio_inte;
            `RGPIO_PTRIG:  gpio_dat_o = rgpio_ptrig;
            `RGPIO_AUX:    gpio_dat_o = rgpio_aux;
            `RGPIO_CTRL:   gpio_dat_o = {30'b0, rgpio_ctrl};
            `RGPIO_INTS:   gpio_dat_o = rgpio_ints;
            `RGPIO_ECLK:   gpio_dat_o = rgpio_eclk;
            `RGPIO_NEC:    gpio_dat_o = rgpio_nec;
            default:       gpio_dat_o = 32'h00000000;
        endcase
    end

endmodule
