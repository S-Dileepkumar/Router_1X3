class src_xtn extends uvm_sequence_item; 
	
	`uvm_object_utils(src_xtn)
	
	rand bit [7:0]header;
	rand bit [7:0]payload[];
	     bit [7:0]parity;
	     bit error;
	constraint valid_addr{ header[1:0] != 2'b11; }
	constraint valid_lenght{ header[7:2] inside{[1:63]};
				 header[7:2] != 0; 
				 payload.size == header[7:2]; }

	extern function new(string name = "src_xtn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();


endclass
	
//-------------------------------------------------------new function--------------------------------------------------------------------------------
	function src_xtn::new(string name ="src_xtn");
		super.new(name);
	endfunction



//-------------------------------------------------------do_print function--------------------------------------------------------------------------------
	
	function void  src_xtn::do_print (uvm_printer printer);
    		super.do_print(printer);

		//printer.print_field("Header", this.header , 2 , UVM_DEC );
		//printer.print_field("Payload+length -- Header[7:2] ", this.header[7:2] , 6 , UVM_DEC );
		printer.print_field("Header", this.header , 8 , UVM_BIN );
		
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i) , this.payload[i] , 8 , UVM_DEC);
		
		printer.print_field("Parity", this.parity , 8 , UVM_DEC );
		printer.print_field("Error", this.error , 1 , UVM_DEC );
	endfunction



//-------------------------------------------------------post_randomize function--------------------------------------------------------------------------

	function void src_xtn::post_randomize();
		parity = header;
			foreach(payload[i])
				parity = parity^payload[i];
		endfunction

