class src_agent_driver extends uvm_driver #(src_xtn);
		
	`uvm_component_utils(src_agent_driver)
	
	virtual router_if.SRC_DRV_MP vif;

	src_agent_config s_cfg;
	
	extern function new(string name = "src_agent_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task to_dut(src_xtn xtn);
	extern task reset_main();
	extern function void report_phase(uvm_phase phase);
	
endclass



//-------------------------------------------------------new function--------------------------------------------------------------------------------

	function src_agent_driver::new(string name ="src_agent_driver",uvm_component parent);
		super.new(name,parent);
	endfunction


	
//-------------------------------------------------------build_phase--------------------------------------------------------------------------------

	function void src_agent_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",s_cfg))
			`uvm_fatal(get_type_name(),"getting is not possible for src_agent_config in src_driver")	
	endfunction


//------------------------------------------------------connect_phase--------------------------------------------------------------------------------


	function void src_agent_driver::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = s_cfg.vif;
	endfunction
	

//------------------------------------------------------taskrun_phase--------------------------------------------------------------------------------


	task src_agent_driver::run_phase(uvm_phase phase);
		
			//$display("from the src agent driver");
		
		reset_main();

		forever 
			begin
			seq_item_port.get_next_item(req);
										//`uvm_info(get_type_name(),"printing from get_next_item \n",UVM_LOW)
			to_dut(req);				//`uvm_info(get_type_name(),"printing from to_dut  \n",UVM_LOW)
										//`uvm_info(get_type_name(),"printing from req print \n",UVM_LOW)
			seq_item_port.item_done();
										//`uvm_info(get_type_name(),"printing from item_done \n",UVM_LOW)	
			end
	endtask


//----------------------------------------------source agent driver  to dut function------------------------------------------------------------------


task src_agent_driver::to_dut(src_xtn xtn);
	`uvm_info(get_type_name(),"printing from src_driver \n",UVM_LOW)

		@(vif.src_drv_cb);

	while(vif.src_drv_cb.busy !== 0 )
	begin
		@(vif.src_drv_cb);
	end
		
		vif.src_drv_cb.pkt_valid  <= 1'b1;
		vif.src_drv_cb.data_in 	  <= xtn.header;
		
		@(vif.src_drv_cb);
	
	foreach(xtn.payload[i])
	begin	
	
		while(vif.src_drv_cb.busy !== 0 )
			begin 
				@(vif.src_drv_cb);
			end

		vif.src_drv_cb.data_in   <= xtn.payload[i];
		@(vif.src_drv_cb); 

	end

		while(vif.src_drv_cb.busy !== 0 )
			@(vif.src_drv_cb);
				 
		vif.src_drv_cb.pkt_valid   <= 1'b0;
		vif.src_drv_cb.data_in 	  <= xtn.parity;
		@(vif.src_drv_cb); 
		//$display("src_drv_cb busy  -- 5");		
endtask


//-------------------------------------------------------report function--------------------------------------------------------------------------------
	
	function void src_agent_driver::report_phase(uvm_phase phase);	

	endfunction	

//-------------------------------------------------------reset_main function--------------------------------------------------------------------------------

	task src_agent_driver::reset_main();

			@(vif.src_drv_cb) 
			
			vif.src_drv_cb.rstn 	 <= 1'b0;
			
			repeat(2)
			@(vif.src_drv_cb) 

			vif.src_drv_cb.rstn 	 <= 1'b1;
	endtask
