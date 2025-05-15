class src_agent extends uvm_agent;

	`uvm_component_utils(src_agent)

	src_agent_config    m_cfg;
	
	src_agent_monitor   s_monh;
	src_agent_driver    s_drvh;
	src_agent_sequencer s_seqrh;

	extern function new(string name = "src_agent", uvm_component parent = null);
  	extern function void build_phase(uvm_phase phase);
  	extern function void connect_phase(uvm_phase phase);

endclass

	function src_agent::new(string name = "src_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void src_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",m_cfg))
			`uvm_fatal(get_type_name(),"cannot get() m_cfg from uvm_config_db. Have you set() it?");
		
		s_monh = src_agent_monitor::type_id::create("s_monh",this);
		
		if(m_cfg.is_active)
		begin
			s_drvh 	= src_agent_driver::type_id::create("s_drvh",this);
			s_seqrh = src_agent_sequencer::type_id::create("s_seqrh",this);
		end
	endfunction
	
	function void src_agent::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
			
		if(m_cfg.is_active==UVM_ACTIVE)
			begin
				s_drvh.seq_item_port.connect(s_seqrh.seq_item_export);
  			end
	endfunction
