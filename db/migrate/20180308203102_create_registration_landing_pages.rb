class CreateRegistrationLandingPages < ActiveRecord::Migration[5.1]
  def change
    create_table :registration_landing_pages do |t|
      t.string :name
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
