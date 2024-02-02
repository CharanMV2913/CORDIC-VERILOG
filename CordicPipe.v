module CordicPipe (
    input clk,
    input ena,
    input [WIDTH-1:0] Xi,
    input [WIDTH-1:0] Yi,
    input [AWIDTH-1:0] Zi,
    output reg [WIDTH-1:0] Xo,
    output reg [WIDTH-1:0] Yo,
    output reg [AWIDTH-1:0] Zo
);

// Define functions
function integer CATAN;
    input [31:0] n;
    begin
        case(n)
            5'd1: CATAN = 32'h012E40;
            5'd2: CATAN = 32'h09FB4;
            5'd3: CATAN = 32'h05111;
            5'd4: CATAN = 32'h028B1;
            5'd5: CATAN = 32'h0145D;
            5'd6: CATAN = 32'h0A2F;
            5'd7: CATAN = 32'h0518;
            5'd8: CATAN = 32'h028C;
            5'd9: CATAN = 32'h0146;
            5'd10: CATAN = 32'h0A3;
            5'd11: CATAN = 32'h051;
            5'd12: CATAN = 32'h029;
            5'd13: CATAN = 32'h014;
            5'd14: CATAN = 32'h0A;
            5'd15: CATAN = 32'h05;
            5'd16: CATAN = 32'h03;
            5'd17: CATAN = 32'h01;
            default: CATAN = 32'h0;
        endcase
    end
endfunction

function [WIDTH-1:0] Delta;
    input [WIDTH-1:0] Arg;
    input [31:0] Cnt;
    begin
        reg [WIDTH-1:0] tmp;
        tmp = Arg;
        integer n;
        for (n = 1; n <= Cnt; n = n + 1) begin
            tmp = {tmp[WIDTH-1], tmp[WIDTH-1:1]};
        end
        Delta = tmp;
    end
endfunction

function [WIDTH-1:0] AddSub;
    input [WIDTH-1:0] dataa;
    input [WIDTH-1:0] datab;
    input add_sub;
    begin
        if (add_sub == 1'b1) begin
            AddSub = dataa + datab;
        end else begin
            AddSub = dataa - datab;
        end
    end
endfunction

// Define signals
reg [WIDTH-1:0] dX, Xresult;
reg [WIDTH-1:0] dY, Yresult;
reg [AWIDTH-1:0] atan, Zresult;
reg Yneg, Ypos;

// Architecture body
always @(posedge clk) begin
    if (ena == 1'b1) begin
        dX <= Delta(Xi, PIPEID);
        dY <= Delta(Yi, PIPEID);
        atan <= CATAN(PIPEID);
        Yneg <= Yi[WIDTH-1];
        Ypos <= ~Yi[WIDTH-1];
        Xresult <= AddSub(Xi, dY, Ypos);
        Yresult <= AddSub(Yi, dX, Yneg);
        Zo <= AddSub(Zi, atan, Ypos);
        Xo <= Xresult;
        Yo <= Yresult;
    end
end

endmodule
