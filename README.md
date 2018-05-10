# `apxproof`: Proofs in Appendix

## About

The `apxproof` package makes it easier to write articles where proofs and
other material are deferred to the appendix. The appendix material is
written in the LaTeX code along with the main text which it naturally
complements, and it is automatically deferred. The package can
automatically send proofs to the appendix, can repeat in the appendix the
theorem environments stated in the main text, can section the appendix
automatically based on the sectioning of the main text, and supports a
separate bibliography for the appendix material.

The documentation of this package is provided in the
[apxproof.pdf](apxproof.pdf) file.

## Prerequisites

In addition to a working installation of LaTeX2e, `apxproof` relies on a
few other packages, which should be provided by all reasonable LaTeX
distributions:
 - `amsthm`
 - `bibunits`
 - `environ`
 - `etoolbox`
 - `fancyvrb`
 - `ifthen`
 - `kvoptions`

## Manual installation

Simply copy the file [apxproof.sty](apxproof.sty) in your LaTeX working directory, or
in any other directory where LaTeX searches for packages.

## License

Copyright © 2016-2018 by Pierre Senellart.

This work may be distributed and/or modified under the conditions of the
LaTeX Project Public License, either version 1.3 of this license or (at
your option) any later version. The latest version of this license is in
http://www.latex-project.org/lppl.txt and version 1.3 or later is part of
all distributions of LaTeX version 2005/12/01 or later.

## Contact

https://github.com/PierreSenellart/apxproof

Pierre Senellart <pierre@senellart.com>

Bug reports and feature requests should
preferably be submitted through the *Issues* feature of GitHub.
