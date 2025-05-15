interface router_if(input bit clock);

//bit clk;
logic rstn,pkt_valid;
logic read_enb;
logic [7:0]data_in;
logic [7:0]dout;
logic vld_out;
logic err,busy;

//assign clk = clock;			// assign the tb clock to clk of DUT for synchronizing 


clocking src_drv_cb @(posedge clock);
	default input #1;// output #0;   // if any changes in input or output skew make the change 
	output data_in;
	output rstn;
	output pkt_valid;
	input busy;
	input err;
endclocking

clocking src_mon_cb @(posedge clock);
	default input #1;// output #1;
	input data_in;
	input pkt_valid;
	input busy;
	input err;
endclocking



clocking dst_drv_cb @(posedge clock);
	default input #1;// output #1;
	output read_enb;
	input vld_out;
endclocking

clocking dst_mon_cb @(posedge clock);
	default input #1;// output #1;
	input dout;
	input vld_out;
	input pkt_valid;
	input read_enb;
endclocking


modport SRC_DRV_MP (clocking src_drv_cb);
modport SRC_MON_MP (clocking src_mon_cb);

modport DST_DRV_MP (clocking dst_drv_cb);
modport DST_MON_MP (clocking dst_mon_cb);

endinterface
