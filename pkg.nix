{ stdenv, texlive }:
let
  tex-env = texlive.combine {
    inherit (texlive) scheme-small latexmk beamer stmaryrd mathpartir rsfs
                      cmll xcolor paralist makecell tikz-cd ncctools thmtools
                      xifthen ifmtarg polytable etoolbox environ xkeyval
                      lazylist trimspaces
                      multirow enumitem changepage draftwatermark everypage
                      titling;
  };
in stdenv.mkDerivation {
  name = "thesis";
  src = ./.;
  buildInputs = [ tex-env ];
  buildPhase = ''
    latexmk tex/thesis.tex
  '';
  installPhase = "";
}
