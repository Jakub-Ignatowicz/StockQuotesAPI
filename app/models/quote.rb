class Quote < ApplicationRecord
  belongs_to :instrument

  validates :time, presence: true
  validates :open, :close, :high, :low, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :volume, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end

