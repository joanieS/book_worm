require 'open-uri'

module Saveable
  def grab_covers
    Book.all.each do |book|
      response = request(book.title).run
      begin
        stuff = JSON.parse(response.body)
        option = stuff["items"].first
        book.update(cover_link: option["volumeInfo"]["imageLinks"]["thumbnail"])
        puts "Grabbed cover for #{book.title}."
      rescue
        next
      end
    end
  end

  def save_books
    urls = [
      "http://www.goodreads.com/list/show/6",
      "http://www.goodreads.com/list/show/7",
      # "http://www.goodreads.com/list/show/264.Books_That_Everyone_Should_Read_At_Least_Once",
      # "http://www.goodreads.com/list/show/36.Best_Poetry_Books",
      # "http://www.goodreads.com/list/show/135.Best_Horror_Novels",
      # "http://www.goodreads.com/list/show/15.Best_Historical_Fiction"
      # "http://www.goodreads.com/list/show/281.Best_Memoir_Biography_Autobiography",
      "http://www.goodreads.com/list/show/735.Must_Read_Non_Fiction",
      "http://www.goodreads.com/list/show/7205.Best_of_Little_Known_Authors"
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
      # "http://www.goodreads.com/list/show/10925.Funny_Women_Memoirs",
      # "http://www.goodreads.com/list/show/29013.Best_Biographies",
      # "http://www.goodreads.com/list/show/495.Best_of_William_Shakespeare",
      # "http://www.goodreads.com/list/show/453.Best_Philosophical_Literature"
    ]
    urls.each do |url|
      puts "On #{url}"
      results = find_titles(url)
      results.each do |result|
        find_book(result[0], result[1])
      end
    end
  end

  private

  def save_info_for(option, title, book_object)
    author_names = option["volumeInfo"]["authors"]
    isbn = option["volumeInfo"]["industryIdentifiers"].first["identifier"]
    release_date = option["volumeInfo"]["publishedDate"]
    cover_link = option["volumeInfo"]["imageLinks"]["thumbnail"]

    puts "Saving #{title}..."

    book_object.update(
      isbn: isbn,
      release_date: release_date,
      author_names: author_names,
      genre_names: scrape_genres(isbn),
      cover_link: cover_link
    )
  end

  def preview_available_for(option, title, author)
    option["volumeInfo"]["title"].match(title) && option["volumeInfo"]["authors"].include?(author)
  end

  def find_titles(url)
    page = Nokogiri::HTML(open(url))
    results = page.css('div.leftContainer table.tableList tr td a span')
    count = results.count/2
    (0..count-1).map do |i|
      [results[i*2].text.split(" (").first, results[i*2 + 1].text]
    end
  end

  def find_book(title, author)
    book_object = Book.find_or_initialize_by(title: title)
    if book_object.persisted?
      puts "Already have #{title} in database."
    else
      response = request(title).run
      begin
        response_body = JSON.parse(response.body)
        option = response_body["items"].first
          if preview_available_for(option, title, author)
            save_info_for(option, title, book_object)
          else
            puts "We did not find a preview for #{title}."
          end
      rescue
        puts "We're missing info!"
      end
    end
  end

  def scrape_genres(isbn)
    url = "https://www.goodreads.com/book/isbn/#{isbn}"
    page = Nokogiri::HTML(open(url))
    results = page.css('div.bigBoxBody div.elementList div.left a.actionLinkLite')
    genre_names = results.map do |result|
      result.text
    end
    genre_names.uniq
  end

  def request(title)
    Typhoeus::Request.new(
      "https://www.googleapis.com/books/v1/volumes",
      params: {
        q: CGI::escape("#{title}"),
        filter: "partial",
        key: ENV["GOOGLE_BOOKS_API_KEY"]
      }
    )
  end
end
