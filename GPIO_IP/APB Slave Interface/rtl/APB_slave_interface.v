module APB_slave_interface (
    input pclk, 
    input presetn, 
    input psel, 
    input penable, 
    input pwrite,
    input [31:0] paddr, 
    input [31:0] pwdata, 
    input gpio_dat_o, 
    input gpio_inta_o,
    output pready, 
    output sysclk, 
    output sysrst,
    output reg gpio_we, 
    output [31:0] gpio_addr, 
    output reg [31:0] gpio_dat_i, 
    output [31:0] prdata,
    output irq
);

parameter IDLE   = 2'b00,
          ENABLE = 2'b10,
          SETUP  = 2'b01;

reg [1:0] ps, ns;

always @(posedge pclk) begin
    if (!presetn)
        ps <= IDLE;
    else
        ps <= ns;
end

always @(*) begin
    ns = IDLE;
    case (ps)
        IDLE: begin
            if (psel && !penable)
                ns = SETUP;
            else
                ns = IDLE;
        end
        SETUP: begin
            if (psel && penable)
                ns = ENABLE;
            else if (psel && !penable)
                ns = SETUP;
        end
        ENABLE: begin
            if (psel && penable)
                ns = ENABLE;
            else if (!psel && penable)
                ns = IDLE;
            else if (psel && !penable)
                ns = SETUP;
        end
    endcase
end

assign sysclk = pclk;
assign sysrst = ~presetn;
assign gpio_addr = paddr;
assign irq = gpio_inta_o;

reg [31:0] data_out;
assign prdata = data_out;

always @(*) begin
    gpio_we = 1'b0;
    gpio_dat_i = 32'b0;
    data_out = 32'b0;

    if (pwrite && ps == ENABLE) begin
        gpio_dat_i = pwdata;
        gpio_we = 1'b1;
    end
    else if (!pwrite && ps == ENABLE) begin
        data_out = gpio_dat_o;
    end
end

assign pready = 1'b1;

endmodule
