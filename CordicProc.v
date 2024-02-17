module cordicProc (
    input clk,
    input ena,
    input signed [15:0] Xin,
    input signed [15:0] Yin,
    output reg [19:0] Rout,
    output reg [15:0] Aout
);

parameter PipeLength = 15;
// Define signals
reg [15:0] Xpre, Ypre, Acor;
reg [19:0] Rcor;
reg [2:0] Q, dQ;

// Instantiate components
pre u1 (
    .clk(clk),
    .ena(ena),
    .Xi(Xin),
    .Yi(Yin),
    .Xo(Xpre),
    .Yo(Ypre),
    .Q(Q)
);

cordic u2 (
    .clk(clk),
    .ena(ena),
    .Xi(Xpre),
    .Yi(Ypre),
    .R(Rcor),
    .A(Acor)
);

post u3 (
    .clk(clk),
    .ena(ena),
    .Ai(Acor),
    .Ri(Rcor),
    .Q(dQ),
    .Ao(Aout),
    .Ro(Rout)
);

// Block for delay
reg [2:0] delay_pipe [PipeLength - 1:0];
integer n;
always @(posedge clk) begin
    if (ena == 1'b1) begin
        delay_pipe[0] <= Q;
        for (n = 1; n < PipeLength; n = n + 1) begin
            delay_pipe[n] <= delay_pipe[n - 1];
        end
    end
end

assign dQ = delay_pipe[PipeLength - 1];

endmodule
