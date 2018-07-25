TARGET = $(patsubst %.tex,%.pdf,$(wildcard */test.tex))

all: $(TARGET)

clean:
	rm -f */*.aux */*.blg */*.bbl */*.axp */*.fls */*.fdb* */*.log */*.out */*.fmt

%.pdf: %.tex ../apxproof.sty common.tex common.bib
	@echo ''
	cd $(dir $@) && latexmk -c
	cd $(dir $@) && latexmk -pdf test || (rm -fv test.pdf; false)

%.fmt: %.tex
	cd $(dir $@) && pdflatex -ini '&pdflatex' $(notdir $<) '\dump'

preamble/test.pdf: preamble/test_preamble.fmt

../apxproof.sty: ../apxproof.ins ../apxproof.dtx
	make -C ..
