class router_test extends uvm_test;
	
	`uvm_component_utils(router_test);

		src_agent_config src_agt_cfg[];
		dst_agent_config dst_agt_cfg[];
		
		router_env envh;
		env_config env_cfgh;	

		int no_of_src_agents = 1;
		int no_of_dst_agents = 3;
		
			
		extern function new(string name= "router_test",uvm_component parent);
		extern function void build_phase(uvm_phase phase);
		extern function void end_of_elaboration_phase(uvm_phase phase);
		
endclass	

		function router_test::new(string name ="router_test", uvm_component parent);
			super.new(name,parent);
		endfunction

		function void router_test::build_phase(uvm_phase phase);
			
			
			src_agt_cfg = new[this.no_of_src_agents];
			dst_agt_cfg = new[this.no_of_dst_agents];
			
			
			env_cfgh = env_config::type_id::create("env_cfgh");
			env_cfgh.src_agt_cfg = new[this.no_of_src_agents];
			env_cfgh.dst_agt_cfg = new[this.no_of_dst_agents];
			
			foreach(src_agt_cfg[i])
			begin 
				src_agt_cfg[i] = src_agent_config::type_id::create($sformatf("src_agt_cfg[%0d]",i));

				src_agt_cfg[i].is_active = UVM_ACTIVE;
				if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("src_if%0d",i),src_agt_cfg[i].vif))
					`uvm_fatal(get_type_name(),"getting the src_if from the src_agt_cfg is not possible")
				
				env_cfgh.src_agt_cfg[i] = src_agt_cfg[i];
			end

			foreach(dst_agt_cfg[i])
			begin 
				dst_agt_cfg[i] = dst_agent_config::type_id::create($sformatf("dst_agt_cfg[%0d]",i));

				dst_agt_cfg[i].is_active = UVM_ACTIVE;
				if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("dst_if%0d",i),dst_agt_cfg[i].vif))
					`uvm_fatal(get_type_name(),"getting the dst_if from the dst_agt_cfg is not possible")

				env_cfgh.dst_agt_cfg[i] = dst_agt_cfg[i];
			end

			env_cfgh.no_of_src_agents = this.no_of_src_agents;
			env_cfgh.no_of_dst_agents = this.no_of_dst_agents;
			
			uvm_config_db #(env_config)::set(this,"*","env_config",env_cfgh);

				super.build_phase(phase);
	
			envh = router_env::type_id::create("envh",this);

		endfunction

	function void router_test::end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology;
		
	endfunction
//-----------------------------------------------------------------------small-packet-test---------------------------------------------------------------//

class small_packet_test extends router_test;
	
	`uvm_component_utils(small_packet_test)
	bit [1:0]addr;
	small_vseq smp;
	
	
	extern function new(string name = "small_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function small_packet_test::new(string name = "small_packet",uvm_component parent);
		super.new(name,parent);
			
	endfunction
	
	function void small_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task small_packet_test::run_phase(uvm_phase phase);

		smp = small_vseq::type_id::create("smp");
		
		addr = $urandom%3;
		
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
		
		//`uvm_info(get_full_name(),("this is addr from test %0p",uvm_config_db),UVM_LOW);
		//repeat(2)
		phase.raise_objection(this);
			repeat(1)
			smp.start(envh.vseqrh);
			
			#100;
		phase.drop_objection(this);
		
	
	endtask
//----------------------------------------medium packet--------------------------------------------------------------------------------------------------- 

class medium_packet_test extends router_test;
	
	`uvm_component_utils(medium_packet_test)
	bit [1:0]addr;
	medium_vseq mmp;
	
	extern function new(string name = "medium_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function medium_packet_test::new(string name = "medium_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void medium_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task medium_packet_test::run_phase(uvm_phase phase);

		mmp = medium_vseq::type_id::create("mmp");

		addr = $urandom_range(0,2);
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			mmp.start(envh.vseqrh);
			
			#300;
		phase.drop_objection(this);
		
	
	endtask
//---------------------------------------------------big_packet_test--------------------------------------------------------------------------------------
class big_packet_test extends router_test;
	
	`uvm_component_utils(big_packet_test)
	bit [1:0]addr;
	big_vseq bmp;
	
	extern function new(string name = "big_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function big_packet_test::new(string name = "big_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void big_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task big_packet_test::run_phase(uvm_phase phase);

		bmp = big_vseq::type_id::create("bmp");
		
		addr = $urandom %3;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			bmp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//---------------------------------------------------test small_0--------------------------------------------------------------------------------------
class small0_packet_test extends router_test;
	
	`uvm_component_utils(small0_packet_test)
	bit [1:0]addr;
	small_vseq smp;
	
	extern function new(string name = "small0_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function small0_packet_test::new(string name = "small0_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void small0_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task small0_packet_test::run_phase(uvm_phase phase);

		smp = small_vseq::type_id::create("smp");
		
		addr = 0;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			smp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//---------------------------------------------------test small_1--------------------------------------------------------------------------------------
class small1_packet_test extends router_test;
	
	`uvm_component_utils(small1_packet_test)
	bit [1:0]addr;
	small_vseq smp;
	
	extern function new(string name = "small1_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function small1_packet_test::new(string name = "small1_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void small1_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task small1_packet_test::run_phase(uvm_phase phase);

		smp = small_vseq::type_id::create("smp");
		
		addr = 1;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			smp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//---------------------------------------------------test small_2--------------------------------------------------------------------------------------
class small2_packet_test extends router_test;
	
	`uvm_component_utils(small2_packet_test)
	bit [1:0]addr;
	small_vseq smp;
	
	extern function new(string name = "small2_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function small2_packet_test::new(string name = "small2_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void small2_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task small2_packet_test::run_phase(uvm_phase phase);

		smp = small_vseq::type_id::create("smp");
		
		addr = 2;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			smp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask

//------------
//---------------------------------------------------test medium_0--------------------------------------------------------------------------------------
class medium0_packet_test extends router_test;
	
	`uvm_component_utils(medium0_packet_test)
	bit [1:0]addr;
	medium_vseq mmp;
	
	extern function new(string name = "medium0_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function medium0_packet_test::new(string name = "medium0_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void medium0_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task medium0_packet_test::run_phase(uvm_phase phase);

		mmp = medium_vseq::type_id::create("mmp");
		
		addr = 0;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			mmp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//---------------------------------------------------test medium_1--------------------------------------------------------------------------------------
class medium1_packet_test extends router_test;
	
	`uvm_component_utils(medium1_packet_test)
	bit [1:0]addr;
	medium_vseq mmp;
	
	extern function new(string name = "medium1_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function medium1_packet_test::new(string name = "medium1_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void medium1_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task medium1_packet_test::run_phase(uvm_phase phase);

		mmp = medium_vseq::type_id::create("mmp");
		
		addr = 1;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			mmp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//---------------------------------------------------test medium_2--------------------------------------------------------------------------------------
class medium2_packet_test extends router_test;
	
	`uvm_component_utils(medium2_packet_test)
	bit [1:0]addr;
	medium_vseq mmp;
	
	extern function new(string name = "medium2_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function medium2_packet_test::new(string name = "medium2_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void medium2_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task medium2_packet_test::run_phase(uvm_phase phase);

		mmp = medium_vseq::type_id::create("mmp");
		
		addr = 2;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			mmp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//-------------
//---------------------------------------------------test big_0--------------------------------------------------------------------------------------
class big0_packet_test extends router_test;
	
	`uvm_component_utils(big0_packet_test)
	bit [1:0]addr;
	big_vseq bmp;
	
	extern function new(string name = "big0_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function big0_packet_test::new(string name = "big0_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void big0_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task big0_packet_test::run_phase(uvm_phase phase);

		bmp = big_vseq::type_id::create("bmp");
		
		addr = 0;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			bmp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//---------------------------------------------------test big_1--------------------------------------------------------------------------------------
class big1_packet_test extends router_test;
	
	`uvm_component_utils(big1_packet_test)
	bit [1:0]addr;
	big_vseq bmp;
	
	extern function new(string name = "big1_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function big1_packet_test::new(string name = "big1_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void big1_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task big1_packet_test::run_phase(uvm_phase phase);

		bmp = big_vseq::type_id::create("bmp");
		
		addr = 1;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			bmp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//---------------------------------------------------test big_2--------------------------------------------------------------------------------------
class big2_packet_test extends router_test;
	
	`uvm_component_utils(big2_packet_test)
	bit [1:0]addr;
	big_vseq bmp;
	
	extern function new(string name = "big2_packet",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function big2_packet_test::new(string name = "big2_packet",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void big2_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task big2_packet_test::run_phase(uvm_phase phase);

		bmp = big_vseq::type_id::create("bmp");
		
		addr = 2;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			bmp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//-------------
//---------------------------------------------------test big_2--------------------------------------------------------------------------------------
class error_packet_test extends router_test;
	
	`uvm_component_utils(error_packet_test)
	bit [1:0]addr;
	error_vseq emp;
	
	extern function new(string name = "error_packet_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function error_packet_test::new(string name = "error_packet_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void error_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task error_packet_test::run_phase(uvm_phase phase);

		emp = error_vseq::type_id::create("emp");
		
		addr = 2;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			emp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask
//---------------------------------------------------test big_2--------------------------------------------------------------------------------------
/*class high_cycle_packet_test extends router_test;
	
	`uvm_component_utils(high_cycle_packet_test)
	bit [1:0]addr;
	high_vseq hmp;
	
	extern function new(string name = "high_cycle_packet_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


	function high_cycle_packet_test::new(string name = "high_cycle_packet_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void high_cycle_packet_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task high_cycle_packet_test::run_phase(uvm_phase phase);

		hmp = high_vseq::type_id::create("hmp");
		
		addr = 2;
			
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
			repeat(1)
			hmp.start(envh.vseqrh);
			#300;
		phase.drop_objection(this);
		
	
	endtask*/

