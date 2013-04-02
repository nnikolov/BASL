require 'test_helper'

class NewsByteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "validations" do
    news_byte = NewsByte.new
    assert !news_byte.save, "Saved news_byte with no title and body"
 
    news_byte = NewsByte.new(:title => "Braking news")
    assert !news_byte.save, "Saved news_byte with no body"

    news_byte = NewsByte.new(:body => "Braking news body")
    assert !news_byte.save, "Saved news_byte with no title"

    news_byte = NewsByte.new(:title => "Breaking news", :body => "Braking news body")
    assert news_byte.save, "Could not save news_byte"

  end
end
