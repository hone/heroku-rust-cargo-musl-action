#!/bin/bash

set -e

echo "Compiling with flags: $1"
# split flags string into args
read -r -a args <<< "$1"
cargo build --target x86_64-unknown-linux-musl --release "${args[@]}"

release_dir="target/x86_64-unknown-linux-musl/release/"
pushd $release_dir || { echo "Could not find directory: $release_dir"; exit 1; }
for i in *
do
  if file "$i" | grep "ELF 64-bit LSB executable" > /dev/null; then
    strip "$i"
    echo "Stripping $i"
  fi
done
popd || exit
echo "::set-output name=release-dir::$release_dir"
