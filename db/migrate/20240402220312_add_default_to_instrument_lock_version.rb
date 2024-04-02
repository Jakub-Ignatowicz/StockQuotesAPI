class AddDefaultToInstrumentLockVersion < ActiveRecord::Migration[7.1]
  def change
    add_column :instruments, :lock_version, :integer, default: 0
  end
end
