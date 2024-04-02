require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:instrument) do
    FactoryBot.create(:instrument)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      quote = Quote.new(time: Time.now, open: 10.0, close: 11.0, high: 12.0, low: 9.0, volume: 1000,
                        instrument:)
      expect(quote).to be_valid
    end

    it 'is invalid without time' do
      quote = Quote.new(open: 10.0, close: 11.0, high: 12.0, low: 9.0, volume: 1000, instrument:)
      expect(quote).not_to be_valid
    end

    it 'is invalid without open, close, high, low, and volume' do
      quote = Quote.new(time: Time.now, instrument:)
      expect(quote).not_to be_valid
    end

    it 'is invalid with non-numeric open, close, high, low, and volume' do
      quote = Quote.new(time: Time.now, open: 'invalid', close: 'invalid', high: 'invalid', low: 'invalid',
                        volume: 'invalid', instrument:)
      expect(quote).not_to be_valid
    end

    it 'is invalid with negative volume' do
      quote = Quote.new(time: Time.now, open: 10.0, close: 11.0, high: 12.0, low: 9.0, volume: -1000,
                        instrument:)
      expect(quote).not_to be_valid
    end

    it 'is valid with valid attributes' do
      quote = Quote.new(time: Time.now, open: 10.0, close: 11.0, high: 12.0, low: 9.0, volume: 1000,
                        instrument:)
      expect(quote).to be_valid
    end

    it 'is invalid without time' do
      quote = Quote.new(open: 10.0, close: 11.0, high: 12.0, low: 9.0, volume: 1000, instrument:)
      expect(quote).not_to be_valid
    end

    it 'is invalid without open, close, high, low, and volume' do
      quote = Quote.new(time: Time.now, instrument:)
      expect(quote).not_to be_valid
    end

    it 'is invalid with non-numeric open, close, high, low, and volume' do
      quote = Quote.new(time: Time.now, open: 'invalid', close: 'invalid', high: 'invalid', low: 'invalid',
                        volume: 'invalid', instrument:)
      expect(quote).not_to be_valid
    end

    it 'is invalid with negative volume' do
      quote = Quote.new(time: Time.now, open: 10.0, close: 11.0, high: 12.0, low: 9.0, volume: -1000,
                        instrument:)
      expect(quote).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an instrument' do
      association = described_class.reflect_on_association(:instrument)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'concurrency' do
    it 'throws error while adding twice to same record' do
      quote = Quote.new(time: Time.now, open: 0.0, close: 0.0, high: 0.0, low: 0.0, volume: 0,
                        instrument:)
      quote.save

      first_quote = Quote.first
      second_quote = Quote.first

      first_quote.volume += 1
      first_quote.save

      second_quote.volume += 1
      expect { second_quote.save! }.to raise_error(ActiveRecord::StaleObjectError)
    end
  end
end
