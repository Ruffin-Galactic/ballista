# ---- Stage 1: Build Ballista binaries ----
FROM rust:1.75 as builder

# Install system dependencies
RUN apt-get update && apt-get install -y \
  protobuf-compiler \
  pkg-config \
  libssl-dev \
  curl \
  git \
  clang \
  cmake \
  build-essential

# Set up workdir and clone the datafusion repo
WORKDIR /app
RUN git clone https://github.com/apache/datafusion.git
WORKDIR /app/datafusion

# Set environment variables required for build
ENV RUSTFLAGS="-C target-cpu=native"

# Build the scheduler and executor
RUN cargo build --release --bin ballista-scheduler
RUN cargo build --release --bin ballista-executor

# ---- Stage 2: Runtime image ----
FROM debian:bullseye-slim

# Copy the built binaries
COPY --from=builder /app/datafusion/target/release/ballista-scheduler /usr/local/bin/
COPY --from=builder /app/datafusion/target/release/ballista-executor /usr/local/bin/

# Expose default gRPC port (optional)
EXPOSE 50050
EXPOSE 50051
