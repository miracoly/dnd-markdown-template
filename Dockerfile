ARG NIX_VERSION=2.21.4

FROM nixos/nix:${NIX_VERSION} AS builder

WORKDIR /build

COPY default.nix .
COPY template.tex .

# Enter nix shell to cache dependencies
RUN nix-shell

COPY test.md .

# Build the PDF
RUN nix-build

FROM scratch
COPY --from=builder /build/result/output.pdf /output.pdf
