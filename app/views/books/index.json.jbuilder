json.array!(@books) do |book|
  json.extract! book, :id, :title, :author, :isbn, :release_date, :excerpt
  json.url book_url(book, format: :json)
end
