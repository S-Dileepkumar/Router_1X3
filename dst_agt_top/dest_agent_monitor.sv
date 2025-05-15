class dst_agent_monitor extends uvm_monitor;
		
	`uvm_component_utils(dst_agent_monitor)

	virtual router_if.DST_MON_MP vif;
		
		dst_agent_config m_cfg;

	uvm_analysis_port #(dst_xtn) dmon_port; 
		

	extern function new(string name = "dst_agent_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);	
	extern function void connect_phase(uvm_phase phase);	
	extern task run_phase(uvm_phase phase);	
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);
endclass

//-------------------------------------------------------function new--------------------------------------------------------------------------------


	function dst_agent_monitor::new(string name ="dst_agent_monitor",uvm_component parent);
			super.new(name,parent);
			dmon_port = new("dmon_port",this);
		endfunction
	
//-------------------------------------------------------build_phase--------------------------------------------------------------------------------


	function void dst_agent_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",m_cfg))
			`uvm_fatal(get_type_name(),"cannot get() m_cfg from uvm_config_db. Have you set() it?");

		endfunction 
	
//--------------------------------------------------------connect_phase-------------------------------------------------------------------------------


	function void dst_agent_monitor::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
			vif = m_cfg.vif;
		endfunction 

//-------------------------------------------------------report phase--------------------------------------------------------------------------------


	function void dst_agent_monitor::report_phase(uvm_phase phase);
		endfunction


//-------------------------------------------------------run_phase--------------------------------------------------------------------------------

	task dst_agent_monitor::run_phase(uvm_phase phase);
		forever begin collect_data(); end
	endtask


//-------------------------------------------------------task_collect_data--------------------------------------------------------------------------------

	task dst_agent_monitor::collect_data();
		dst_xtn xtn;
		xtn = dst_xtn::type_id::create("xtn");
		
		while(vif.dst_mon_cb.read_enb !== 1)
			@(vif.dst_mon_cb);
		
		@(vif.dst_mon_cb);

		xtn.header = vif.dst_mon_cb.dout;
		xtn.payload = new[xtn.header[7:2]];
		@(vif.dst_mon_cb);
		
		foreach(xtn.payload[i])
		begin
			xtn.payload[i] = vif.dst_mon_cb.dout;
			@(vif.dst_mon_cb);
		end
			xtn.parity = vif.dst_mon_cb.dout;
			//@(vif.dst_mon_cb);
			`uvm_info(get_type_name(),"dst agent monitor",UVM_LOW)
		//	xtn.print();
			@(vif.dst_mon_cb);
	
			dmon_port.write(xtn);
		
	endtask 
		
		
