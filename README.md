# First-In-First-Out-FIFO-RTL-to-GDSII-VLSI-Design-Flow
This project implements a FIFO memory using Verilog and demonstrates the complete ASIC design flow from RTL to GDSII using Cadence tools. The flow includes synthesis, floorplanning, placement, CTS, routing, timing analysis, and physical verification.

## Tools Used:
Cadence Simulator (Waveform generation)
Cadence Genus ( Generating a gatelevel netlist)
Cadence Innovus ( Physical Design )
Cadence Virtuoso ( Viewing of GDS File)
Verilog HDL (Language used for RTL implementation)

## Working and Verilog Code
This FIFO (First-In First-Out) module works like a queue.
Data is written first and read in the same order.
It has a memory array to store data.
A write pointer decides where new data is stored.
A read pointer decides from where data is read.
When both pointers are equal, FIFO is empty.
When FIFO is full, no more data can be written.
The size and data width can be changed using parameters.

On every clock:
If wr_en is high, data is written.
If rd_en is high, data is read.
This design is synchronous and uses circular buffer logic.

// Parameterized FIFO (First-In First-Out) Memory
// Supports configurable data width and depth
// Provides full and empty status flags

## Verilog Code 

module fifo #(
    parameter data_width = 8,     // Width of each data word
    parameter data_length = 16    // Number of entries in FIFO
)
(
    input clk,                   // Clock input
    input rst_n,                 // Active-low reset
    input wr_en,                 // Write enable
    input rd_en,                 // Read enable
    input [data_width-1:0] din, // Data input
    output reg [data_width-1:0] dout, // Data output
    output wire empty,           // FIFO empty flag
    output wire full             // FIFO full flag
);

    // Address width based on FIFO depth
    localparam ADD_WIDTH = $clog2(data_length);

    // Write and read pointers (extra MSB for full/empty detection)
    reg [ADD_WIDTH:0] wr_ptr;
    reg [ADD_WIDTH:0] rd_ptr;

    // FIFO memory array
    reg [data_width-1:0] mem [0:data_length-1];

    // FIFO empty condition: write pointer equals read pointer
    assign empty = (wr_ptr == rd_ptr);

    // FIFO full condition (circular buffer logic)
    assign full = (wr_ptr[ADD_WIDTH] != rd_ptr[ADD_WIDTH]) &&
                  (wr_ptr[ADD_WIDTH-1:0] == rd_ptr[ADD_WIDTH-1:0]);

    // Write operation
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            wr_ptr <= 0;   // Reset write pointer
        end
        else if (wr_en && !full)
        begin
            mem[wr_ptr[ADD_WIDTH-1:0]] <= din; // Write data into memory
            wr_ptr <= wr_ptr + 1'b1;           // Increment write pointer
        end
    end

    // Read operation
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            rd_ptr <= 0;   // Reset read pointer
        end
        else if (rd_en && !empty)
        begin
            dout <= mem[rd_ptr[ADD_WIDTH-1:0]]; // Read data from memory
            rd_ptr <= rd_ptr + 1'b1;            // Increment read pointer
        end
    end

endmodule

## Verilog Testbench

module fifo_tb();

    // FIFO parameters
    localparam data_width  = 8;    // Width of each data word
    localparam data_length = 16;   // Depth of FIFO

    // Testbench signals
    reg clk;                      // Clock signal
    reg rst_n;                    // Active-low reset
    reg wr_en;                    // Write enable
    reg rd_en;                    // Read enable
    reg [data_width-1:0] din;    // Data input

    wire [data_width-1:0] dout;  // Data output
    wire empty;                  // FIFO empty flag
    wire full;                   // FIFO full flag

    // Instantiate FIFO (Device Under Test)
    fifo #(
        .data_width(data_width),
        .data_length(data_length)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation: 10 time unit period
    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer i;

    // Test sequence
    initial
    begin
        // Initialize signals
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din   = 0;

        #20;
        rst_n = 1;   // Release reset
        #10;

        // Write operation test
        $display("Writing to FIFO");
        for (i = 0; i < 10; i = i + 1)
        begin
            @(posedge clk);
            if (!full)
            begin
                wr_en <= 1;      // Enable write
                din   <= i;      // Write data
                $display($time,"ns: WRITE din=%0d, full=%b, empty=%b", din, full, empty);
            end 
            else
            begin
                wr_en <= 0;
                $display($time,"ns: FIFO full, cannot write");
            end
        end

        // Stop writing
        @(posedge clk);
        wr_en <= 0;
        din   <= 0;

        #20;

        // Read operation test
        $display("Reading from FIFO");
        for (i = 1; i < 10; i = i + 1)
        begin
            @(posedge clk);
            if (!empty)
            begin
                rd_en <= 1;   // Enable read
                $display($time,"ns: READ dout=%0d, full=%b, empty=%b", dout, full, empty);
            end
            else
            begin
                rd_en <= 0;
                $display($time,"ns: FIFO empty, cannot read");
            end
        end

        // Stop reading
        @(posedge clk);
        rd_en <= 0;

        #50;

        $display("Simulation ends");
        $stop;   // End simulation
    end

endmodule

## Cadence SDC File
// Create clock on clk port
// Clock period = 10 ns (100 MHz)
// Rising edge at 0 ns, falling edge at 5 ns
create_clock -name clk -period 10.0 -waveform {0 5} [get_ports clk]

// Set clock uncertainty (jitter + skew)
set_clock_uncertainty 0.2 [get_clocks clk]

// Set input delay for control signals relative to clk
set_input_delay 2.0 -clock clk [get_ports {wr_en rd_en}]

// Set input delay for data input bus relative to clk
set_input_delay 2.0 -clock clk [get_ports din*]

// Set output delay for data output bus relative to clk
set_output_delay 2.0 -clock clk [get_ports dout*]

// Set output delay for status flags relative to clk
set_output_delay 2.0 -clock clk [get_ports {empty full}]

// Define drive strength for input ports
set_drive 0 [get_ports clk]            
set_drive 1 [get_ports {wr_en rd_en}]  
set_drive 1 [get_ports din*]           

// Define load on output ports
set_load 0.1  [get_ports dout*]        
set_load 0.05 [get_ports {empty full}] 

// Exclude reset from timing analysis (asynchronous reset)
set_false_path -from [get_ports rst_n]

## Author
Shivansh Mohan ,
B.Tech Electronics and Communication Engineering
