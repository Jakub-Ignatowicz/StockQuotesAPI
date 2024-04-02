require 'rails_helper'

describe Exchange, type: :model do
  describe 'validations' do
    it 'is invalid without a MIC' do
      exchange = Exchange.new(name: 'Test Exchange')
      expect(exchange).to_not be_valid
    end
    it 'is invalid with a MIC shorter than 4 characters' do
      exchange = Exchange.new(mic: 'ABC', name: 'Test Exchange')
      expect(exchange).to_not be_valid
    end

    it 'is invalid with a MIC longer than 4 characters' do
      exchange = Exchange.new(mic: 'ABCDE', name: 'Test Exchange')
      expect(exchange).to_not be_valid
    end
    it 'is invalid with a MIC containing special characters' do
      exchange = Exchange.new(mic: 'AB!3', name: 'Test Exchange')
      expect(exchange).to_not be_valid
    end
    it 'is invalid without a name' do
      exchange = Exchange.new(mic: 'ABCD')
      expect(exchange).to_not be_valid
    end
    it 'is invalid with a name exceeding 256 characters' do
      long_name = 'a' * 257
      exchange = Exchange.new(mic: 'ABCD', name: long_name)
      expect(exchange).to_not be_valid
    end
    it 'upcases the MIC before saving' do
      exchange = Exchange.create(mic: 'test', name: 'Test Exchange')
      expect(exchange.mic).to eq 'TEST'
    end
  end

  describe 'concurrency' do
    it 'throws error while renaming twice same record' do
      exchange = FactoryBot.create(:exchange)
      exchange.save

      first_exchange = Exchange.first
      second_exchange = Exchange.first

      first_exchange.name = 'a'
      first_exchange.save

      second_exchange.name = 'b'
      expect { second_exchange.save! }.to raise_error(ActiveRecord::StaleObjectError)
    end
  end
end
