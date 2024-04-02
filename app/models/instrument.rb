class Instrument < ApplicationRecord
  belongs_to :exchange
  validates :ticker, presence: true, length: { maximum: 20 },
                     format: { with: /\A[a-zA-Z0-9]+\z/, message: 'ticker can only contain letters and numbers' }
  validates :name, presence: true, length: { maximum: 256 }

  has_many :quotes

  before_save :uppercase_mic

  def uppercase_mic
    self.ticker = ticker.upcase if ticker
  end
end
