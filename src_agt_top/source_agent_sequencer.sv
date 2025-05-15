class src_agent_sequencer extends uvm_sequencer #(src_xtn);
		
	`uvm_component_utils(src_agent_sequencer)
	
	extern function new(string name = "src_agent_sequencer", uvm_component parent);
endclass

	function src_agent_sequencer::new(string name = "src_agent_sequencer",uvm_component parent);
			super.new(name,parent);
		endfunction
