
class dst_agent_top extends uvm_env;
	`uvm_component_utils(dst_agent_top)

	dst_agent d_agnth[];
	env_config env_cfgh;

	extern function new(string name = "dst_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	

endclass
	
//-----------------------------------------------------------function new-------------------------------------------------------------------------------------
	function dst_agent_top::new(string name = "dst_agent_top",uvm_component parent);
			super.new(name,parent);
	endfunction


	
//-----------------------------------------------------------function build_phase-------------------------------------------------------------------------------------
	function void dst_agent_top::build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfgh))
			`uvm_fatal(get_type_name(),"cannot get() env_cfgh from uvm_config_db. Have you set() it?");

		d_agnth = new[env_cfgh.no_of_dst_agents];
		foreach(d_agnth[i])
			begin
				uvm_config_db #(dst_agent_config)::set(this,$sformatf("d_agnth[%0d]*",i),"dst_agent_config",env_cfgh.dst_agt_cfg[i]);
				d_agnth[i] = dst_agent::type_id::create($sformatf("d_agnth[%0d]",i),this);
			end
	endfunction
	

