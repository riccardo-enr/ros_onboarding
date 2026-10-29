---@diagnostic disable: undefined-global
-- Adapts the LaTeX source for html/gfm: note/tip boxes -> GitHub alerts or
-- styled divs, PDF figures -> the SVGs from figures/build.py.

local gfm = FORMAT:match("gfm") ~= nil

local function callout(el)
  local kind, inner = el.text:match("^\\begin{(%a+)}(.-)\\end{%1}$")
  if kind == "checklist" then
    -- pandoc writes a bullet item that starts with U+2610 as a task-list checkbox
    local list = pandoc.read("\\begin{itemize}" .. inner .. "\\end{itemize}", "latex").blocks[1]
    for _, item in ipairs(list.content) do
      item[1].content:insert(1, pandoc.Space())
      item[1].content:insert(1, pandoc.Str("\u{2610}"))
    end
    return list
  end
  if kind ~= "note" and kind ~= "tip" then
    return nil
  end
  local blocks = pandoc.read(inner, "latex").blocks
  if gfm then
    blocks[1].content:insert(1, pandoc.RawInline("markdown", "[!" .. kind:upper() .. "]"))
    blocks[1].content:insert(2, pandoc.LineBreak())
    return pandoc.BlockQuote(blocks)
  end
  blocks:insert(1, pandoc.Para(pandoc.Strong(kind:sub(1, 1):upper() .. kind:sub(2))))
  return pandoc.Div(blocks, { class = "callout callout-" .. kind })
end

local function image(el)
  el.src = el.src:gsub("%.pdf$", ".svg")
  if gfm then
    el.src = "../" .. el.src
  end
  return el
end

-- gfm: pipe tables need no column widths and single-line cells
local function table(el)
  if not gfm then
    return nil
  end
  local specs = el.colspecs
  for i, spec in ipairs(specs) do
    specs[i] = { spec[1], pandoc.ColWidthDefault }
  end
  el.colspecs = specs
  return el:walk({ Para = function(p) return pandoc.Plain(p.content) end })
end

-- gfm: {[} in LaTeX reads as an empty Span, which forces raw HTML
local function span(el)
  if gfm and el.identifier == "" and #el.classes == 0 then
    return el.content
  end
end

-- gfm: GitHub shows YAML front matter as a table, so put title and abstract in the body
local function doc(d)
  local title, subtitle = pandoc.List(), pandoc.List()
  local target = title
  for _, il in ipairs(d.meta.title or {}) do
    if il.t == "LineBreak" then
      target = subtitle
    else
      target:insert(il)
    end
  end
  if not gfm then
    d.meta.title = pandoc.Inlines(title)
    if #subtitle > 0 then
      d.meta.subtitle = pandoc.Inlines(subtitle)
    end
    return d
  end
  local head = pandoc.Blocks({ pandoc.Header(1, title) })
  if #subtitle > 0 then
    head:insert(pandoc.Para(pandoc.Emph(subtitle)))
  end
  head:extend(d.meta.abstract or {})
  d.meta = pandoc.Meta({})
  return pandoc.Pandoc(head .. d.blocks, d.meta)
end

return { { Span = span }, { RawBlock = callout, Image = image, Table = table }, { Pandoc = doc } }
