class AddExchangeToInstruments < ActiveRecord::Migration[7.1]
  def change
    add_reference :instruments, :exchange, null: false, foreign_key: true
  end
end
