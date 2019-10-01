all: apxproof.pdf apxproof.sty

clean:
	l3build clean
	make -C examples clean

ctan:
	l3build ctan

test:
	make -C examples
	@echo All tests passed!

%.pdf: %.dtx
	l3build doc

%.sty: %.ins %.dtx
	l3build unpack
	cp build/unpacked/$@ .
