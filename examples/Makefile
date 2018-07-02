TARGET = $(foreach dir, $(wildcard */), $(dir)/test.pdf)

all: $(TARGET)

clean:
	rm */*.aux */*.blg */*.bbl */*.axp */*.fls */*.fdb* */*.log */*.out

%.pdf: %.tex ../apxproof.sty common.tex common.bib
	cd $(dir $@) && \
	latexmk -c && \
	latexmk -pdf test ; \
	cd ..
