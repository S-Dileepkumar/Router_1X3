class virtual_sequence extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(virtual_sequence)
    
    env_config                  m_cfg;
    virtual_sequencer           vseqrh;
    src_agent_sequencer      	s_agt_seqrh[];
    dst_agent_sequencer 	d_agt_seqrh[];
    bit [1:0]addr;

    small_packet 		s_pkt;
    medium_packet 		m_pkt;
    big_packet 			b_pkt;
    error_packet		e_pkt;

    low_cycle			low_pkt;
    high_cycle			high_pkt;

    extern function new(string name = "virtual_sequence");
    extern task body();
endclass    
    
        function virtual_sequence::new(string name = "virtual_sequence");
            super.new(name);
        endfunction

        task virtual_sequence::body();
                if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config", m_cfg))
                    `uvm_fatal(get_type_name(), "Cannot get() m_cfg from uvm_config_db. Have you set() it?")
                
                s_agt_seqrh = new[m_cfg.no_of_src_agents];
                d_agt_seqrh = new[m_cfg.no_of_dst_agents];

                assert($cast(vseqrh,m_sequencer)) 
                else 
                    begin
    		        `uvm_error("BODY", "Error in $cast of virtual sequencer")
                    end
               
                foreach (s_agt_seqrh[i])
                begin
                    s_agt_seqrh[i] = vseqrh.s_agt_seqrh[i];
                end

                foreach (d_agt_seqrh[i])    
                begin
                    d_agt_seqrh[i] = vseqrh.d_agt_seqrh[i];  
                end
	
	  if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr", addr))
                    `uvm_fatal(get_type_name(), "Cannot get() addr from uvm_config_db. Have you set() it?")


        endtask

//---------------------------------------------------small virtual sequence-------------------------------------------------------------------------

class small_vseq extends virtual_sequence;
	`uvm_object_utils(small_vseq)

 	extern function new(string name = "small_vseq");
	extern task body();
endclass : small_vseq
  
function small_vseq::new(string name = "small_vseq");
	super.new(name);
endfunction

task small_vseq::body();
	super.body();	
	s_pkt = small_packet::type_id::create("s_pkt");
	low_pkt = low_cycle::type_id::create("low_pkt");
	high_pkt = high_cycle::type_id::create("high_pkt");  //----------------------higher cycle rate

 	
	if(m_cfg.has_src_agt_top) 
			begin
                   		for (int i=0 ; i < m_cfg.no_of_src_agents; i++)
           				fork
							s_pkt.start(s_agt_seqrh[i]);
							low_pkt.start(d_agt_seqrh[addr]);
						//	high_pkt.start(d_agt_seqrh[addr]);
					join
	
            end


endtask

//---------------------------------------------------medium virtual sequence-------------------------------------------------------------------------

class medium_vseq extends virtual_sequence;
	`uvm_object_utils(medium_vseq)

 	extern function new(string name = "medium_vseq");
	extern task body();
endclass : medium_vseq
  
function medium_vseq::new(string name = "medium_vseq");
	super.new(name);
endfunction

task medium_vseq::body();
	super.body();	
	
	m_pkt = medium_packet::type_id::create("m_pkt");
	low_pkt = low_cycle::type_id::create("low_pkt");
	high_pkt = high_cycle::type_id::create("high_pkt");  //----------------------higher cycle rate
	
	if(m_cfg.has_src_agt_top) 
			begin
                   		for (int i=0 ; i < m_cfg.no_of_src_agents; i++)
						fork
							m_pkt.start(s_agt_seqrh[i]);
							low_pkt.start(d_agt_seqrh[addr]);
						join
				//	high_pkt.start(d_agt_seqrh[addr]);
                   	end


endtask

//---------------------------------------------------big virtual sequence-------------------------------------------------------------------------

class big_vseq extends virtual_sequence;
	`uvm_object_utils(big_vseq)

 	extern function new(string name = "big_vseq");
	extern task body();
endclass : big_vseq
  
function big_vseq::new(string name = "big_vseq");
	super.new(name);
endfunction

task big_vseq::body();
	super.body();	
	
	b_pkt = big_packet::type_id::create("b_pkt");
	low_pkt = low_cycle::type_id::create("low_pkt");
	high_pkt = high_cycle::type_id::create("high_pkt");  //----------------------higher cycle rate
	
	if(m_cfg.has_src_agt_top) 
			begin
                   		for (int i=0 ; i < m_cfg.no_of_src_agents; i++)
           				fork	
					b_pkt.start(s_agt_seqrh[i]);
					
					low_pkt.start(d_agt_seqrh[addr]);
				//	high_pkt.start(d_agt_seqrh[addr]);
					join
                   	end


endtask
//---------------------------------------------------error virtual sequence-------------------------------------------------------------------------

class error_vseq extends virtual_sequence;
	`uvm_object_utils(error_vseq)

 	extern function new(string name = "error_vseq");
	extern task body();
endclass : error_vseq
  
function error_vseq::new(string name = "error_vseq");
	super.new(name);
endfunction

task error_vseq::body();
	super.body();	
	
	e_pkt = error_packet::type_id::create("e_pkt");
	low_pkt = low_cycle::type_id::create("low_pkt");
	high_pkt = high_cycle::type_id::create("high_pkt");//--
	
	if(m_cfg.has_src_agt_top) 
			begin
                   		for (int i=0 ; i < m_cfg.no_of_src_agents; i++)
           				fork	
					e_pkt.start(s_agt_seqrh[i]);
					
					low_pkt.start(d_agt_seqrh[addr]);
				//	high_pkt.start(d_agt_seqrh[addr]);
					join
                   	end


endtask
//---------------------------------------------------high_cycle virtual sequence-------------------------------------------------------------------------

/*class high_vseq extends virtual_sequence;
	`uvm_object_utils(high_vseq)

 	extern function new(string name = "high_vseq");
	extern task body();
endclass : high_vseq
  
function high_vseq::new(string name = "high_vseq");
	super.new(name);
endfunction

task high_vseq::body();
	super.body();	
	s_pkt = small_packet::type_id::create("s_pkt");
	low_pkt = low_cycle::type_id::create("low_pkt");
	high_pkt = high_cycle::type_id::create("high_pkt");  //----------------------higher cycle rate

 	
	if(m_cfg.has_src_agt_top) 
			begin
                   		for (int i=0 ; i < m_cfg.no_of_src_agents; i++)
           				fork
							s_pkt.start(s_agt_seqrh[i]);
						//	low_pkt.start(d_agt_seqrh[addr]);
							high_pkt.start(d_agt_seqrh[addr]);
					join
	
            end


endtask*/


