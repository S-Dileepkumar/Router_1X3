class router_env extends uvm_env;

	
	`uvm_component_utils(router_env)
	
	env_config		m_cfg;
	
	virtual_sequencer 	vseqrh;
	src_agent_top 		s_agt_toph; 
	dst_agent_top 		d_agt_toph;
	router_scoreboard 	r_sbh;
	bit [1:0]addr;
		
	extern function new(string name = "router_env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
endclass

	function router_env::new(string name = "router_env",uvm_component parent );
		super.new(name,parent);
	endfunction
	
	function void router_env::build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
			`uvm_fatal(get_type_name(),"getting the env_config is not happening")

		if(m_cfg.has_src_agt_top)
			s_agt_toph = src_agent_top::type_id::create("s_agt_toph",this);
		
		if(m_cfg.has_dst_agt_top)
			d_agt_toph = dst_agent_top::type_id::create("d_agt_toph",this);
		
		if(m_cfg.has_scoreboard)
			r_sbh = router_scoreboard::type_id::create("r_sbh",this);
			
		if(m_cfg.has_virtual_sequencer)
			vseqrh = virtual_sequencer::type_id::create("vseqrh",this);
		
		
	endfunction

	function void router_env::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		begin
			if(m_cfg.has_src_agt_top)
				begin
					foreach(s_agt_toph.s_agnth[i])
						vseqrh.s_agt_seqrh[i] = s_agt_toph.s_agnth[i].s_seqrh;
						
				end
			
			if(m_cfg.has_dst_agt_top)
				begin
					foreach(d_agt_toph.d_agnth[i])
						vseqrh.d_agt_seqrh[i] = d_agt_toph.d_agnth[i].d_seqrh; 
				end

				
			for(int i = 0; i < m_cfg.no_of_src_agents; i++)
				s_agt_toph.s_agnth[i].s_monh.smon_port.connect(r_sbh.fifo_srch[i].analysis_export);
				
			
			for(int i = 0; i < m_cfg.no_of_dst_agents; i++)
				d_agt_toph.d_agnth[i].d_monh.dmon_port.connect(r_sbh.fifo_dsth[i].analysis_export);
		
		end
	endfunction
