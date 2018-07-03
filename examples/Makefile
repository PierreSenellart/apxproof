TARGET = $(foreach dir, $(wildcard */), $(dir)test.pdf)

all: $(TARGET)

clean:
	rm -fv */*.aux */*.blg */*.bbl */*.axp */*.fls */*.fdb* */*.log */*.out */test.pdf

%.pdf: %.tex ../apxproof.sty common.tex common.bib
	cd $(dir $@) && \
	latexmk -c && \
	latexmk -pdf test ; \
	cd ..

amsmathlabel/test.pdf: amsmathlabel/test.tex ../apxproof.sty
	cd amsmathlabel && \
	latexmk -c && \
	latexmk -pdf -f -interaction=nonstopmode test ; \
	cd ..
