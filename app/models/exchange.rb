class Exchange < ApplicationRecord
  validates :mic, presence: true, length: { is: 4 },
                  format: { with: /\A[a-zA-Z0-9]+\z/, message: 'mic can only contain letters and numbers' }
  validates :name, presence: true, length: { maximum: 256 }

  has_many :instruments

  before_save :uppercase_mic

  def uppercase_mic
    self.mic = mic.upcase if mic
  end
end
