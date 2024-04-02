class ExchangesRepresenter < DefaultRepresenter
  private

  def represent_object(exchange)
    {
      id: exchange.id,
      mic: exchange.mic,
      name: exchange.name
    }
  end
end
