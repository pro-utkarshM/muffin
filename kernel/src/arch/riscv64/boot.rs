/// Boot information passed from bootloader
pub struct BootInfo {
    pub hart_id: usize,
    pub dtb_addr: usize,
}

static mut BOOT_INFO: BootInfo = BootInfo {
    hart_id: 0,
    dtb_addr: 0,
};

/// Initialize boot information
pub unsafe fn init_boot_info(hart_id: usize, dtb_addr: usize) {
    BOOT_INFO.hart_id = hart_id;
    BOOT_INFO.dtb_addr = dtb_addr;
}

/// Get boot information
pub fn boot_info() -> &'static BootInfo {
    unsafe { &BOOT_INFO }
}

/// Early boot initialization (called from assembly)
#[no_mangle]
pub unsafe extern "C" fn _start(hart_id: usize, dtb_addr: usize) -> ! {
    // Initialize boot info
    init_boot_info(hart_id, dtb_addr);
    
    // Only boot hart 0
    if hart_id != 0 {
        loop {
            riscv::asm::wfi();
        }
    }
    
    // Clear BSS
    extern "C" {
        static mut __bss_start: u8;
        static mut __bss_end: u8;
    }
    
    let bss_start = &mut __bss_start as *mut u8;
    let bss_end = &mut __bss_end as *mut u8;
    let bss_size = bss_end as usize - bss_start as usize;
    
    core::ptr::write_bytes(bss_start, 0, bss_size);
    
    // Jump to kernel main
    extern "Rust" {
        fn kernel_main() -> !;
    }
    
    kernel_main()
}