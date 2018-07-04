all: apxproof.pdf apxproof.sty

clean:
	-rm -f *.aux *.log *.gl? *.idx *.ilg *.fls *.ind *.axp *.bbl *.blg *.hd  *.out

ctan:
	git archive --format zip master --prefix=apxproof/  --output apxproof.zip

%.pdf: %.dtx %.sty
	pdflatex $<
	makeindex -s gind.ist $(patsubst %.pdf,%.idx,$@)
	makeindex -s gglo.ist -o $(patsubst %.pdf,%.gls,$@) $(patsubst %.pdf,%.glo,$@)
	bibtex $(patsubst %.pdf,%,$@)
	bibtex bu1
	pdflatex $<
	pdflatex $<

%.sty: %.ins %.dtx
	-rm $@
	latex $<
