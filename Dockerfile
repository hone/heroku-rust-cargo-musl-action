FROM heroku/heroku:18-build

RUN apt update && apt install -y musl-tools && rm -rf /var/lib/apt/lists/*
ENV RUSTUP_HOME=/rust
ENV CARGO_HOME=/cargo
ENV PATH=/cargo/bin:/rust/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal
RUN rustup target add x86_64-unknown-linux-musl
COPY entrypoint.sh /entrypoint.sh
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
ENTRYPOINT ["/entrypoint.sh"]
