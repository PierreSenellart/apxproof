all: apxproof.pdf apxproof.sty

%.pdf: %.dtx
	pdflatex $<
	makeindex -s gglo.ist -o $(patsubst %.pdf,%.gls,$@) $(patsubst %.pdf,%.gls,$@)
	pdflatex $<

%.sty: %.ins %.dtx
	latex $<
