TARGET = $(patsubst %.tex,%.test,$(wildcard */test.tex))

all: $(TARGET)

clean:
	rm -f */*.aux */*.blg */*.bbl */*.axp 
	rm -f */*.fls */*.fdb* */*.log */*.out */*.fmt
	rm -f */test.pdf */test.test

%.pdf: %.tex ../apxproof.sty common.tex common.bib
	@cd $(dir $@) && latexmk -silent -c >/dev/null 2>/dev/null
	@cd $(dir $@) && latexmk -interaction=nonstopmode -silent -pdf test >/dev/null 2>/dev/null || (rm -fv test.pdf; false)

%.html: %.pdf
	@pdftotext -bbox $^ 2>/dev/null

%/test.test: %/reference.html %/test.html
	@echo -n "Testing $(dir $@)... " 
	@diff $^ | (! grep '^[<>]' | LC_ALL=C grep 'word.*>.*[A-Za-z0-9].*</word' > $@) || (echo ko; cat $@; rm $@; false)
	@echo ok

%.fmt: %.tex ../apxproof.sty 
	@cd $(dir $@) && pdflatex -ini '&pdflatex' $(notdir $<) '\dump' >/dev/null 2>/dev/null

preamble/test.pdf: preamble/test_preamble.fmt

../apxproof.sty: ../apxproof.ins ../apxproof.dtx
	make -C .. apxproof.sty
