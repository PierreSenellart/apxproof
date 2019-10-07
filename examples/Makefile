TARGET = $(patsubst %.tex,%.test,$(wildcard */test.tex))

all: $(TARGET)

clean:
	rm -f */*.aux */*.blg */*.bbl */*.axp 
	rm -f */*.fls */*.fdb* */*.log */*.out */*.fmt
	rm -f */test.pdf */test.test

%.pdf: %.tex ../apxproof.sty common.tex common.bib
	@echo ''
	cd $(dir $@) && latexmk -c
	cd $(dir $@) && latexmk -pdf test || (rm -fv test.pdf; false)

%.html: %.pdf
	pdftotext -bbox $^

%/test.test: %/reference.html %/test.html
	@echo -n "Testing $(dir $@)... " 
	@diff $^ | (! grep '^[<>]' | grep -v '^. <meta' > $@) || (echo ko; cat $@; rm $@; false)
	@echo ok

%.fmt: %.tex ../apxproof.sty 
	cd $(dir $@) && pdflatex -ini '&pdflatex' $(notdir $<) '\dump'

preamble/test.pdf: preamble/test_preamble.fmt

../apxproof.sty: ../apxproof.ins ../apxproof.dtx
	make -C ..
