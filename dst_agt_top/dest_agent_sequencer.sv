class dst_agent_sequencer extends uvm_sequencer #(dst_xtn);
		
	`uvm_component_utils(dst_agent_sequencer)
	
	extern function new(string name = "dst_agent_sequencer", uvm_component parent);
endclass

	function dst_agent_sequencer::new(string name = "dst_agent_sequencer",uvm_component parent);
			super.new(name,parent);
		endfunction
