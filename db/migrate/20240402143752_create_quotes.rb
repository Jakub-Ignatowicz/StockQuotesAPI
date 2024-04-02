class CreateQuotes < ActiveRecord::Migration[7.1]
  def change
    create_table :quotes do |t|
      t.datetime :time, precision: nil, null: false
      t.decimal :open, precision: 11, scale: 4, null: false
      t.decimal :close, precision: 11, scale: 4, null: false
      t.decimal :high, precision: 11, scale: 4, null: false
      t.decimal :low, precision: 11, scale: 4, null: false
      t.integer :volume, null: false

      t.timestamps
    end
  end
end
