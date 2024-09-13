
ARG NIX_VERSION=2.21.4

FROM nixos/nix:${NIX_VERSION} AS builder

ARG FILE

WORKDIR /build

COPY default.nix .
COPY template.tex .

# Enter nix shell to cache dependencies
RUN nix-shell

COPY ${FILE} /build/input.md

# Build the PDF
RUN FILE=/build/input.md nix-build

FROM scratch
COPY --from=builder /build/result/output.pdf /output.pdf
