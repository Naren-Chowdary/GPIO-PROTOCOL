module tb_GPIO_register;

  reg         sysclk;
  reg         sysrst;
  reg         gpio_we;
  reg  [31:0] gpio_addr;
  reg  [31:0] gpio_dat_i;
  reg  [31:0] aux_i;
  reg  [31:0] in_pad_i;
  reg         gpio_eclk;

  wire        gpio_inta_o;
  wire [31:0] gpio_dat_o;
  wire [31:0] out_pad_o;
  wire [31:0] oen_padoe_o;

  GPIO_register uut (
    .sysclk(sysclk),
    .sysrst(sysrst),
    .gpio_we(gpio_we),
    .gpio_addr(gpio_addr),
    .gpio_dat_i(gpio_dat_i),
    .aux_i(aux_i),
    .in_pad_i(in_pad_i),
    .gpio_eclk(gpio_eclk),
    .gpio_inta_o(gpio_inta_o),
    .gpio_dat_o(gpio_dat_o),
    .out_pad_o(out_pad_o),
    .oen_padoe_o(oen_padoe_o)
  );

  initial sysclk = 0;
  always #5 sysclk = ~sysclk;

  initial begin
    sysrst = 1;
    gpio_we = 0;
    gpio_addr = 0;
    gpio_dat_i = 0;
    aux_i = 0;
    in_pad_i = 0;
    gpio_eclk = 0;

    #20 sysrst = 0;

    write_reg(32'h04, 32'hA5A5A5A5);
    #10;

    write_reg(32'h08, 32'hFFFFFFFF);
    #10;

    in_pad_i = 32'h12345678;
    #10;
    read_reg(32'h00);

    write_reg(32'h0C, 32'h000000FF);
    write_reg(32'h10, 32'h000000FF);
    #10;

    in_pad_i = 32'h000000F0;
    #10;
    read_reg(32'h1C);

    #20;
    $finish;
  end

  task write_reg(input [31:0] addr, input [31:0] data);
    begin
      @(posedge sysclk);
      gpio_addr = addr;
      gpio_dat_i = data;
      gpio_we = 1;
      @(posedge sysclk);
      gpio_we = 0;
    end
  endtask

  task read_reg(input [31:0] addr);
    begin
      @(posedge sysclk);
      gpio_addr = addr;
      gpio_we = 0;
      @(posedge sysclk);
    end
  endtask

endmodule
