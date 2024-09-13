ARG NIX_VERSION=2.21.4

FROM nixos/nix:${NIX_VERSION} AS builder

ARG FILE

WORKDIR /build

COPY default.nix .

# Enter nix shell to cache dependencies
RUN nix-shell

COPY template.tex .
COPY ${FILE} /build/input.md

# Build the PDF
RUN nix-build --arg filePath "/build/input.md"

FROM scratch
COPY --from=builder /build/result/output.pdf /output.pdf
