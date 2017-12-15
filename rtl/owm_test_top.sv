
module owm_test_top (
    input        clk_50M_i ,
    output [7:0] led_o     ,
    input  [3:0] sw_i      ,
    inout        ow_io
);
    logic clk_1M;
    logic clk   ;
    logic rstn  ;

    pll pll_inst (
        .inclk0 ( clk_50M_i ),
        .c0     ( clk_1M    ),
        .c1     ( clk       ),
        .locked ( rstn      )
    );

    logic ow_i;
    logic ow_o;

    owm_sys u0 (
        .clk_clk       ( clk   ),
        .reset_reset_n ( rstn  ),

        .ow_i          ( ow_i  ),
        .ow_o          ( ow_o  ),

        .led_o_export  ( led_o ),
        .sw_i_export   ( sw_i  )
    );

    opndrn ow_buf (.in(ow_o), .out(ow_io));
    assign ow_i = ow_io;

endmodule
