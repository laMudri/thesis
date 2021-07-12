agda-dirs = agda generic-lr/src
find-lagda-modules = $(shell find $(1) -type f -name '*.lagda.tex')
agda-lagda-modules = $(call find-lagda-modules,agda)
generic-lr-lagda-modules = $(call find-lagda-modules,generic-lr/src)
#lagda-modules = $(agda-lagda-modules) $(generic-lr-lagda-modules)
lagda2tex-names = $(subst .lagda.tex,.tex,$(subst $(1)/,$(1)/latex/,$(2)))

lagda-outputs = $(call lagda2tex-names,agda,$(agda-lagda-modules)) $(call lagda2tex-names,generic-lr/src,$(generic-lr-lagda-modules))

tex/thesis.pdf: tex/*.tex $(lagda-outputs)
	cd tex; latexmk -halt-on-error thesis.tex

define lagda2tex
$(call lagda2tex-names,$(1),$(2)): $(2)
	cd $(1); agda --latex $(subst $(1)/,,$(2))
endef
$(foreach f,$(agda-lagda-modules),$(eval $(call lagda2tex,agda,$(f))))
$(foreach f,$(generic-lr-lagda-modules),$(eval $(call lagda2tex,generic-lr/src,$(f))))

.PHONY: clean
clean:
	rm $(lagda-outputs)
	cd tex; latexmk -C
