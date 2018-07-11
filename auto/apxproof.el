(TeX-add-style-hook
 "apxproof"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fontenc" "TS1" "T1")))
   (add-to-list 'LaTeX-verbatim-environments-local "Verbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "Verbatim*")
   (add-to-list 'LaTeX-verbatim-environments-local "BVerbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "BVerbatim*")
   (add-to-list 'LaTeX-verbatim-environments-local "LVerbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "LVerbatim*")
   (add-to-list 'LaTeX-verbatim-environments-local "SaveVerbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "VerbatimOut")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "Verb")
   (TeX-run-style-hooks
    "latex2e"
    "ltxdoc"
    "ltxdoc10"
    "hypdoc"
    "textcomp"
    "fontenc"
    "lmodern"
    "microtype"
    "bibunits"
    "environ"
    "etoolbox"
    "fancyvrb"
    "ifthen"
    "kvoptions"
    "amsthm")
   (TeX-add-symbols
    '("appendixsectionformat" 2)
    '("newtheoremrep" 1)
    "appendixrefname"
    "appendixbibliographystyle"
    "appendixbibliographyprelim"
    "appendixprelim"
    "axp"
    "refname"
    "thmhead"
    "noproofinappendix"
    "nosectionappendix"
    "noexpand"
    "section")
   (LaTeX-add-environments
    "nestedproof"
    "inlineproof"
    "proof"
    "proofsketch"
    "toappendix"
    "appendixproof")
   (LaTeX-add-amsthm-newtheorems
    "example")
   (LaTeX-add-amsthm-newtheoremstyles
    "mystyle"))
 :latex)

