class CreateQuotes < ActiveRecord::Migration[7.1]
  def change
    create_table :quotes do |t|
      t.timestamp :time
      t.decimal :open
      t.decimal :close
      t.decimal :high
      t.decimal :low
      t.integer :volume

      t.timestamps
    end
  end
end
