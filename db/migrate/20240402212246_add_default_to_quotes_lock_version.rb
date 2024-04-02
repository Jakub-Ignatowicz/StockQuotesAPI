class AddDefaultToQuotesLockVersion < ActiveRecord::Migration[7.1]
  def change
    remove_column :quotes, :lock_version
    add_column :quotes, :lock_version, :integer, default: 0
  end
end

