class dst_agent_config extends uvm_object;
	
	`uvm_object_utils(dst_agent_config)
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	
	virtual router_if vif;
	
	extern function new(string name = "dst_agent_config");

endclass

function dst_agent_config::new(string name = "dst_agent_config");
	super.new(name);
	endfunction
