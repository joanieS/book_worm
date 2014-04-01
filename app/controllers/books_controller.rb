class BooksController < ApplicationController
  include BooksHelper

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
    @isbn = find_isbn
  end

  def preview
    @isbn = find_isbn
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    @book.save
  end

  private

    def book_params
      params.require(:book).permit(:title, :author, :isbn, :release_date, :excerpt)
    end
end
