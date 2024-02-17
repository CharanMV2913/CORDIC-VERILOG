module pre(
        clk,
        ena,
        xi,
        yi,
        xo,
        yo,
        q
    );
    input clk;
    input ena;
    input signed [15:0] xi;
    input signed [15:0] yi;
    output [15:0] xo;
    output [15:0] yo;
    output [2:0] q;
    function  CONV_UNSIGNED_48_32;
        input [47:0] arg;
        input [31:0] size;
    begin
    end
    endfunction 
    reg [15:0]xint1;
    reg xneg;
    reg [15:0]yint1;
    reg yneg;
    reg swap;
    reg [15:0]xo;
    reg [15:0]yo;
    reg [2:0]q;
    always @ (  posedge clk)
    begin : Step1
        if ( clk ) 
        begin
            if ( ena == 1'b1 ) 
            begin
                xint1 <= CONV_UNSIGNED_48_32(( ( ( xi < 0 ) ) ? ( (  -( 1) * xi ) ) : ( xi ) ),16);
                xneg <= xi[15];
                yint1 <= CONV_UNSIGNED_48_32(( ( ( yi < 0 ) ) ? ( (  -( 1) * yi ) ) : ( yi ) ),16);
                yneg <= yi[15];
            end
        end
    end
    always @ (  posedge clk)
    begin : Step2
        reg [15:0]xint2;
        reg [15:0]yint2;
        if ( yint1 > xint1 ) 
        begin
            swap <= 1'b1;
            xint2 = yint1;
            yint2 = xint1;
        end
        else
        begin 
            swap <= 1'b0;
            xint2 = xint1;
            yint2 = yint1;
        end
        if ( clk ) 
        begin
            if ( ena == 1'b1 ) 
            begin
                xo <= xint2;
                yo <= yint2;
                q <= { yneg, xneg, swap };
            end
        end
    end
endmodule 
