class dst_sequence extends uvm_sequence #(dst_xtn);

	`uvm_object_utils(dst_sequence)	
	
	extern function new(string name = "dst_sequence");

endclass

//-----------------------------------------------------------function new--------------------------------------------------------------------------------
	function dst_sequence::new(string name ="dst_sequence");
		super.new(name);
	endfunction


//---------------------------------------------------------class low cycle---------------------------------------------------------------------------------

class low_cycle extends dst_sequence;

	`uvm_object_utils(low_cycle);

	extern function new(string name = "low_cycle");
	extern task body();
endclass

	function low_cycle::new(string name ="low_cycle");
		super.new(name);
	endfunction

	task low_cycle::body();

		//repeat(1)
		begin
		req = dst_xtn::type_id::create("req");	
		start_item(req);
												
		assert( req.randomize with {no_of_cycles inside{[1:15]};});

		finish_item(req);
		end
	endtask

//---------------------------------------------------------class high cycle-------------------------------------------------------------------------------



class high_cycle extends dst_sequence;

	`uvm_object_utils(high_cycle);

	extern function new(string name = "high_cycle");
	extern task body();
endclass

	function high_cycle::new(string name ="high_cycle");
		super.new(name);
	endfunction

	task high_cycle::body();

		
		begin
		req = dst_xtn::type_id::create("req");	
		start_item(req);
												
		assert( req.randomize with {no_of_cycles inside{[30:60]};});

		finish_item(req);
		end
	endtask
