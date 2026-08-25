-- Build configuration file for apxproof

module = "apxproof"

typesetexe = "pdflatex"
typesetopts = " --interaction=nonstopmode"
typesetsuppfiles = {"*.bib"}
bibfiles = {"support/*.bib"}
textfiles = {"README.md", "LICENSE"}
scriptfiles = {"apxproof-synctex"}
-- Also listed as sources so that l3build copies them into the unpack
-- directory (where scriptfiles are looked up) and into the CTAN archive.
sourcefiles = {"*.dtx", "*.ins", "apxproof-synctex", "apxproof.sty.ltxml"}
-- The LaTeXML binding goes next to apxproof.sty, on TEXINPUTS, which is
-- where LaTeXML looks for it through kpsewhich (as emo and stex do).
installfiles = {"*.sty", "*.cls", "apxproof.sty.ltxml"}

-- Metadata for `l3build upload`. Update `version` at each release; set
-- `announcement` for feature releases, keep it empty for bugfix releases
-- (an empty announcement means the CTAN update is not announced).
uploadconfig = {
  pkg          = "apxproof",
  version      = "1.5.0",
  author       = "Pierre Senellart",
  uploader     = "Pierre Senellart",
  email        = "pierre@senellart.com",
  license      = "lppl1.3",
  summary      = "Proofs in appendix",
  -- The long description and the topics as the CTAN catalogue holds them, so
  -- that an upload restates rather than silently drops them, with the
  -- dependency list corrected (it omitted catchfile and appendix) and SyncTeX
  -- and the LaTeXML binding added. The catalogue records no home, support or
  -- development channel for the package, and `note` is a message to the CTAN
  -- team, not a stored field: all four are left unset, which is what the `??`
  -- of the upload summary means.
  description  = [[
<p>
      The package makes it easier to write articles where
      proofs and other material are deferred to the appendix.
    </p>
  <p>
      The appendix material is written in the LaTeX code
      along with the main text which it naturally complements,
      and it is automatically deferred.
    </p>
  <p>
      The package can automatically send proofs to the appendix,
      can repeat in the appendix the theorem environments stated
      in the main text,
      can section the appendix automatically based on the
      sectioning of the main text, and supports a separate
      bibliography for the appendix material.
      SyncTeX is supported throughout, so that editors and PDF
      viewers point at the source lines that produced the
      appendix material; a LaTeXML binding is provided for
      conversion to HTML.
    </p>
  <p>
      It depends on the following packages:
      <ref refid="amsthm">amsthm</ref>,
      <ref refid="appendix">appendix</ref> (if the appendix option is set to <tt>chapterend</tt>),
      <ref refid="bibunits">bibunits</ref> (if the bibliography option is set to <tt>separate</tt>),
      <ref refid="catchfile">catchfile</ref>,
      <ref refid="environ">environ</ref>,
      <ref refid="etoolbox">etoolbox</ref>,
      <ref refid="fancyvrb">fancyvrb</ref>,
      <ref refid="ifthen">ifthen</ref>, and
      <ref refid="kvoptions">kvoptions</ref>.
    </p>]],
  topic        = {"proof", "appendix", "tagged-pdf-incompatible"},
  ctanPath     = "/macros/latex/contrib/apxproof",
  repository   = "https://github.com/PierreSenellart/apxproof",
  bugtracker   = "https://github.com/PierreSenellart/apxproof/issues",
  update       = true,
  announcement = [[
Version 1.5.0 of apxproof adds SyncTeX support.

Appendix material and repeated theorems are now typeset from the source files
instead of being copied to an auxiliary file, so that editors and PDF viewers
point at the source lines that produced them, in the appendix as well as in the
main text. This happens by default whenever the engine is run with SyncTeX
output enabled; the new "synctex" option forces it on or off. With pdfTeX and
XeTeX, the apxproof-synctex script now distributed with the package
additionally makes forward search find appendix material.

The optional argument that cleveref adds to \label is now supported within
repeated material, as are the \zlabel and \zcref commands of zref-clever.

A LaTeXML binding, apxproof.sty.ltxml, is now distributed and documented: it
converts documents using apxproof to HTML with their proofs deferred, their
theorems repeated and their appendix bibliography preserved.
]],
}

function typeset(file, dir)
  local errorlevel = tex(file, dir)
  if errorlevel ~= 0 then
    return errorlevel
  else
    local name = jobname(file)
    errorlevel = bibtex(name, dir) + bibtex("bu1", dir)
    if errorlevel == 0 then
      local function cycle(name, dir)
        return(
          makeindex(name, dir, ".glo", ".gls", ".glg", glossarystyle) +
          makeindex(name, dir, ".idx", ".ind", ".ilg", indexstyle)    +
          tex(file, dir)
        )
      end
      for i = 1, typesetruns do
        errorlevel = cycle(name, dir)
        if errorlevel ~= 0 then break end
      end
    end
    return errorlevel
  end
end
