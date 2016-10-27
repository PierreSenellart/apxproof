all: apxproof.pdf apxproof.sty

clean:
	-rm -f *.sty *.aux *.log *.gl? *.idx *.ilg *.fls *.ind *.axp *.pdf

%.pdf: %.dtx %.sty
	pdflatex $<
	makeindex -s gglo.ist -o $(patsubst %.pdf,%.gls,$@) $(patsubst %.pdf,%.glo,$@)
	pdflatex $<

%.sty: %.ins %.dtx
	-rm $@
	latex $<
