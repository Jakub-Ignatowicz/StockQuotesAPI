class QuotesRepresenter < DefaultRepresenter
  private

  def represent_object(quote)
    {
      id: quote.id,
      instrument_id: quote.instrument.id,
      ticker: quote.instrument.ticker,
      mic: quote.instrument.exchange.mic,
      time: quote.time,
      low: quote.low.to_f,
      high: quote.high.to_f,
      open: quote.open.to_f,
      close: quote.close.to_f,
      volume: quote.volume
    }
  end
end
