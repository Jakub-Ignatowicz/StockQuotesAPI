class CreateExchanges < ActiveRecord::Migration[7.1]
  def change
    create_table :exchanges do |t|
      t.string :name, limit: 256, null: false
      t.string :mic, limit: 4, null: false

      t.timestamps
      t.index ['mic'], name: 'index_exchanges_on_mic', unique: true
    end
  end
end
