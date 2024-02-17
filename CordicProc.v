module corproc(
        clk,
        ena,
        xin,
        yin,
        rout,
        aout
    );
    input clk;
    input ena;
    input signed [15:0] xin;
    input signed [15:0] yin;
    output [19:0] rout;
    output [15:0] aout;
    localparam pipelength  = 15;
    wire [15:0] xpre;
    wire [15:0] ypre;
    wire [15:0] acor;
    wire [19:0] rcor;
    wire [2:0] q;
    wire [2:0] dq;
    reg [44:0]delay_pipe;
    pre u1 (
            .clk(clk),
            .ena(ena),
            .q(q),
            .xi(xin),
            .yi(yin),
            .xo(xpre),
            .yo(ypre)
        );
    cordic #(
            .pipeline(15),
            .width(16),
            .awidth(16),
            .extend_precision(4)
        ) u2 (
            .clk(clk),
            .ena(ena),
            .xi(xpre),
            .yi(ypre),
            .a(acor),
            .r(rcor)
        );
    post u3 (
            .ai(acor),
            .clk(clk),
            .ena(ena),
            .q(dq),
            .ri(rcor),
            .ao(aout),
            .ro(rout)
        );
    generate
        if ( 1 ) 
        begin : delay
        wire [44:0] delay_pipe;
            always @ (  posedge clk)
            begin
                if ( clk ) 
                begin
                    if ( ena == 1'b1 ) 
                    begin
                     : dummy_label_94
                                        integer n;
                        delay_pipe[0] <= q;
                        for ( n = 1 ; ( n <= 14 ) ; n = ( n + 1 ) )
                        begin 
                            delay_pipe[n] <= delay_pipe[( n - 1 )];
                        end
                    end
                end
            end
            assign dq = delay_pipe[( 15 - 1 )];
        end
    endgenerate
endmodule 
