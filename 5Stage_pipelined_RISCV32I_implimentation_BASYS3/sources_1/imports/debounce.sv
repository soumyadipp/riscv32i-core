module debounce (
    input  logic clk,       
    input  logic btn_in,    // Raw button input
    output logic btn_out    // Debounced output 
);

    parameter DELAY = 0;

    logic [1:0] count = 0;
    logic        btn_sync_0, btn_sync_1;
    logic        btn_state = 0;

    always_ff @(posedge clk) begin
        // Synchronize to system clock
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;

        // Debounce logic
        if (btn_sync_1 != btn_state) begin
            count <= count + 1;
            if (count >= DELAY) begin
                btn_state <= btn_sync_1;
                count <= 0;
            end
        end else begin
            count <= 0;
        end
    end

    assign btn_out = (btn_sync_1 & ~btn_state); // 1-cycle pulse when pressed
endmodule
