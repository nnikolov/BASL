require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "validations" do
    field = Field.new
    assert !field.save, "Saved field with no name and code"
 
    field = Field.new(:name => "Hornets Nest 5", :code => "HN5")
    assert field.save, "Could not save field"

    field2 = Field.new(:name => "Hornets Nest 5", :code => "HN")
    assert !field2.save, "Saved field with a duplicate name"

    field3 = Field.new(:name => "Hornets Nest", :code => "HN5")
    assert !field3.save, "Saved field with a duplicate code"
  end
end
