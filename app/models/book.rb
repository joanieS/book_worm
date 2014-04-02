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
end
