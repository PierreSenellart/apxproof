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

%/test.test: %/reference.pdf %/test.pdf
	@echo -n "Testing $(dir $@)... "
	@./diffpdf.py $^ 0.02 || (echo ko; false)
	@echo ok | tee $@

%.fmt: %.tex ../apxproof.sty
	@cd $(dir $@) && pdflatex -ini '&pdflatex' $(notdir $<) '\dump' >/dev/null 2>/dev/null

preamble/test.pdf: preamble/test_preamble.fmt

../apxproof.sty: ../apxproof.ins ../apxproof.dtx
	make -C .. apxproof.sty

.PHONY: all test clean
