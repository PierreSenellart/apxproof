#!/bin/sh

# Check that appendix material survives when TeX is given a path to the main
# file, as in "pdflatex sub/doc.tex". The synctex option then cannot assume
# the main file is \jobname.tex: it reads the name it was opened under from
# the .fls file, and, when no .fls is available, falls back to copying the
# material to the .axp file instead of losing it.
#
# usage: checkmainpath.sh   (run from the examples directory)
#
# requirements: pdflatex, Poppler's pdftotext

set -e

here=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
status=0

document='\documentclass{article}
\usepackage[synctex=yes]{apxproof}
\newtheoremrep{theorem}{Theorem}
\begin{document}
\begin{theoremrep}Statement quokka.\end{theoremrep}
\begin{proof}
Proof wombat.
\end{proof}
\end{document}'

# $1: subdirectory to build in, $2: extra pdflatex options,
# $3: "found" if the main file is expected to be located, "fallback" otherwise
run() {
  mkdir -p "$work/$1/sub"
  printf '%s\n' "$document" > "$work/$1/sub/doc.tex"
  ( cd "$work/$1" && TEXINPUTS="$here/..:" pdflatex -synctex=1 $2 \
      -interaction=nonstopmode sub/doc.tex ) > /dev/null 2>&1 || true

  if [ ! -f "$work/$1/doc.pdf" ]; then
    echo "checkmainpath: no PDF produced ($1)"
    status=1
    return
  fi
  # The deferred proof must reach the appendix, and the theorem must be
  # restated there, whichever way the main file was found.
  wombat=$(pdftotext "$work/$1/doc.pdf" - | grep -c wombat || true)
  quokka=$(pdftotext "$work/$1/doc.pdf" - | grep -c quokka || true)
  if [ "$wombat" != 1 ] || [ "$quokka" != 2 ]; then
    echo "checkmainpath: appendix material missing ($1):" \
         "proof x$wombat, statement x$quokka, expected 1 and 2"
    status=1
  fi
  # With a .fls the main file is located, so the re-reading stays on; without
  # one the package must say that it is falling back, not fail silently.
  if grep -q 'Cannot read the main source file' "$work/$1/doc.log"; then
    found=fallback
  else
    found=found
  fi
  if [ "$found" != "$3" ]; then
    echo "checkmainpath: expected $3, got $found ($1)"
    status=1
  fi
}

run withfls "-recorder" found
run nofls "" fallback

exit $status
