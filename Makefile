PDFLATEX=pdflatex -synctex=1 $(1) < /dev/null

all: apxproof.pdf apxproof.sty

clean:
	-rm -f *.aux *.log *.gl? *.idx *.ilg *.fls *.ind *.axp *.bbl *.blg *.hd  *.out *.sty *.pdf

ctan:
	git archive --format zip master --prefix=apxproof/  --output apxproof.zip

%.pdf: %.dtx %.sty
	$(call PDFLATEX, $<)
	makeindex -s gind.ist $(patsubst %.pdf,%.idx,$@)
	makeindex -s gglo.ist -o $(patsubst %.pdf,%.gls,$@) $(patsubst %.pdf,%.glo,$@)
	bibtex $(patsubst %.pdf,%,$@)
	bibtex bu1
	$(call PDFLATEX, $<)
	$(call PDFLATEX, $<)

%.sty: %.ins %.dtx
	-rm $@
	latex $<
