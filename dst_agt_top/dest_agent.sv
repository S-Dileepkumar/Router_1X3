class dst_agent extends uvm_agent;

	`uvm_component_utils(dst_agent)

	dst_agent_config    m_cfg;
	
	dst_agent_monitor   d_monh;
	dst_agent_driver    d_drvh;
	dst_agent_sequencer d_seqrh;

	extern function new(string name = "dst_agent", uvm_component parent = null);
  	extern function void build_phase(uvm_phase phase);
  	extern function void connect_phase(uvm_phase phase);

endclass

//-----------------------------------------------------------function new-------------------------------------------------------------------------------------

	function dst_agent::new(string name = "dst_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction



//-----------------------------------------------------------function build_phase-------------------------------------------------------------------------------------

	function void dst_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",m_cfg))
			`uvm_fatal(get_type_name(),"cannot get() m_cfg from uvm_config_db. Have you set() it?");
		
		d_monh = dst_agent_monitor::type_id::create("d_monh",this);
		
		if(m_cfg.is_active)
		begin
			d_drvh 	= dst_agent_driver::type_id::create("d_drvh",this);
			d_seqrh = dst_agent_sequencer::type_id::create("d_seqrh",this);
		end
	endfunction
	


//-----------------------------------------------------------function connect phase-------------------------------------------------------------------------------------


	function void dst_agent::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
			
		if(m_cfg.is_active==UVM_ACTIVE)
			begin
				d_drvh.seq_item_port.connect(d_seqrh.seq_item_export);
  			end
	endfunction
