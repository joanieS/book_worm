# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title "MyString"
    author "MyString"
    isbn "MyString"
    release_date "MyString"
    excerpt "MyString"
  end
end
