class src_sequence extends uvm_sequence #(src_xtn);

	`uvm_object_utils(src_sequence)	
	
	extern function new(string name = "src_sequence");

endclass
	function src_sequence::new(string name = "src_sequence");
		super.new(name);
	endfunction

//--------------------------------------------------------small_packet---------------------------------------------------------------------------------


class small_packet extends src_sequence;

	`uvm_object_utils(small_packet)
	bit [1:0] addr;
	extern function new(string name = "small_packet");
	extern task body();
	
endclass

	function small_packet::new(string name = "small_packet");
		super.new(name);
	endfunction
	
	task small_packet::body();
		
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal(get_type_name(),"getting the addr form the uvm_config_db did you set ")
	
		//`uvm_info(get_full_name(),$sformatf("after get %0d",addr),UVM_LOW);	

		//repeat(1)
		begin
		req = src_xtn::type_id::create("req");	
		start_item(req);
												
		assert( req.randomize with {header[7:2] inside{[0:15]}; header[1:0] == addr;});

		finish_item(req);
		
		end
	endtask

//--------------------------------------------------------medium_packet---------------------------------------------------------------------------------
class medium_packet extends src_sequence;

	`uvm_object_utils(medium_packet)	
	bit [1:0]addr;
	extern function new(string name = "medium_packet");
	extern task body();
	
endclass

	function medium_packet::new(string name = "medium_packet");
		super.new(name);
	endfunction
	
	task medium_packet::body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal(get_type_name(),"getting the addr form the uvm_config_db did you set ")

		//repeat(1)
		begin

			req = src_xtn::type_id::create("req"); 
			start_item(req);

			assert( req.randomize with {header[7:2] inside{[16:30]}; header[1:0] == addr;});
			finish_item(req);
		end
	endtask

//--------------------------------------------------------big_packet---------------------------------------------------------------------------------


class big_packet extends src_sequence;

	`uvm_object_utils(big_packet)	
	bit [1:0]addr;
	extern function new(string name = "big_packet");
	extern task body();
	
endclass

	function big_packet::new(string name = "big_packet");
		super.new(name);
	endfunction
	
	task big_packet::body();
			if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
				`uvm_fatal(get_type_name(),"getting the addr form the uvm_config_db did you set ")

		//repeat(1)
		begin

			req = src_xtn::type_id::create("req"); 
			start_item(req);
			assert( req.randomize with {header[7:2] inside{[30:64]}; header[1:0] == addr;});
			finish_item(req);
		end
	endtask

//----------------------------------------------------------error packet-----------------------------------------------------------------------------
class error_packet extends src_sequence;

	`uvm_object_utils(error_packet)	
	bit [1:0]addr;
	extern function new(string name = "big_packet");
	extern task body();
	
endclass

	function error_packet::new(string name = "big_packet");
		super.new(name);
	endfunction
	
	task error_packet::body();
			if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
				`uvm_fatal(get_type_name(),"getting the addr form the uvm_config_db did you set ")

		//repeat(1)
		begin

			req = src_xtn::type_id::create("req"); 
			start_item(req);
			assert( req.randomize with {header[7:2] inside{[30:64]}; header[1:0] == addr;});
			req.parity = $urandom;
			finish_item(req);
		end
	endtask
