# install cargo chef & dioxus cli
FROM rust:1.83 AS chef
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    build-essential \
    curl \
    git
RUN cargo install cargo-chef
RUN cargo install dioxus-cli@0.6.1
WORKDIR /app

# copy in source files, cd into target create and prepare recipe
FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

# build stage
FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
#RUN cargo chef cook --release --recipe-path recipe.json --features server
#RUN cargo chef cook --release --recipe-path recipe.json --features web --target wasm32-unknown-unknown
#RUN dx build --platform web --release
#RUN ls dist -lh
COPY . .
RUN dx build --release --platform web

# runtime stage
FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt install -y openssl ca-certificates libssl-dev libstdc++6
WORKDIR /app

# Copy the `dist` directory and the built binary to /usr/local/bin/dist
#COPY --from=builder /app/dist /usr/local/bin/dist
COPY --from=builder /app/target/dx/exp/release/web ./

# # Make binary executable
# RUN chmod +x /usr/local/bin/dist/exp

# # Expose ports
# EXPOSE 8080
# EXPOSE 443
# EXPOSE 80

# # Set PORT
# ENV PORT=8080
# RUN ls /usr/local/bin/dist -lh

# ENTRYPOINT ["/usr/local/bin/dist/exp"]

ENV PORT=8080
ENV IP=0.0.0.0
# Expose the port your server listens on (adjust if necessary)
EXPOSE 8080

# Run the server
CMD ["./server"]