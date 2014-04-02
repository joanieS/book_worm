require 'open-uri'

module BooksHelper

  URLS = "https://www.goodreads.com/book/most_read"
  URLS.each do |url|
    titles = find_titles(url)
    titles.each do |title|
      find_book(title)
  end

  def find_titles(url)
    page = Nokogiri::HTML(open(url))
    page.css('div.leftContainer table.tableList tr td a.bookTitle span')
  end

  def find_book(title)
    request = Typhoeus::Request.new(
    "https://www.googleapis.com/books/v1/volumes",
    params: { q: CGI::escape("The History of Tom Jones"), filter: "partial", key: ENV["GOOGLE_BOOKS_API_KEY"]},
    )

    response = request.run

    my_stuff = JSON.parse(response.body)
    option = my_stuff["items"].first
    if option["volumeInfo"]["title"] == title
      author = option["volumeInfo"]["authors"]
      isbn = option["volumeInfo"]["authors"]
      authors = option["volumeInfo"]["authors"]

    else next
    # if my_stuff["items"].first["volumeInfo"]["title"] != (our title variable)

    # my_stuff["items"].first["volumeInfo"]["previewLink"]

  end

  def find_isbn
    book_obj = {title: book_info.title, release_date: book_info.published_date, isbn: book_info.isbn, excerpt:book_info.preview_link, authors:book_info.authors_array}
    book_obj[:isbn]
  end

  
end
