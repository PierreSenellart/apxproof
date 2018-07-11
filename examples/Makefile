TARGET = $(patsubst %.tex,%.pdf,$(wildcard */test.tex))

all: $(TARGET)

clean:
	rm */*.aux */*.blg */*.bbl */*.axp */*.fls */*.fdb* */*.log */*.out */*.fmt

%.pdf: %.tex ../apxproof.sty common.tex common.bib
	cd $(dir $@) && \
	latexmk -c && \
	latexmk -pdf test || \
	rm -fv test.pdf ; \
	cd ..

%.fmt: %.tex
	cd $(dir $@) && pdflatex -ini '&pdflatex' $(notdir $<) '\\dump'

amsmathlabel/test.pdf: amsmathlabel/test.tex ../apxproof.sty
	cd amsmathlabel && \
	latexmk -c && \
	latexmk -pdf -f -interaction=nonstopmode test ; \
	cd ..

preamble/test.pdf : preamble/test_preamble.fmt

../apxproof.sty: ../apxproof.ins ../apxproof.dtx
	make -C ..
