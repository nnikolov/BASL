class AddFilenameToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :filename, :string
  end
end
