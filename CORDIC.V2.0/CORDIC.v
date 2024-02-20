module cordic(
        clk,
        ena,
        xi,
        yi,
        r,
        a
    );
    parameter [31:0]pipeline  = 15;
    parameter [31:0]width  = 16;
    parameter [31:0]awidth  = 16;
    parameter [31:0]extend_precision  = 4;
    input clk;
    input ena;
    input [( width - 1 ):0] xi;
    input [( width - 1 ):0] yi;
    output [( width - 1 ):0] r;
    output [( awidth - 1 ):0] a;
    wire [pipeline:0] x;
    wire [pipeline:0] y;
    wire [pipeline:0] z;
    genvar n;
    assign x[( width + extend_precision ):extend_precision] = { 1'b0, xi };
    generate
        for ( n = ( extend_precision - 1 ) ; ( n >= 0 ) ; n = ( n - 1 ) )
        begin : fill_x
            assign x[0][n] = 1'b0;
        end
    endgenerate
    assign y[( width + extend_precision ):extend_precision] = { yi[( width - 1 )], yi };
    generate
        for ( n = ( extend_precision - 1 ) ; ( n >= 0 ) ; n = ( n - 1 ) )
        begin : fill_y
            assign y[0][n] = 1'b0;
        end
    endgenerate
    generate
        for ( n = ( 20 - 1 ) ; ( n >= 0 ) ; n = ( n - 1 ) )
        begin : fill_z
            assign z[0][n] = 1'b0;
        end
    endgenerate
    generate
        for ( n = 1 ; ( n <= pipeline ) ; n = ( n + 1 ) )
        begin : gen_pipe
            cordicpipe #(
                    .width(( ( width + extend_precision ) + 1 )),
                    .awidth(20),
                    .pipeid(n)
                ) pipe (
                    .clk(clk),
                    .ena(ena),
                    .xi(x[( n - 1 )]),
                    .yi(y[( n - 1 )]),
                    .zi(z[( n - 1 )]),
                    .xo(x[n]),
                    .yo(y[n]),
                    .zo(z[n])
                );
        end
    endgenerate
    assign r = x;
    assign a = z[19:( 20 - awidth )];
endmodule 
