# ---- Stage 1: Build Ballista binaries ----
FROM rust:1.75 as builder

# Install system dependencies
RUN apt-get update && apt-get install -y protobuf-compiler pkg-config libssl-dev git curl

# Create app directory and clone source
WORKDIR /app
RUN git clone --depth 1 https://github.com/apache/datafusion.git

# Build the scheduler and executor
WORKDIR /app/datafusion
RUN cargo build --release --bin ballista-scheduler
RUN cargo build --release --bin ballista-executor

# ---- Stage 2: Create minimal runtime image ----
FROM debian:bullseye-slim

# Copy binaries from builder
COPY --from=builder /app/datafusion/target/release/ballista-scheduler /usr/local/bin/ballista-scheduler
COPY --from=builder /app/datafusion/target/release/ballista-executor /usr/local/bin/ballista-executor


