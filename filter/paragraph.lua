function Para(el)
  -- Check if the paragraph contains only one Strong element
  if #el.content == 1 and el.content[1].t == "Strong" then
    -- Extract the text from the Strong element
    local text = pandoc.utils.stringify(el.content[1].content)

    return pandoc.Para{pandoc.RawInline("latex", "\\paragraph{" .. text .. "}") }
  end
end

