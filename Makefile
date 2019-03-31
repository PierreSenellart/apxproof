all: apxproof.pdf apxproof.sty

clean:
	l3build clean

ctan:
	l3build ctan

%.pdf: %.dtx
	l3build doc

%.sty: %.ins %.dtx
	l3build unpack
	cp build/unpacked/$@ .
