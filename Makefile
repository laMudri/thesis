agda-dirs = agda generic-lr/src
find-lagda-modules = $(shell find $(1) -type f -name '*.lagda.tex')
agda-lagda-modules = $(call find-lagda-modules,agda)
generic-lr-lagda-modules = $(call find-lagda-modules,generic-lr/src)
#lagda-modules = $(agda-lagda-modules) $(generic-lr-lagda-modules)
lagda2tex-names = $(subst .lagda.tex,.tex,$(subst $(1)/,$(1)/latex/,$(2)))

lagda-outputs = $(call lagda2tex-names,agda,$(agda-lagda-modules)) $(call lagda2tex-names,generic-lr/src,$(generic-lr-lagda-modules))
lagda-processed-outputs = $(subst /latex/,/processed-latex/,$(lagda-outputs))

.PHONY: thesis cpp lagda

tex/thesis.pdf: tex/*.tex tex/quantitative.bib lagda
	cd tex; latexmk -pdf -halt-on-error thesis.tex
thesis: tex/thesis.pdf

tex/cpp21/quant-framework.pdf: tex/cpp21/*.tex tex/macros.tex tex/quantitative.bib lagda
	cd tex/cpp21; latexmk -pdf -halt-on-error quant-framework.tex
cpp: tex/cpp21/quant-framework.pdf

define lagda2tex
$(1)/processed-latex/%.tex: $(1)/latex/%.tex
	mkdir -p $$(dir $$@)
	sed \
	-e 's/=⇒/⇛/g' \
	-e 's/\\AgdaFunction{U}/\\AgdaFunction{⒈}/g' \
	-e 's/`⊤/`⒈/g' \
	-e 's/─✴/⇥/g' \
	-e 's/\\AgdaFunction{⇒}/\\AgdaFunction{⇴}/g' \
	$$< >$$@

$(1)/latex/%.tex: $(1)/%.lagda.tex
	cd $(1); agda --latex $$(subst $(1)/,,$$<)
endef
$(eval $(call lagda2tex,agda))
$(eval $(call lagda2tex,generic-lr/src))

lagda: $(lagda-processed-outputs)

.PHONY: clean
clean:
	rm $(lagda-outputs)
	rm $(lagda-processed-outputs)
	cd tex; latexmk -C
