all: apxproof.pdf apxproof.sty

clean:
	-rm -f *.aux *.log *.gl? *.idx *.ilg *.fls *.ind *.axp

%.pdf: %.dtx %.sty
	pdflatex $<
	makeindex -s gglo.ist -o $(patsubst %.pdf,%.gls,$@) $(patsubst %.pdf,%.glo,$@)
	pdflatex $<
	pdflatex $<

%.sty: %.ins %.dtx
	-rm $@
	latex $<
