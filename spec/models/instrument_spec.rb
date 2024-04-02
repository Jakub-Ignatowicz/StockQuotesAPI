require 'rails_helper'

describe Instrument, type: :model do
  let(:exchange) { Exchange.create(mic: 'TEST', name: 'Test Exchange') }

  describe 'validations' do
    it 'is valid with a valid ticker and name' do
      instrument = Instrument.new(ticker: 'ABC123', name: 'Test Instrument', exchange:)
      expect(instrument).to be_valid
    end

    it 'is valid with a ticker containing only letters and numbers' do
      instrument = Instrument.new(ticker: 'ABC123', name: 'Test Instrument', exchange:)
      expect(instrument).to be_valid
    end

    it 'is invalid without an associated exchange' do
      instrument = Instrument.new(ticker: 'ABC123', name: 'Test Instrument')
      expect(instrument).to_not be_valid
    end

    it 'is invalid without a ticker' do
      instrument = Instrument.new(name: 'Test Instrument', exchange:)
      expect(instrument).to_not be_valid
    end

    it 'is invalid with a ticker longer than 20 characters' do
      instrument = Instrument.new(ticker: 'A' * 21, name: 'Test Instrument', exchange:)
      expect(instrument).to_not be_valid
    end

    it 'is invalid with a ticker containing special characters' do
      instrument = Instrument.new(ticker: 'ABC@123', name: 'Test Instrument', exchange:)
      expect(instrument).to_not be_valid
    end

    it 'is invalid without a name' do
      instrument = Instrument.new(ticker: 'ABC123', exchange:)
      expect(instrument).to_not be_valid
    end

    it 'is invalid with a name exceeding 256 characters' do
      long_name = 'a' * 257
      instrument = Instrument.new(ticker: 'ABC123', name: long_name, exchange:)
      expect(instrument).to_not be_valid
    end
  end

  describe 'callbacks' do
    it 'upcases the ticker before saving' do
      instrument = Instrument.create(ticker: 'test', name: 'Test Instrument', exchange:)
      expect(instrument.ticker).to eq 'TEST'
    end
  end
  describe 'associations' do
    it 'belongs to an exchange' do
      association = described_class.reflect_on_association(:exchange)
      expect(association.macro).to eq :belongs_to
    end
  end
  describe 'concurrency' do
    it 'throws error while renaming twice same record' do
      instrument = FactoryBot.create(:instrument)
      instrument.save

      first_instrument = Instrument.first
      second_instrument = Instrument.first

      first_instrument.name = 'a'
      first_instrument.save

      second_instrument.name = 'b'
      expect { second_instrument.save! }.to raise_error(ActiveRecord::StaleObjectError)
    end
  end
end
