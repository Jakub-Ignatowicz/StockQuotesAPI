class AddInstrumentToQuotes < ActiveRecord::Migration[7.1]
  def change
    add_reference :quotes, :instrument, null: false, foreign_key: true
  end
end
