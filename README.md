# `apxproof`: Proofs in Appendix

[![CI](https://github.com/PierreSenellart/apxproof/actions/workflows/build_and_test.yml/badge.svg?branch=master)](https://github.com/PierreSenellart/apxproof/actions/workflows/build_and_test.yml)

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

## SyncTeX

Since version 1.5.0, apxproof supports SyncTeX (synchronization between
the source and the PDF in editors and viewers) for appendix material and
repeated theorems, by re-reading them from the source files when the
appendix is typeset; this is enabled by default whenever the engine is run
with `-synctex=1` (option `synctex=auto`), see the documentation. With
pdfTeX and XeTeX, forward search (from the source to the PDF) into
appendix material additionally requires running the
[apxproof-synctex](apxproof-synctex) script (Python 3) after each
compilation, e.g., with `$success_cmd = 'apxproof-synctex %R';` in a
`latexmkrc` file; with LuaTeX this is not needed.

## HTML conversion with LaTeXML

The repository provides a [LaTeXML](https://dlmf.nist.gov/LaTeXML/)
binding, [apxproof.sty.ltxml](apxproof.sty.ltxml), which lets documents
using `apxproof` be converted to HTML with `latexml`/`latexmlc` while
reproducing the package's behavior: proofs deferred to the appendix,
repeated theorem statements with their original numbering, automatic
appendix sectioning, forward links from theorems to their proofs, and a
separate appendix bibliography.

Nothing is needed to use it when `apxproof` is installed in your TeX tree:
LaTeXML finds `apxproof.sty.ltxml` next to `apxproof.sty`. Otherwise, copy
it next to your document, or keep it in any other directory and point
LaTeXML at it with `--path`:

```
latexmlc --path=/path/to/apxproof --dest=paper.html paper.tex
```

(`apxproof.sty` itself must also be findable, which is normally the case
through your TeX installation.) Do *not* pass `--includestyles`: the
binding is self-contained, and that option makes LaTeXML process the raw
`apxproof.sty` dependencies, which fails.

LaTeXML 0.8.8 or later is required. `make test-latexml` runs the LaTeXML
conversion over the example suite.

## Authorship

`apxproof` was written by Pierre Senellart, with contributions from
Klaus-Dieter Bauer, Antoine Amarilli, Leonid Kostrykin and Yuichi
Komorida (see the acknowledgments in the documentation and the git
history). Since 2026, maintenance and new features have been developed
with the assistance of generative models from Anthropic (*Claude*); the
behavior of the package was specified and reviewed by the author, who is
responsible for the whole. The regression tests, which compare the output
on the example documents against reference PDFs, run in continuous
integration on every change.

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
