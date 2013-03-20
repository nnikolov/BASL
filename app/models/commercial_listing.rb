class CommercialListing < ActiveRecord::Base
  validates :company_name, :presence => true, :uniqueness => true
  validates :player_name, :presence => true, :uniqueness => true

  def contact
    contact = []
    if telephone
      contact << "telephone"
    end
    if email
      contact << "email"
    end
    if website
      contact << "website"
    end
    contact
  end
end
