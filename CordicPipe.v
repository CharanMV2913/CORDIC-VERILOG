module cordicpipe(
        clk,
        ena,
        xi,
        yi,
        zi,
        xo,
        yo,
        zo
    );
    parameter [31:0]width ;
    parameter [31:0]awidth ;
    parameter [31:0]pipeid ;
    input clk;
    input ena;
    input [( width - 1 ):0] xi;
    input [( width - 1 ):0] yi;
    input [( awidth - 1 ):0] zi;
    output [( width - 1 ):0] xo;
    output [( width - 1 ):0] yo;
    output [( awidth - 1 ):0] zo;
    wire [( width - 1 ):0] dx;
    wire [( width - 1 ):0] xresult;
    wire [( width - 1 ):0] dy;
    wire [( width - 1 ):0] yresult;
    wire [( awidth - 1 ):0] atan;
    wire [( awidth - 1 ):0] zresult;
    wire yneg;
    wire ypos;
    function  Delta_1_32;
        input arg;
        input [31:0] cnt;
        reg tmp;
        integer n;
    begin
        tmp = arg;
        for ( n = 1 ; ( n <= cnt ) ; n = ( n + 1 ) )
        begin 
            tmp = { tmp, tmp };
        end
        Delta_1_32 = tmp;
    end
    endfunction 
    function [31:0] CATAN_32;
        input [31:0] n;
        integer result;
    begin
        case ( n ) 
        1:
        begin
            result = 77376;
        end
        2:
        begin
            result = 40884;
        end
        3:
        begin
            result = 20753;
        end
        4:
        begin
            result = 10417;
        end
        5:
        begin
            result = 5213;
        end
        6:
        begin
            result = 2607;
        end
        7:
        begin
            result = 1304;
        end
        8:
        begin
            result = 652;
        end
        9:
        begin
            result = 326;
        end
        10:
        begin
            result = 163;
        end
        11:
        begin
            result = 81;
        end
        12:
        begin
            result = 41;
        end
        13:
        begin
            result = 20;
        end
        14:
        begin
            result = 10;
        end
        15:
        begin
            result = 5;
        end
        16:
        begin
            result = 3;
        end
        17:
        begin
            result = 1;
        end
        default :
        begin
            result = 0;
        end
        endcase
        CATAN_32 = result;
    end
    endfunction 
    function  CONV_UNSIGNED_32_32;
        input [31:0] arg;
        input [31:0] size;
    begin
    end
    endfunction 
    function [1:0] AddSub_1_1_1;
        input dataa;
        input datab;
        input add_sub;
    begin
        if ( add_sub == 1'b1 ) 
        begin
            AddSub_1_1_1 = ( unsigned'(dataa) + unsigned'(datab) );
        end
        else
        begin 
            AddSub_1_1_1 = ( unsigned'(dataa) - unsigned'(datab) );
        end
    end
    endfunction 
    reg [( width - 1 ):0]xo;
    reg [( width - 1 ):0]yo;
    reg [( awidth - 1 ):0]zo;
    assign dx = Delta_1_32(xi,pipeid);
    assign dy = Delta_1_32(yi,pipeid);
    assign atan = CONV_UNSIGNED_32_32(CATAN_32(pipeid),awidth);
    assign yneg = yi[( width - 1 )];
    assign ypos =  ~( yi[( width - 1 )]);
    assign xresult = AddSub_1_1_1(xi,dy,ypos);
    assign yresult = AddSub_1_1_1(yi,dx,yneg);
    assign zresult = AddSub_1_1_1(zi,atan,ypos);
    always @ (  posedge clk)
    begin : gen_regs
        if ( clk ) 
        begin
            if ( ena == 1'b1 ) 
            begin
                xo <= xresult;
                yo <= yresult;
                zo <= zresult;
            end
        end
    end
endmodule 
