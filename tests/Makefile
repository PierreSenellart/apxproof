TARGET = $(foreach dir, $(wildcard */), $(dir)/test.pdf)

all: $(TARGET)

%.pdf: %.tex ../apxproof.sty common.tex common.bib
	cd $(dir $@) && \
	latexmk -c && \
	latexmk test ; \
	cd ..
