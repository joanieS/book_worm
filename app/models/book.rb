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
    urls = [
      # "http://www.goodreads.com/list/show/6",
      # "http://www.goodreads.com/list/show/7",
      # "http://www.goodreads.com/list/show/264.Books_That_Everyone_Should_Read_At_Least_Once", #problem
      # "http://www.goodreads.com/list/show/36.Best_Poetry_Books",
      # "http://www.goodreads.com/list/show/135.Best_Horror_Novels",
      # "http://www.goodreads.com/list/show/15.Best_Historical_Fiction", #problem
      # "http://www.goodreads.com/list/show/281.Best_Memoir_Biography_Autobiography",
      # "http://www.goodreads.com/list/show/735.Must_Read_Non_Fiction",
      # "http://www.goodreads.com/list/show/7205.Best_of_Little_Known_Authors",
      # "http://www.goodreads.com/list/show/348.Thrillers",
      # "http://www.goodreads.com/list/show/11.Best_Crime_Mystery_Books"

      # "http://www.goodreads.com/list/show/8166.Books_You_Wish_More_People_Knew_About",
      # "http://www.goodreads.com/list/show/183.Tales_of_New_York_City",
      # "http://www.goodreads.com/list/show/16.Best_Books_of_the_19th_Century",
      # "http://www.goodreads.com/book/most_read",
      # "http://www.goodreads.com/list/show/3.Best_Science_Fiction_Fantasy_Books",
      # "http://www.goodreads.com/list/show/30",
      # "http://www.goodreads.com/list/show/2602.Best_Female_Lead_Characters",
      # "http://www.goodreads.com/list/show/50.The_Best_Epic_Fantasy",
      # "http://www.goodreads.com/list/show/824.Best_Non_fiction_War_Books",
      # "http://www.goodreads.com/list/show/397.Best_Paranormal_Romance_Series",
      # "http://www.goodreads.com/list/show/338.Immigrant_Experience_Literature",
      "http://www.goodreads.com/list/show/10925.Funny_Women_Memoirs",
      "http://www.goodreads.com/list/show/29013.Best_Biographies",
      "http://www.goodreads.com/list/show/495.Best_of_William_Shakespeare",
      "http://www.goodreads.com/list/show/453.Best_Philosophical_Literature"
    ]
    urls.each do |url|
      puts "On #{url}"
      results = Book.find_titles(url)
      results.each do |result|
        Book.find_book(result[0], result[1])
      end
    end
  end

  def self.save_books_from(url)
    results = Book.find_titles(url)
    results.each do |result|
      Book.find_book(result[0], result[1])
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
    book = Book.find_or_initialize_by(title: title)
    if book.persisted?
      puts "Already have #{title} in database."
      return
    else
      request = Typhoeus::Request.new(
        "https://www.googleapis.com/books/v1/volumes",
        params: { 
          q: CGI::escape("#{title}"), 
          filter: "partial", 
          key: ENV["GBOOKS_BACKUP_KEY2"]
        }
      )

      response = request.run

      begin
      my_stuff = JSON.parse(response.body)
      option = my_stuff["items"].first
        if option["volumeInfo"]["title"].match(title) && option["volumeInfo"]["authors"].include?(author)
          author_names = option["volumeInfo"]["authors"]
          isbn = option["volumeInfo"]["industryIdentifiers"].first["identifier"]
          # genre_names = option["volumeInfo"]["categories"]
          release_date = option["volumeInfo"]["publishedDate"]

          puts "Saving #{title}..."

          book.update(
            isbn: isbn,
            release_date: release_date, 
            author_names: author_names, 
            genre_names: self.scrape_genres(isbn)
          )
        else
          puts "We did not find a preview for #{title}."
        end
      rescue
        puts "We're missing info!"
        return
      end
    end
  end

  def self.scrape_genres(isbn)
    url = "https://www.goodreads.com/book/isbn/#{isbn}"
    page = Nokogiri::HTML(open(url))
    results = page.css('div.bigBoxBody div.elementList div.left a.actionLinkLite')
    genre_names = results.map do |result|
      result.text
    end
    genre_names.uniq
  end

end
