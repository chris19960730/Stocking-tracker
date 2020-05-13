class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:publishable_token],
      secret_token: Rails.application.credentials.iex_client[:secret_token],
      endpoint: "https://sandbox.iexapis.com/v1",
    )
    #client.logo(ticker_symbol)
    new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol), logo: ("https://storage.googleapis.com/iex/api/logos/" + ticker_symbol + ".png"))
  end

  def self.get_logo(ticker_symbol)
    #https://storage.googleapis.com/iex/api/logos/sticker.png
  end
end
