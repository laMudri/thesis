{ stdenv, texlive, ghostscript, nix-gitignore, agda }:
let
  tex-env = texlive.combine {
    inherit (texlive) scheme-small latexmk beamer stmaryrd mathpartir rsfs
      cmll xcolor paralist makecell tikz-cd ncctools thmtools mleftright
      xifthen ifmtarg polytable etoolbox environ xkeyval
      lazylist trimspaces newunicodechar catchfilebetweentags catchfile
      multirow enumitem changepage draftwatermark everypage
      titling todonotes ebproof cleveref cm-super turnstile
      acmart xstring totpages hyperxmp comment preprint
      collection-fontsrecommended collection-fontsextra epstopdf
      tikzmark biblatex biber;
  };
in stdenv.mkDerivation {
  name = "thesis";
  src = nix-gitignore.gitignoreSource [] ./.;
  buildInputs = [ tex-env ghostscript
                  (agda.withPackages (ps: [ ps.standard-library ]))
		];
  buildPhase = ''
    latexmk tex/thesis.tex
  '';
  installPhase = "";
}
