class CreateInstruments < ActiveRecord::Migration[7.1]
  def change
    create_table :instruments do |t|
      t.string :ticker, limit: 20, null: false
      t.string :name, limit: 256, null: false

      t.timestamps
    end
  end
end
