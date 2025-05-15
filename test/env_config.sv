class env_config extends uvm_object;
    `uvm_object_utils(env_config)
    
    dst_agent_config dst_agt_cfg[];
    src_agent_config src_agt_cfg[];

    int no_of_src_agents = 1;
    int no_of_dst_agents = 3;

    bit has_src_agt_top = 1;
    bit has_dst_agt_top = 1;
    bit has_scoreboard = 1;
    
    bit has_virtual_sequencer = 1;
    extern function new(string name = "env_config");

endclass

	function env_config::new(string name = "env_config");
    		super.new(name);
	endfunction
