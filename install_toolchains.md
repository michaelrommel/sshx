# Installing necessary toolchains

## `rustup` target config

```
// rustup target add x86_64-unknown-linux-musl
// rustup target add aarch64-unknown-linux-musl
// rustup target add arm-unknown-linux-musleabihf
// rustup target add armv7-unknown-linux-musleabihf

rustup target add x86_64-unknown-linux-gnu
rustup target add aarch64-unknown-linux-gnu
rustup target add arm-unknown-linux-gnueabihf
rustup target add armv7-unknown-linux-gnueabihf
rustup target add i686-unknown-linux-gnu

rustup target add x86_64-apple-darwin

rustup target add x86_64-pc-windows-msvc
rustup target add i686-pc-windows-msvc
rustup target add aarch64-pc-windows-msvc
```

## homebrew compilers & linkers

### Option 1:

```
brew install filosottile/musl-cross/musl-cross --with-arm-hf --with-arm
```

This misses the specific armv7 compiler.


### Option 2:

```
brew tap messense/macos-cross-toolchains
brew install armv7-unknown-linux-musleabihf
```



## Process

- do a `cargo clean` first
- the scripts/release.sh shell script sets the compiler and linker as
  environment variables. It might be better to set this in the
  .cargo/config file.

```
[target.armv7-unknown-linux-musleabihf]
linker = "armv7-unknown-linux-musleabihf-ld"
ar = "armv7-unknown-linux-musleabihf-ar"
```

- run the `./scripts/release.sh` shell script
- copy the resulting dist files to the webserver in /releases
