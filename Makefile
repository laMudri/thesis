agda-dirs = agda generic-lr/src
find-lagda-modules = $(shell find $(1) -type f -name '*.lagda.tex')
agda-lagda-modules = $(call find-lagda-modules,agda)
generic-lr-lagda-modules = $(call find-lagda-modules,generic-lr/src)
#lagda-modules = $(agda-lagda-modules) $(generic-lr-lagda-modules)
lagda2tex-names = $(subst .lagda.tex,.tex,$(subst $(1)/,$(1)/latex/,$(2)))

lagda-outputs = $(call lagda2tex-names,agda,$(agda-lagda-modules)) $(call lagda2tex-names,generic-lr/src,$(generic-lr-lagda-modules))
lagda-processed-outputs = $(subst /latex/,/processed-latex/,$(lagda-outputs))

.PHONY: thesis cpp esop lagda

tex/thesis.pdf: tex/*.tex tex/quantitative.bib lagda
	cd tex; latexmk -pdf -halt-on-error thesis.tex
thesis: tex/thesis.pdf

tex/cpp21/quant-framework.pdf: tex/cpp21/*.tex tex/macros.tex tex/quantitative.bib lagda
	cd tex/cpp21; latexmk -pdf -halt-on-error quant-framework.tex
cpp: tex/cpp21/quant-framework.pdf

tex/esop22/quant-framework.pdf: tex/esop22/*.tex tex/macros.tex tex/quantitative.bib lagda
	cd tex/esop22; latexmk -pdf -halt-on-error quant-framework.tex
esop: tex/esop22/quant-framework.pdf

define lagda2tex
$(1)/processed-latex/%.tex: $(1)/latex/%.tex
	if [[ $$< =~ .*Simple.* ]]; then \
	  mkdir -p $$(dir $$@); \
	  sed \
	  -e 's/\\AgdaPrimitive{\(Set[₁₂]?\)}/\\AgdaPrimitiveType{\1}/g' \
	  -e 's/=⇒/⇛/g' \
	  -e 's/\\AgdaFunction{U}/\\AgdaFunction{⒈}/g' \
	  -e 's/`⊤/`⒈/g' \
	  -e 's/─✴/⇥/g' \
	  -e 's/\\AgdaFunction{\(\\AgdaUnderscore{}\)\?⇒\(\\AgdaUnderscore{}\)\?}/\\AgdaFunction{\1⇴\2}/g' \
	  -e 's/>>/\\ensuremath{\\rangle\\rangle}/g' \
	  -e 's/(|/\\ensuremath{\\mathbf\\llparenthesis}/g' \
	  -e 's/|)/\\ensuremath{\\mathbf\\rrparenthesis}/g' \
	  $$< >$$@; \
	else \
	  mkdir -p $$(dir $$@); \
	  sed \
	  -e 's/\\AgdaPrimitive{\(Set[₁₂]?\)}/\\AgdaPrimitiveType{\1}/g' \
	  -e 's/=⇒/⇛/g' \
	  -e 's/\\AgdaFunction{U}/\\AgdaFunction{⒈}/g' \
	  -e 's/`⊤/`⒈/g' \
	  -e 's/─✴/⇥/g' \
	  -e 's/\\AgdaFunction{\(\\AgdaUnderscore{}\)\?⇒\(\\AgdaUnderscore{}\)\?}/\\AgdaFunction{\1⇴\2}/g' \
	  -e 's/>>/\\ensuremath{\\rangle\\rangle}/g' \
	  -e 's/(|/\\ensuremath{\\mathbf\\llparenthesis}/g' \
	  -e 's/|)/\\ensuremath{\\mathbf\\rrparenthesis}/g' \
	  -e 's/∋/ヨ/g' \
	  $$< >$$@; \
	fi

$(1)/latex/%.tex: $(1)/%.lagda.tex
	cd $(1); agda --latex $$(subst $(1)/,,$$<)
endef
$(eval $(call lagda2tex,agda))
$(eval $(call lagda2tex,generic-lr/src))

lagda: $(lagda-processed-outputs)

.PHONY: clean
clean:
	rm -f $(lagda-outputs)
	rm -f $(lagda-processed-outputs)
	cd tex; latexmk -C
