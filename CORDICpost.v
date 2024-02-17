module post(
        clk,
        ena,
        ai,
        ri,
        q,
        ao,
        ro
    );
    input clk;
    input ena;
    input [15:0] ai;
    input [19:0] ri;
    input [2:0] q;
    output [15:0] ao;
    output [19:0] ro;
    function  CONV_INTEGER_20;
        input [19:0] arg;
    begin
    end
    endfunction 
    reg [0:33554463]rada;
    reg [0:33554463]radb;
    reg [0:33554463]radc;
    function  CONV_UNSIGNED_33554464_32;
        input [33554463:0] arg;
        input [31:0] size;
        wire [0:33554463] radc;
    begin
    end
    endfunction 
    reg [14:0]angstep1;
    reg [2:1]dq;
    reg [15:0]angstep2;
    reg ddq;
    reg [16:0]angstep3;
    generate
        if ( 1 ) 
        begin : radius
        wire [0:33554463] rada;
        wire [0:33554463] radb;
        wire [0:33554463] radc;
            always @ (  posedge clk)
            begin
                        reg [31:0]tmp;
                tmp = CONV_INTEGER_20(unsigned'(ri));
                if ( clk ) 
                begin
                    if ( ena == 1'b1 ) 
                    begin
                        rada <= ( tmp - ( tmp / 8 ) );
                        radb <= ( rada - ( rada / 64 ) );
                        radc <= ( radb - ( radb / 512 ) );
                    end
                end
            end
            assign ro = CONV_UNSIGNED_33554464_32(radc,20);
        end
    endgenerate
    generate
        if ( 1 ) 
        begin : angle
        wire [2:1] dq;
        wire ddq;
        wire [14:0] angstep1;
        wire [15:0] angstep2;
        wire [16:0] angstep3;
            always @ (  posedge clk)
            begin : angle_step1
                        reg overflow;
                        reg [14:0]anga;
                        reg [14:0]angb;
                        reg [14:0]ang;
                overflow = ( ai[14] & ai[13] );
                if ( overflow == 1'b1 ) 
                begin
                    anga = { 1'b0 };
                end
                else
                begin 
                    anga = unsigned'({ 1'b0, ai[13:0] });
                end
                angb = ( ( 2 ** 14 ) - anga );
                if ( q[0] == 1'b1 ) 
                begin
                    ang = angb;
                end
                else
                begin 
                    ang = anga;
                end
                if ( clk ) 
                begin
                    if ( ena == 1'b1 ) 
                    begin
                        angstep1 <= ang;
                        dq <= q[2:1];
                    end
                end
            end
            always @ (  posedge clk)
            begin : angle_step2
                        reg [15:0]anga;
                        reg [15:0]angb;
                        reg [15:0]ang;
                anga = { 1'b0, angstep1 };
                angb = ( ( 2 ** 15 ) - anga );
                if ( dq[1] == 1'b1 ) 
                begin
                    ang = angb;
                end
                else
                begin 
                    ang = anga;
                end
                if ( clk ) 
                begin
                    if ( ena == 1'b1 ) 
                    begin
                        angstep2 <= ang;
                        ddq <= dq[2];
                    end
                end
            end
            always @ (  posedge clk)
            begin : angle_step3
                        reg [16:0]anga;
                        reg [16:0]angb;
                        reg [16:0]ang;
                anga = { 1'b0, angstep2 };
                angb = ( ( 2 ** 16 ) - anga );
                if ( ddq == 1'b1 ) 
                begin
                    ang = angb;
                end
                else
                begin 
                    ang = anga;
                end
                if ( clk ) 
                begin
                    if ( ena == 1'b1 ) 
                    begin
                        angstep3 <= ang;
                    end
                end
            end
            assign ao = angstep3[15:0];
        end
    endgenerate
endmodule 
