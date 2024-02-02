module post (
    input clk,
    input ena,
    input [15:0] Ai,
    input [19:0] Ri,
    input [2:0] Q,
    output reg [15:0] Ao,
    output reg [19:0] Ro
);

// Constants
parameter cPI2 = 16'd16384; // Pi/2 = 0x4000
parameter cPI = 16'd32768; // Pi = 0x8000
parameter c2PI = 16'd65536; // 2*Pi = 0x10000

// Radius calculation block
reg [19:0] RadA, RadB, RadC;

always @(posedge clk) begin
    if (ena == 1'b1) begin
        RadA <= Ri - (Ri / 8);
        RadB <= RadA - (RadA / 64);
        RadC <= RadB - (RadB / 512);
    end
end

// Angle calculation block
reg [2:0] dQ;
reg ddQ;
reg [14:0] AngStep1;
reg [15:0] AngStep2;
reg [16:0] AngStep3;

always @(posedge clk) begin
    if (ena == 1'b1) begin
        // Step 1
        if (Ai[14] && Ai[13]) begin
            AngStep1 <= 15'd0;
        end else begin
            AngStep1 <= {1'b0, Ai[13:0]};
        end
        
        if (Q[0] == 1'b1) begin
            AngStep1 <= cPI2 - AngStep1;
        end
        
        dQ <= {Q[2], Q[1]};
        
        // Step 2
        AngStep2 <= {1'b0, AngStep1};
        
        if (dQ[1] == 1'b1) begin
            AngStep2 <= cPI - AngStep2;
        end
        
        ddQ <= dQ[2];
        
        // Step 3
        AngStep3 <= {1'b0, AngStep2};
        
        if (ddQ == 1'b1) begin
            AngStep3 <= c2PI - AngStep3;
        end
        
        Ao <= AngStep3[15:0];
    end
end

// Output assignment
always @(posedge clk) begin
    if (ena == 1'b1) begin
        Ro <= RadC;
    end
end

endmodule
