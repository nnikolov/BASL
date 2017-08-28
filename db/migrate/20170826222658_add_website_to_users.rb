class AddWebsiteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :website, :boolean, default: false
  end
end
