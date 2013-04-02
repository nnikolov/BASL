class Rule < ActiveRecord::Base
  validates :body, :presence => true
end
