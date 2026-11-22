# =============================================================================
# Etapa 1: Compilación del Backend REST API en Rust (MASIRA - UDES)
# =============================================================================
FROM rust:slim-bookworm AS builder

RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/backend
COPY backend/Cargo.toml ./Cargo.toml
COPY backend/src ./src

RUN cargo build --release

# =============================================================================
# Etapa 2: Imagen ligera de ejecución
# =============================================================================
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /workspace/backend/target/release/masira-ctc-backend /app/masira-ctc-backend

ENV PORT=8080
EXPOSE 8080

CMD ["/app/masira-ctc-backend"]
