class dst_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(dst_xtn)
	
	bit [7:0]header;
	bit [7:0]payload[];
	bit [7:0]parity;
	rand bit[6:0] no_of_cycles;

	extern function new(string name = "dst_xtn");
	extern function void do_print(uvm_printer printer);

endclass
	
//-----------------------------------------------------------function new-------------------------------------------------------------------------------------
	function dst_xtn::new(string name = "dst_xtn");
		super.new(name);	
	endfunction

//-----------------------------------------------------------function do_print-------------------------------------------------------------------------------------
	function void  dst_xtn::do_print (uvm_printer printer);
		super.do_print(printer);
		//printer.print_field("Address -- Header[1:0] ", this.header[1:0] , 2 , UVM_DEC );
		//printer.print_field("Payload+length -- Header[7:2] ", this.header[7:2] , 6 , UVM_DEC );
		printer.print_field("Header", this.header , 8 , UVM_BIN );
		
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i) , this.payload[i] , 8 , UVM_DEC);
		
		printer.print_field("Parity", this.parity , 8 , UVM_DEC );
		printer.print_field("No of Cycles", this.no_of_cycles , 6 , UVM_DEC );
		
	endfunction


