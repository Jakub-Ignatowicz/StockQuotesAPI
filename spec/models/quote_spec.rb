require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:instrument) do
    Instrument.create(ticker: 'ABC', name: 'Test Instrument',
                      exchange: Exchange.create(mic: 'TEST', name: 'Test Exchange'))
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
end

