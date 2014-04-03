require 'open-uri'

class Book < ActiveRecord::Base
  has_many :book_authors
  has_many :authors, :through => :book_authors
  has_many :book_genres
  has_many :genres, :through => :book_genres

  def author_names=(author_names)
    author_names.each do |author_name|
      self.book_authors.build(:author => Author.find_or_create_by(name: author_name))
    end
  end

  def genre_names=(genre_names)
    genre_names.each do |genre_name|
      self.book_genres.build(:genre => Genre.find_or_create_by(name: genre_name))
    end
  end

  def self.save_books
    urls = ["https://www.goodreads.com/book/most_read"]
    urls.each do |url|
      results = Book.find_titles(url)
      results.each do |result|
        Book.find_book(result[0], result[1])
      end
    end
  end

  def self.find_titles(url)
    page = Nokogiri::HTML(open(url))
    results = page.css('div.leftContainer table.tableList tr td a span')
    count = results.count/2
    (0..count-1).map do |i|
      [results[i*2].text.split(" (").first, results[i*2 +1].text]
    end
  end

  def self.find_book(title, author)
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

end
