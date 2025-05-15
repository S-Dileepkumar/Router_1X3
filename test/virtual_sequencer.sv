class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

    `uvm_component_utils(virtual_sequencer)
    
    src_agent_sequencer s_agt_seqrh[];
    dst_agent_sequencer d_agt_seqrh[];
    
    env_config m_cfg;

    extern function new(string name = "virtual_sequencer", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
endclass

  
    function virtual_sequencer::new(string name ="virtual_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    
    function void virtual_sequencer::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(env_config)::get(this,"","env_config", m_cfg))
            `uvm_fatal(get_type_name(), "Cannot get() m_cfg from uvm_config_db. Have you set() it?")
        
        s_agt_seqrh = new[m_cfg.no_of_src_agents];
        d_agt_seqrh = new[m_cfg.no_of_dst_agents];
    endfunction
