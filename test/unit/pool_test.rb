require 'test_helper'

class PoolTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "validations" do
    pool = Pool.new
    assert !pool.save, "Saved pool with no name"
 
    pool = Pool.new(:name => "Pool A")
    assert pool.save, "Could not save pool"

  end
end
