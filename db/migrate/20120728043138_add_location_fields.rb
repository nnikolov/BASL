class AddLocationFields < ActiveRecord::Migration
  def up
    add_column :fields, :location, :string
  end

  def down
    remove_column :fields, :location
  end
end
