
class src_agent_top extends uvm_env;
	`uvm_component_utils(src_agent_top)

	src_agent  s_agnth[];
	env_config env_cfgh;

	extern function new(string name = "src_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);


endclass
	
	function src_agent_top::new(string name = "src_agent_top",uvm_component parent);
			super.new(name,parent);
	endfunction
	
	function void src_agent_top::build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfgh))
			`uvm_fatal(get_type_name(),"getting is not possible for env_config in src_agent_top")

		s_agnth = new[env_cfgh.no_of_src_agents];

		foreach(s_agnth[i])
			begin
				uvm_config_db #(src_agent_config)::set(this,$sformatf("s_agnth[%0d]*",i),"src_agent_config",env_cfgh.src_agt_cfg[i]);
				s_agnth[i] = src_agent::type_id::create($sformatf("s_agnth[%0d]",i),this);
			end
	endfunction
	
	function void src_agent_top::end_of_elaboration_phase(uvm_phase phase);
		//uvm_top.print_topology;
	endfunction
