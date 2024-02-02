module pre (
    input clk,
    input ena,
    input signed [15:0] Xi,
    input signed [15:0] Yi,
    output reg [15:0] Xo,
    output reg [15:0] Yo,
    output reg [2:0] Q
);

// Define signals
reg [15:0] Xint1, Yint1;
reg Xneg, Yneg, swap;

// Step 1: Determine absolute value of X and Y, set Xneg and Yneg
always @(posedge clk) begin
    if (ena == 1'b1) begin
        Xint1 <= $signed($abs(Xi));
        Xneg <= Xi[15];

        Yint1 <= $signed($abs(Yi));
        Yneg <= Yi[15];
    end
end

// Step 2: Swap X and Y if Y>X
always @(posedge clk) begin
    if (Yint1 > Xint1) begin
        swap <= 1'b1;
        Xo <= Yint1;
        Yo <= Xint1;
    end else begin
        swap <= 1'b0;
        Xo <= Xint1;
        Yo <= Yint1;
    end
    
    if (ena == 1'b1) begin
        Q <= {Yneg, Xneg, swap};
    end
end

endmodule
