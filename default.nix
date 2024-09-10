{ pkgs ? import <nixpkgs> { } }:
let
  dndTemplate = pkgs.fetchFromGitHub {
    owner = "rpgtex";
    repo = "DND-5e-LaTeX-Template";
    rev = "2c94ab97952b8285bbbc932ccd507cbcd931ef82";
    sha256 = "sha256-dhtlEpof/wtIeWlQQF8O0m21B2da8tNKIc2u7RqQ/Lw="; # Replace with the correct hash
  };
in
pkgs.stdenv.mkDerivation {
  name = "md-to-dnd-template";

  src = ./.;

  nativeBuildInputs = [
    pkgs.pandoc
    pkgs.texlive.combined.scheme-full
  ];

  buildPhase = ''
    mkdir -p $out/texmf/tex/latex/dnd
    cp -r ${dndTemplate}/* $out/texmf/tex/latex/dnd
    export TEXINPUTS=$out/texmf/tex/latex/dnd:$TEXINPUTS
    pandoc $src/test.md -o $out/output.pdf --template=template.tex
  '';
}
