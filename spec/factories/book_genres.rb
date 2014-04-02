# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book_genre, :class => 'BookGenres' do
    book_id 1
    genre_id 1
  end
end
