SHELL := /bin/bash

TARGET = $(patsubst %.tex,%.test,$(wildcard */test.tex))

# Examples not expected to convert with LaTeXML:
#  - preamble uses a precompiled format;
#  - synctex and synctex-lualatex wrap a repeated theorem in a user-defined
#    environment, which LaTeXML's emulation of the environ package does not
#    support (the synctex option itself is dropped by the binding);
#  - the others use KOMA-Script, memoir, biblatex or the LIPIcs classes,
#    which LaTeXML cannot process. This is unrelated to apxproof: a bare
#    document using any of them, without apxproof, fails in the same way.
#    (arXiv converts LIPIcs documents through the separate ar5iv bindings.)
LATEXML_SKIP = preamble synctex synctex-lualatex biblatex-separate \
  forwardlink-13 forwardlink-13-nohref latin1 memoir scrartcl scrbook utf8 \
  inline lipics lipics-v2016 lipics-v2016-toc lipics-v2019-autoref lipics-v2021 \
  repeatedtheorem strip
LATEXML_TARGET = $(filter-out $(addsuffix /test.lxml,$(LATEXML_SKIP)),\
  $(patsubst %.tex,%.lxml,$(wildcard */test.tex)))

all: $(TARGET)
test: $(TARGET)

test-latexml: $(LATEXML_TARGET)

clean:
	rm -f */*.aux */*.blg */*.bbl */*.axp
	rm -f */*.fls */*.fdb* */*.log */*.out */*.fmt */*.synctex.gz
	rm -f */merged.pdf
	rm -f */test.pdf */test.test
	rm -f */test.html */test.latexml.log */test.lxml */LaTeXML.css */ltx-*.css

%.pdf: %.tex ../apxproof.sty common.tex common.bib
	@cd $(dir $@) && latexmk -silent -c >/dev/null 2>/dev/null
	@cd $(dir $@) && latexmk -interaction=nonstopmode -silent -pdf test >/dev/null 2>/dev/null || (rm -fv test.pdf; false)

%.txt: %.pdf
	@pdftotext $<

%/test.test: %/reference.txt %/test.txt
	@echo -n "Testing $(dir $@)... "
	@./diffpdf.py $(dir $@)reference.pdf $(dir $@)test.pdf 0.05 || (echo ko; false)
	@diff -w $^ > $(dir $@)test.diff || (echo ko; cat $(dir $@)test.diff; rm $(dir $@)test.diff; false)
	@diff -w <(pdftk $(dir $@)reference.pdf dump_data_utf8|grep '^Bookmark') <(pdftk $(dir $@)test.pdf dump_data_utf8|grep '^Bookmark') > $(dir $@)test.diff || (echo ko; cat $(dir $@)test.diff; rm $(dir $@)test.diff; false)
	@diff -w <(qpdf --json $(dir $@)reference.pdf|grep '"/D".*axp'|sort) <(qpdf --json $(dir $@)test.pdf|grep '"/D".*axp'|sort) > $(dir $@)test.diff || (echo ko; cat $(dir $@)test.diff; rm $(dir $@)test.diff; false)
	@rm $(dir $@)test.diff
	@[ ! -f $(dir $@)synctex.expect ] || ./checksynctex.py $(dir $@)test.pdf $(dir $@)synctex.expect || (echo ko; false)
	@[ ! -f $(dir $@)synctex-merged.expect ] || (cp $(dir $@)test.pdf $(dir $@)merged.pdf && cp $(dir $@)test.synctex.gz $(dir $@)merged.synctex.gz && ../apxproof-synctex $(dir $@)merged && ./checksynctex.py $(dir $@)merged.pdf $(dir $@)synctex-merged.expect) || (echo ko; false)
	@echo ok | tee $@

%.lxml: %.tex ../apxproof.sty ../apxproof.sty.ltxml common.tex common.bib
	@echo -n "LaTeXML $(dir $@)... "
	@cd $(dir $@) && rm -f test.html test.latexml.log && \
	  { timeout 600 latexmlc --path=../.. --dest=test.html test.tex >/dev/null 2>&1 || true; }
	@test -f $(dir $@)test.html || (echo ko; false)
	@! grep -q '^Fatal:' $(dir $@)test.latexml.log || (echo ko; false)
	@echo ok | tee $@

%.fmt: %.tex ../apxproof.sty
	@cd $(dir $@) && pdflatex -ini '&pdflatex' $(notdir $<) '\dump' >/dev/null 2>/dev/null

preamble/test.pdf: preamble/test_preamble.fmt

../apxproof.sty: ../apxproof.ins ../apxproof.dtx
	make -C .. apxproof.sty

.PHONY: all test test-latexml clean
