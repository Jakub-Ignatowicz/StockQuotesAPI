class InstrumentsRepresenter < DefaultRepresenter
  private

  def represent_object(instrument) # Renamed to make sense in the context
    {
      id: instrument.id,
      ticker: instrument.ticker,
      name: instrument.name,
      mic: instrument.exchange.mic,
      exchange_id: instrument.exchange.id
    }
  end
end
