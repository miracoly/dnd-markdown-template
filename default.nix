{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/f4c846aee8e1e29062aa8514d5e0ab270f4ec2f9.tar.gz") { }
, filePath ? ""
}:
let
  dndTemplate = pkgs.fetchFromGitHub {
    owner = "rpgtex";
    repo = "DND-5e-LaTeX-Template";
    rev = "2c94ab97952b8285bbbc932ccd507cbcd931ef82";
    sha256 = "sha256-dhtlEpof/wtIeWlQQF8O0m21B2da8tNKIc2u7RqQ/Lw="; # Replace with the correct hash
  };
  file = builtins.baseNameOf filePath;
in
pkgs.stdenv.mkDerivation {
  name = "md-to-dnd-template";

  src = ./.;

  nativeBuildInputs = with pkgs; [
    pandoc
    texlive.combined.scheme-full
  ];

  configurePhase = ''
    if [[ "${filePath}" == "" ]]; then
      echo "Error: No file specified" >&2
      exit 1
    fi
    if [[ "${filePath}" != *.md ]]; then
      echo "Error: The provided file is not a Markdown file (.md)" >&2
      exit 1
    fi

    cp ${filePath} ./${file}
  '';

  buildPhase = ''
    tmp_tex_dir=$(mktemp -d)
    cp -r ${dndTemplate}/* $tmp_tex_dir
    export TEXINPUTS=$tmp_tex_dir:$TEXINPUTS

    mkdir -p $out
    pandoc ./${file} \
      -o $out/output.pdf \
      --template=$src/template.tex \
      --lua-filter="$src/filter/paragraph.lua"
  '';
}
