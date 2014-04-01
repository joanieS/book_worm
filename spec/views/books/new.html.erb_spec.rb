require 'spec_helper'

describe "books/new" do
  before(:each) do
    assign(:book, stub_model(Book,
      :title => "MyString",
      :author => "MyString",
      :isbn => "MyString",
      :release_date => "MyString",
      :excerpt => "MyString"
    ).as_new_record)
  end

  it "renders new book form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", books_path, "post" do
      assert_select "input#book_title[name=?]", "book[title]"
      assert_select "input#book_author[name=?]", "book[author]"
      assert_select "input#book_isbn[name=?]", "book[isbn]"
      assert_select "input#book_release_date[name=?]", "book[release_date]"
      assert_select "input#book_excerpt[name=?]", "book[excerpt]"
    end
  end
end
