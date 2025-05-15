class src_agent_monitor extends uvm_monitor;
		
	`uvm_component_utils(src_agent_monitor)

	virtual router_if.SRC_MON_MP vif;

	src_agent_config s_cfg;

	uvm_analysis_port  #(src_xtn) smon_port;
		
	extern function new(string name = "src_agent_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);	
	extern function void connect_phase(uvm_phase phase);	
	extern task run_phase(uvm_phase phase);	
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);	
endclass


//-------------------------------------------------------new function--------------------------------------------------------------------------------
	function src_agent_monitor::new(string name = "src_agent_monitor",uvm_component parent);
			super.new(name,parent);
			smon_port = new("smon_port",this);
		endfunction
	

//-------------------------------------------------------build_phase--------------------------------------------------------------------------------

	function void src_agent_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
			
			if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",s_cfg))
				`uvm_fatal(get_type_name(),"getting the s_cfg is not done , set it properly ")
		endfunction 


//-------------------------------------------------------connect_phase--------------------------------------------------------------------------------
	
	function void src_agent_monitor::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	
			vif = s_cfg.vif;
	
		endfunction 
//------------------------------------------------------report_phase----------------------------------------------------------------------------------

	function void src_agent_monitor::report_phase(uvm_phase phase);
	endfunction 

//-------------------------------------------------------task_run_phase--------------------------------------------------------------------------------


	task src_agent_monitor::run_phase(uvm_phase phase);
		forever 
			begin	
			collect_data();
			end
	endtask



//-------------------------------------------------------task_collect_data--------------------------------------------------------------------------------

	task src_agent_monitor::collect_data();
	
		src_xtn xtn;
		xtn = src_xtn::type_id::create("xtn");

		while(vif.src_mon_cb.pkt_valid !== 1) 
				@(vif.src_mon_cb);
			
		
		while(vif.src_mon_cb.busy !== 0)
				@(vif.src_mon_cb);
		
		xtn.header = vif.src_mon_cb.data_in;
		xtn.payload = new[xtn.header[7:2]];

		@(vif.src_mon_cb);
		
	//	$display("src monitor");
	//	$display("header %b",xtn.header);
		`uvm_info(get_type_name(),$sformatf("header %0d  pkt valid %b",xtn.header,vif.src_mon_cb.pkt_valid),UVM_LOW);
	
		foreach(xtn.payload[i])
			begin

				while(vif.src_mon_cb.busy !== 0)
					begin @(vif.src_mon_cb); 
						$display("busy == 1  inside foreach loop"); 
					end

					xtn.payload[i] = vif.src_mon_cb.data_in;
					@(vif.src_mon_cb);
					
			end

		while(vif.src_mon_cb.pkt_valid !== 0)
			begin 
				@(vif.src_mon_cb); 
			end

		while(vif.src_mon_cb.busy !== 0)
			begin 
				@(vif.src_mon_cb); 
				$display("busy == 1 before parity");
			end

		xtn.parity = vif.src_mon_cb.data_in;
		//$display("parity got it");
	
		repeat(2)
		begin
		@(vif.src_mon_cb);
		//$display("collect ----- 5");
		end

		xtn.error = vif.src_mon_cb.err;
	//	$display("src_monitor transaction");	
	//	xtn.print();	
		
		smon_port.write(xtn);
			
	endtask
//--------------------------------------------------------end_of_class------------------------------------------------------------------------------------
