#!/bin/bash
set -e

echo "Building Muffin OS for RISC-V..."

# Add RISC-V target if not already installed
rustup target add riscv64gc-unknown-none-elf

# Build kernel for RISC-V
cd kernel
cargo build --target riscv64gc-unknown-none-elf --features riscv64_arch

echo "Build complete!"
echo "Kernel binary: target/riscv64gc-unknown-none-elf/debug/kernel"
