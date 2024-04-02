class AddDefaultToExchanges < ActiveRecord::Migration[7.1]
  def change
    add_column :exchanges, :lock_version, :integer, default: 0
  end
end
