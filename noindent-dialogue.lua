-- noindent-dialogue.lua
-- Supprime l'alinéa des paragraphes qui commencent par un cadratin (—) en sortie LaTeX/PDF.

local function first_str(inlines)
  for _, el in ipairs(inlines) do
    if el.t == "Str" then return el.text end
    if el.t ~= "Space" and el.t ~= "SoftBreak" and el.t ~= "LineBreak" then return nil end
  end
  return nil
end

function Para(p)
  if not FORMAT:match("latex") then return nil end
  local s = first_str(p.content)
  if s and s:match("^[—«]") then
    table.insert(p.content, 1, pandoc.RawInline("latex", "\\noindent "))
    return p
  end
  return nil
end
