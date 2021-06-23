-- Build configuration file for apxproof

module = "apxproof"

typesetexe = "pdflatex"
typesetopts = " --interaction=nonstopmode"
typesetsuppfiles = {"*.bib"}
bibfiles = {"support/*.bib"}
textfiles = {"*.md", "LICENSE"}

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
