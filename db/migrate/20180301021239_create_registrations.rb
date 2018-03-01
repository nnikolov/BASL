class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :registrations do |t|
      t.string :name
      t.text :description
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
