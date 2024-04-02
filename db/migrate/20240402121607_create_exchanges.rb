class CreateExchanges < ActiveRecord::Migration[7.1]
  def change
    create_table :exchanges do |t|
      t.string :mic
      t.string :name

      t.timestamps
    end
  end
end
