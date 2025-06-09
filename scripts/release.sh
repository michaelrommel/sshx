#!/bin/bash

# Manually releases the latest binaries to AWS S3.
#
# This runs on my M1 Macbook Pro with cross-compilation toolchains. I think it's
# probably better to replace this script with a CI configuration later.

set +e

# # x86_64: for most Linux servers
# TARGET_CC=x86_64-linux-musl-cc \
# 	CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=x86_64-linux-musl-gcc \
cargo build --release --target x86_64-unknown-linux-musl

# # aarch64: for newer Linux servers
# TARGET_CC=aarch64-linux-musl-cc \
# 	CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_LINKER=aarch64-linux-musl-gcc \
cargo build --release --target aarch64-unknown-linux-musl

# # armv6l: for devices like Raspberry Pi Zero W or version Pi 1
# TARGET_CC=arm-linux-musleabihf-cc \
# 	CARGO_TARGET_ARM_UNKNOWN_LINUX_MUSLEABIHF_LINKER=arm-linux-musleabihf-gcc \
cargo build --release --target arm-unknown-linux-musleabihf

# # armv7l: for devices like Oxdroid XU4
# TARGET_CC=armv7-unknown-linux-musleabihf-cc \
# 	CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER=armv7-unknown-linux-musleabihf-gcc \
cargo build --release --target armv7-unknown-linux-musleabihf

# x86_64-apple-darwin: for macOS on Intel
# MACOSX_DEPLOYMENT_TARGET=$(xcrun -sdk macosx15.2 --show-sdk-platform-version) \
SDKROOT=$(xcrun -sdk macosx14.2 --show-sdk-path) \
MACOSX_DEPLOYMENT_TARGET=14.2 \
	cargo build --release --target x86_64-apple-darwin

# # aarch64-apple-darwin: for macOS on Apple Silicon
cargo build --release --target aarch64-apple-darwin

temp=$(mktemp)
targets=(
	x86_64-unknown-linux-musl
	aarch64-unknown-linux-musl
	arm-unknown-linux-musleabihf
	armv7-unknown-linux-musleabihf
	x86_64-apple-darwin
	aarch64-apple-darwin
)

mkdir -p dist

for target in "${targets[@]}"; do
	echo "compress: target/$target/release/sshx"
	tar cz --no-xattrs -f $temp -C target/$target/release sshx
	cp $temp ./dist/sshx-$target.tar.gz

	echo "compress: target/$target/release/sshx-server"
	tar cz --no-xattrs -f $temp -C target/$target/release sshx-server
	cp $temp ./dist/sshx-server-$target.tar.gz
done

scp ./dist/sshx-[ax]* blog@crow-vpn:releases/shell/
