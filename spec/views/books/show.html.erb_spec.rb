require 'spec_helper'

describe "books/show" do
  before(:each) do
    @book = assign(:book, stub_model(Book,
      :title => "Title",
      :author => "Author",
      :isbn => "Isbn",
      :release_date => "Release Date",
      :excerpt => "Excerpt"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Author/)
    rendered.should match(/Isbn/)
    rendered.should match(/Release Date/)
    rendered.should match(/Excerpt/)
  end
end
