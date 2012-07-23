class CommercialListing < ActiveRecord::Base
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
