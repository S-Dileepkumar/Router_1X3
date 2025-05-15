class dst_agent_driver extends uvm_driver #(dst_xtn);
		
	`uvm_component_utils(dst_agent_driver)
	
	virtual router_if.DST_DRV_MP vif;

	dst_agent_config s_cfg;
	
	extern function new(string name = "dst_agent_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task to_dut(dst_xtn xtn);
	extern function void report_phase(uvm_phase phase);
	
endclass

//-----------------------------------------------------------function new-------------------------------------------------------------------------------------
	function dst_agent_driver::new(string name = "dst_agent_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
//-----------------------------------------------------------function build phase-------------------------------------------------------------------------------------


	function void dst_agent_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",s_cfg))
			`uvm_fatal(get_type_name(),"getting is not possible for dst_agent_config in dst_driver")	
	endfunction


//-----------------------------------------------------------function connect phase--------------------------------------------------------------------------

	function void dst_agent_driver::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = s_cfg.vif;
	endfunction
	
//----------------------------------------------------------task run phase-----------------------------------------------------------------------------------

	task dst_agent_driver::run_phase(uvm_phase phase);
		forever 
			begin
				seq_item_port.get_next_item(req);
				to_dut(req);	
				seq_item_port.item_done();
			end 

	endtask


//-----------------------------------------------------------task to dut----------------------------------------------------------------------------------


	task dst_agent_driver::to_dut(dst_xtn xtn);

//		`uvm_info(get_type_name(),$sformatf("printing from dst_driver \n%p",xtn),UVM_LOW)
		`uvm_info(get_type_name(),"printing from dst_driver ",UVM_LOW)
//		xtn.print();
		@(vif.dst_drv_cb);
		vif.dst_drv_cb.read_enb <= 1'b0; 

		$display("no_of_cycles is %0d",xtn.no_of_cycles);
		
		while(vif.dst_drv_cb.vld_out !== 1)
			begin 
				@(vif.dst_drv_cb);
			end

		repeat(xtn.no_of_cycles)
			begin 
				@(vif.dst_drv_cb);
			 end

		vif.dst_drv_cb.read_enb <= 1'b1;
				@(vif.dst_drv_cb);			//--------	
	
		while(vif.dst_drv_cb.vld_out !== 0)
			begin @(vif.dst_drv_cb);
			//	$display("task dst dut 3");
			 end

		vif.dst_drv_cb.read_enb <= 1'b0; 
				@(vif.dst_drv_cb);			//--------	
		
	endtask

	
//-----------------------------------------------------------function report phase----------------------------------------------------------------------


	function void dst_agent_driver::report_phase(uvm_phase phase);
		//`uvm_info(s_cfg.get_type_name(),$sformatf("printing from dst_driver \n%p",s_cfg),UVM_LOW)
	endfunction
