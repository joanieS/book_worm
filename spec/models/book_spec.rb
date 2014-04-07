require 'spec_helper'

describe Book do
  it "scrapes book data from Goodreads" do
    expect(Book.find_by(isbn: "9788492683840")).to be_nil
    
    shakespeare_list = File.new File.expand_path('spec/fixtures/goodreads-shakespeare.html')
    stub_request(:get, "http://www.goodreads.com/list/show/495.Best_of_William_Shakespeare").to_return(shakespeare_list)

    google_hamlet = File.new File.expand_path('spec/fixtures/google-hamlet.json')
    stub_request(:get, "https://www.googleapis.com/books/v1/volumes?filter=partial&key=AIzaSyCb4oe6uvfhskLO5HGQrS7xdV0nsWnPwQs&q=Hamlet").to_return(google_hamlet)

    goodreads_hamlet = File.new File.expand_path('spec/fixtures/hamlet-goodreads-by-isbn.html')
    stub_request(:get, "https://www.goodreads.com/book/isbn/9788492683840").to_return(goodreads_hamlet)

    Book.save_books
    expect(Book.find_by(isbn: "9788492683840")).not_to be_nil
  end
end
