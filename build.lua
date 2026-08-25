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
