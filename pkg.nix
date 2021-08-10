{ stdenv, texlive }:
let
  tex-env = texlive.combine {
    inherit (texlive) scheme-small latexmk beamer stmaryrd mathpartir rsfs
      cmll xcolor paralist makecell tikz-cd ncctools thmtools
      xifthen ifmtarg polytable etoolbox environ xkeyval
      lazylist trimspaces newunicodechar catchfilebetweentags catchfile
      multirow enumitem changepage draftwatermark everypage
      titling todonotes ebproof cleveref cm-super;
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
