class CreateCommercialListings < ActiveRecord::Migration
  def change
    create_table :commercial_listings do |t|
      t.string :company_name
      t.string :player_name
      t.string :title
      t.string :business_type
      t.string :telephone
      t.string :email
      t.string :website
      t.text :description

      t.timestamps
    end
  end
end
