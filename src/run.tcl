set project game
set top_module game_top_module
set target xc7a35tcpg236-1
set bitstream_file ../vivado/build/${project}.runs/impl_1/${top_module}.bit

# Print how to use the script
proc usage {} {
puts "===========================================================================\n
usage: vivado -mode tcl -source [info script] -tclargs \[open/rebuild/sim/bit/prog\]\n
\topen    - open project and start gui\n
\trebuild - clear build directory and create the project again from sources, then open gui\n
\tsim     - run simulation\n
\tbit     - generate bitstream\n
\tprog    - load bitstream to FPGA\n
If a project is already created in the build directory, run.tcl opens it. Otherwise, creates a new one.
==========================================================================="
}

# Create project
proc create_new_project {project target top_module} {
    file mkdir ../vivado/build
    create_project ${project} ../vivado/build -part ${target} -force
    
read_xdc {
    constraints/game_top_module.xdc
    constraints/clk_wiz_1.xdc
    constraints/clk_wiz_1_late.xdc
    constraints/clk_wiz_1_ooc.xdc
}

read_verilog {
    rtl/clk_wiz_1.v
    rtl/clk_wiz_1_clk_wiz.v
    rtl/rst_d.v

    rtl/game_top_module.v
    rtl/vga_timing.v

    rtl/draw_background.v
    rtl/draw_rect.v
    rtl/draw_rect_char.v
    rtl/image_rom.v

    rtl/sync_delay.v
    rtl/sync_after_image.v
    
    rtl/image_rom.v
    rtl/font_rom.v
    rtl/char_rom_play.v
    rtl/char_rom_wait.v
    rtl/char_rom_score.v

    rtl/click_ctl.v
    rtl/click_image_ctl.v
    rtl/MouseCtl_buf.v

    rtl/state_machine.v
    rtl/game_timer.v
    rtl/ran_num_gen.v
    rtl/score_counter.v
    rtl/score2ascii_converter.v
    rtl/compare_score.v
	
	rtl/fifo.v
	rtl/mod_m_counter.v
	rtl/uart.v 
	rtl/uart_interface.v 
	rtl/uart_rx.v 
	rtl/uart_top.v 
	rtl/uart_tx.v 
	
}

read_vhdl {
    rtl/MouseCtl.vhd
    rtl/MouseDisplay.vhd
    rtl/Ps2Interface.vhd
}
add_files -fileset sim_1 {
    sim/testbench.v
    sim/tiff_writer.v
}

    set_property top ${top_module} [current_fileset]
    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1
}

# Open existing project
proc open_existing_project {project} {
    open_project ../vivado/build/$project.xpr
    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1
}

# If project already exists, open it. Otherwise, create it.
proc open_or_create_project {project target top_module} {
    if {[file exists ../vivado/build/$project.xpr] == 1} {
        open_existing_project $project 
    } else {
        create_new_project $project $target $top_module
    }
}


# Load bitstream to FPGA
proc program_fpga {bitstream_file} {
    if {[file exists $bitstream_file] == 0} {
        puts "ERROR: No bitstream found"
    } else {
        open_hw_manager
        connect_hw_server
        current_hw_target [get_hw_targets *]
        open_hw_target
        current_hw_device [lindex [get_hw_devices] 0]
        refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]

        set_property PROBES.FILE {} [lindex [get_hw_devices] 0]
        set_property FULL_PROBES.FILE {} [lindex [get_hw_devices] 0]
        set_property PROGRAM.FILE ${bitstream_file} [lindex [get_hw_devices] 0]

        program_hw_devices [lindex [get_hw_devices] 0]
        refresh_hw_device [lindex [get_hw_devices] 0]
    }
}

# Simulation
proc simulation {} {
    launch_simulation
    # run all
}

# Generate bitstream
proc bitstream {} {
    # Run synthesis
    reset_run synth_1
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1
    
    # Run implemenatation up to bitstream generation
    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1
}

## MAIN
if {$argc == 1} {
    switch $argv {
        open {
            open_or_create_project $project $target $top_module    
            start_gui
        }
        rebuild {
            create_new_project $project $target $top_module    
            start_gui
        }
        sim {
            open_or_create_project $project $target $top_module    
            simulation
            start_gui
        }
        bit {
            open_or_create_project $project $target $top_module    
            bitstream
            exit
        }
        prog {
            program_fpga $bitstream_file
            exit
        }
        default {
            usage
            exit 1
        }
    }
} else {
    usage
    exit 1
}
