
class router_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(router_scoreboard)

	uvm_tlm_analysis_fifo #(src_xtn) fifo_srch[];
	uvm_tlm_analysis_fifo #(dst_xtn) fifo_dsth[];
	
	src_xtn s_xtn;	

	dst_xtn d_xtn;
	

	int no_of_sxtn,no_of_dxtn;
	int no_of_cmp;
	env_config envh;

	covergroup router_fcov1;
	
		option.per_instance = 1;
		
		ADDR : coverpoint s_xtn.header[1:0]{
							bins addr1 = {2'b00};
							bins addr2 = {2'b01};
							bins addr3 = {2'b10};
							}
		SIZE : coverpoint s_xtn.header[7:2]{
							bins size1 = {[1:20]};
							bins size2 = {[21:40]};
							bins size3 = {[41:63]};
							}
		ERROR : coverpoint s_xtn.error{
						        bins e1 ={1'b0};
						        bins e2 ={1'b1};
							}
		
		ADDR_X_SIZE :cross ADDR,SIZE;
	endgroup


	covergroup router_fcov2;
	
		option.per_instance = 1;
		
		ADDR1 : coverpoint d_xtn.header[1:0]{
							bins addr1 = {2'b00};
							bins addr2 = {2'b01};
							bins addr3 = {2'b10};
							}
		SIZE1 : coverpoint d_xtn.header[7:2]{
							bins size1 = {[1:20]};
							bins size2 = {[21:40]};
							bins size3 = {[41:63]};
							}
	
		ADDR1_X_SIZE1 :cross ADDR1,SIZE1;
	endgroup


		
  
    extern function new(string name = "router_scoreboard", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    extern task pkt_compare();
endclass

//----------------------------------------------------new function---------------------------------------------------------------------------------

	function router_scoreboard::new(string name = "router_scoreboard", uvm_component parent);
    		super.new(name, parent);
			router_fcov1 = new();
			router_fcov2 = new();	
	endfunction


//----------------------------------------------------function build phase---------------------------------------------------------------------------------

	function void router_scoreboard::build_phase(uvm_phase phase);
    		super.build_phase(phase);
		
		if(!uvm_config_db #(env_config)::get(this,"","env_config",envh))
			`uvm_fatal(get_type_name(),"getting of the envh is not possible")

		fifo_srch = new[envh.no_of_src_agents];
		fifo_dsth = new[envh.no_of_dst_agents];
		
		foreach(fifo_srch[i])
			fifo_srch[i] = new($sformatf("fifo_srch[%0d]",i),this);
		
		foreach(fifo_dsth[i])
			fifo_dsth[i] = new($sformatf("fifo_dsth[%0d]",i),this);
		
		
	endfunction

    
//----------------------------------------------------task run_phase---------------------------------------------------------------------------------

	task router_scoreboard::run_phase(uvm_phase phase);
    		//$display("from the router scoreboard");

		forever
		fork
			begin
				
				fifo_srch[0].get(s_xtn);
				$display("from the router scoreboard  begin end 1");
				`uvm_info(get_type_name(),"\nforever ---------- 1",UVM_LOW);
				s_xtn.print();	
				no_of_sxtn++;
				router_fcov1.sample();
			end

			
			begin
			fork
				begin
					fifo_dsth[0].get(d_xtn);
					$display("from the router scoreboard  begin end 2");
					`uvm_info(get_type_name(),"\nforever -----------2----0",UVM_LOW);
					d_xtn.print();
					no_of_dxtn++;
					router_fcov2.sample();
				end
				
				begin
					fifo_dsth[1].get(d_xtn);
					$display("from the router scoreboard  begin end 2");
					`uvm_info(get_type_name(),"\nforever -----------2----1",UVM_LOW);
					d_xtn.print();
					no_of_dxtn++;
					router_fcov2.sample();
				end
				
				begin
					fifo_dsth[2].get(d_xtn);
					$display("from the router scoreboard  begin end 2");
					`uvm_info(get_type_name(),"\nforever -----------2----2",UVM_LOW);
					d_xtn.print();
					no_of_dxtn++;
					router_fcov2.sample();
				end
			join_any
			disable fork;

			pkt_compare();
			//d_xtn.print();
			end
		join
	endtask


//----------------------------------------------------function report_phase------------------------------------------------------------------------------

	function void router_scoreboard::report_phase(uvm_phase phase);
    		super.report_phase(phase);
		`uvm_info(get_type_name(),$sformatf("\n the number of src_xtn %0d",no_of_sxtn),UVM_LOW)
		`uvm_info(get_type_name(),$sformatf("\n the number of dst_xtn %0d",no_of_dxtn),UVM_LOW)
		`uvm_info(get_type_name(),$sformatf("\n the number of packets compared %0d",no_of_cmp),UVM_LOW)
		if(no_of_sxtn == no_of_cmp) 
			`uvm_info(get_type_name(),"\nall the packets are verified and comparision passed",UVM_LOW)
	endfunction

//----------------------------------------------------task pkt_compare---------------------------------------------------------------------------------
	task router_scoreboard::pkt_compare();
		
		if(s_xtn.header != d_xtn.header)
			`uvm_error(get_type_name(),"error in comparing the header")
			
		else
			begin
				if(s_xtn.payload != d_xtn.payload)
					`uvm_error(get_type_name(),"error in comparing the payload") 
				
				if(s_xtn.parity != d_xtn.parity)
					`uvm_error(get_type_name(),"error in comparing the parity")
				else
					no_of_cmp++;
			end	
	endtask
	
			
					
