class AddLockVersionToQuotes < ActiveRecord::Migration[7.1]
  def change
    add_column :quotes, :lock_version, :integer
  end
end
