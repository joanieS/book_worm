require 'open-uri'

module BooksHelper

  def save_books
    urls = ["https://www.goodreads.com/book/most_read"]
    urls.each do |url|
      results = find_titles(url)
      results.each do |result|
        find_book(result[0], result[1])
      end
    end
  end

  def find_titles(url)
    page = Nokogiri::HTML(open(url))
    results = page.css('div.leftContainer table.tableList tr td a span')
    count = results.count/2
    (0..count-1).map do |i|
      [results[i*2].text.split(" (").first, results[i*2 +1].text]
    end
  end

  def find_book(title, author)
    request = Typhoeus::Request.new(
    "https://www.googleapis.com/books/v1/volumes",
    params: { q: CGI::escape("#{title}"), filter: "partial", key: ENV["GOOGLE_BOOKS_API_KEY"]},
    )

    response = request.run

    my_stuff = JSON.parse(response.body)
    option = my_stuff["items"].first
    if option["volumeInfo"]["title"].match(title) && option["volumeInfo"]["authors"].include?(author)
      author_names = option["volumeInfo"]["authors"]
      isbn = option["volumeInfo"]["industryIdentifiers"].first["identifier"]
      genre_names = option["volumeInfo"]["categories"]
      release_date = option["volumeInfo"]["publishedDate"]
      title = option["volumeInfo"]["title"]

      puts "Trying to save #{title}..."

      book = Book.new(
        title: title, 
        release_date: release_date, 
        author_names: author_names,
        genre_names: genre_names,
        isbn: isbn  
      )

      book.save unless book.persisted?
    else
      puts "Rejected!"
    end
  end

  def find_isbn
    book_obj = {title: book_info.title, release_date: book_info.published_date, isbn: book_info.isbn, excerpt:book_info.preview_link, authors:book_info.authors_array}
    book_obj[:isbn]
  end

  
end