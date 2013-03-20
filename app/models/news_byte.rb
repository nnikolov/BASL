class NewsByte < ActiveRecord::Base
  validates :title, :body, :presence => true
end
