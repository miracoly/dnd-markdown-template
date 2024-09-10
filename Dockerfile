FROM nixos/nix:2.21.4 AS builder

COPY default.nix /default.nix
COPY template.tex /template.tex
COPY test.md /test.md

RUN nix-channel --update
RUN nix-build --argstr src /