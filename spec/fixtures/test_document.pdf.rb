meta page_size: "A4"

content do |data|
  text "Test document"
  status_line data.nested.status
end
