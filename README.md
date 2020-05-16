# Heroku Rust Cargo Action with MUSL Target
This action sets up `cargo` and the `x86_64-unknown-linux-musl` target for handling cross compiling builds on the Heroku stack.

## Inputs

### `command`

This is the `cargo` command to be run like `build` or `test`.

When using `build`, the flags `--release` and `--target x86_64-unknown-linux-musl` are set. After thebuild is done, the binaries will be stripped.

**Default** If not `command` input is given, it will default to `build`.

### `flags`

These are any additional flags to be passed to the `cargo <command>`.

## Outputs

### `release-dir`

If the `command` input is set to `build`, then this will be to te the target release directory.

## Example usage

To run tests with `cargo test`:

### GitHub Action Config
```
- uses: actions/checkout@v2
- uses: hone/heroku-rust-cargo-musl-action@v1
  with:
    command: test
```


To cross compile a rust binary that targets a 64-bit musl linux binary that vendors OpenSSL with a binary called `binary` the configuration will look like the following:

### `Cargo.toml`
```
[features]
# Force openssl-sys to staticly link in the openssl library. Necessary when
# cross compiling to x86_64-unknown-linux-musl.
vendored-openssl = ["openssl-sys/vendored"]
```

### GitHub Action Config
```
- uses: actions/checkout@v2
- id: 'compile'
  uses: hone/heroku-rust-cargo-musl-action@v1
  with:
    command: 'build'
    flags: '--features vendored-openssl'
- uses: actions/upload-artifact@v2
  with:
    name: binary
    path: ${{ steps.compile.outputs.release-dir }}/binary
```
