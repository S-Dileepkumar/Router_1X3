package router_pkg;

    // Import UVM package
    import uvm_pkg::*;

    // Include UVM macros
    `include "uvm_macros.svh"
	`include "source_agent_config.sv"
	`include "dest_agent_config.sv"
    // Environment configuration
    `include "env_config.sv"

    // Source agent files
    `include "src_xtn.sv"
    
    `include "source_agent_driver.sv"
    `include "source_agent_monitor.sv"
    `include "source_agent_sequencer.sv"
    `include "source_agent.sv"
    `include "source_agent_top.sv"
    `include "source_agent_seqs.sv"

    // Destination agent files
    `include "dst_xtn.sv"
    
    `include "dest_agent_driver.sv"
    `include "dest_agent_monitor.sv"
    `include "dest_agent_sequencer.sv"
    `include "dest_agent_seqs.sv"
    `include "dest_agent.sv"
    `include "dest_agent_top.sv"

    // Virtual sequencer and sequences
    `include "virtual_sequencer.sv"
    `include "virtual_sequence.sv"

    // Scoreboard
    `include "router_scoreboard.sv"

    // Environment
    `include "router_env.sv"

    // Testbench
    `include "test.sv"

endpackage