SHELL := /bin/bash

TARGET = $(patsubst %.tex,%.test,$(wildcard */test.tex))

all: $(TARGET)
test: $(TARGET)

clean:
	rm -f */*.aux */*.blg */*.bbl */*.axp
	rm -f */*.fls */*.fdb* */*.log */*.out */*.fmt
	rm -f */test.pdf */test.test

%.pdf: %.tex ../apxproof.sty common.tex common.bib
	@cd $(dir $@) && latexmk -silent -c >/dev/null 2>/dev/null
	@cd $(dir $@) && latexmk -interaction=nonstopmode -silent -pdf test >/dev/null 2>/dev/null || (rm -fv test.pdf; false)

%.txt: %.pdf
	@pdftotext $<

%/test.test: %/reference.txt %/test.txt
	@echo -n "Testing $(dir $@)... "
	@./diffpdf.py $(dir $@)reference.pdf $(dir $@)test.pdf 0.01 || (echo ko; false)
	@diff -w $^ > $(dir $@)test.diff || (echo ko; cat $(dir $@)test.diff; rm $(dir $@)test.diff; false)
	@diff -w <(pdftk $(dir $@)reference.pdf dump_data_utf8|grep '^Bookmark') <(pdftk $(dir $@)test.pdf dump_data_utf8|grep '^Bookmark') > $(dir $@)test.diff || (echo ko; cat $(dir $@)test.diff; rm $(dir $@)test.diff; false)
	@rm $(dir $@)test.diff
	@echo ok | tee $@

%.fmt: %.tex ../apxproof.sty
	@cd $(dir $@) && pdflatex -ini '&pdflatex' $(notdir $<) '\dump' >/dev/null 2>/dev/null

preamble/test.pdf: preamble/test_preamble.fmt

../apxproof.sty: ../apxproof.ins ../apxproof.dtx
	make -C .. apxproof.sty

.PHONY: all test clean
