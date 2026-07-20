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
- `environ`
- `etoolbox`
- `fancyvrb`
- `ifthen`
- `kvoptions`
- `bibunits` (optional, only if the `bibliography` option is set to `separate`)
- `appendix` (optional, only if the `appendix` option is set to `chapterend`)

## Manual installation

Simply copy the file [apxproof.sty](apxproof.sty) in your LaTeX working
directory, or in any other directory where LaTeX searches for packages.

## HTML conversion with LaTeXML

The repository provides a [LaTeXML](https://dlmf.nist.gov/LaTeXML/)
binding, [apxproof.sty.ltxml](apxproof.sty.ltxml), which lets documents
using `apxproof` be converted to HTML with `latexml`/`latexmlc` while
reproducing the package's behavior: proofs deferred to the appendix,
repeated theorem statements with their original numbering, automatic
appendix sectioning, forward links from theorems to their proofs, and a
separate appendix bibliography.

To use it, copy `apxproof.sty.ltxml` next to your document, or keep it in
any other directory and point LaTeXML at it with `--path`:

```
latexmlc --path=/path/to/apxproof --dest=paper.html paper.tex
```

(`apxproof.sty` itself must also be findable, which is normally the case
through your TeX installation.) Do *not* pass `--includestyles`: the
binding is self-contained, and that option makes LaTeXML process the raw
`apxproof.sty` dependencies, which fails.

`make test-latexml` runs the LaTeXML conversion over the example suite
(requires LaTeXML to be installed). Documents based on KOMA-Script
(`scrartcl`, `scrbook`) or `memoir`, and documents using `biblatex`,
cannot currently be converted, but these are LaTeXML limitations
unrelated to `apxproof`: they affect such documents whether or not they
use this package.

## License

Copyright © 2016-2026 by Pierre Senellart.

This work may be distributed and/or modified under the conditions of the
LaTeX Project Public License, either version 1.3 of this license or (at
your option) any later version. The latest version of this license is in
<http://www.latex-project.org/lppl.txt> and version 1.3 or later is part of
all distributions of LaTeX version 2005/12/01 or later.

The [diffpdf.py](examples/diffpdf.py) script used for regression testing
but not part of the `apxproof` LaTeX package itself is under the
[Affero GPL 3.0](https://www.gnu.org/licenses/agpl-3.0.html) license.

## Contact

<https://github.com/PierreSenellart/apxproof>

Pierre Senellart <pierre@senellart.com>

Bug reports and feature requests should
preferably be submitted through the *Issues* feature of GitHub.
