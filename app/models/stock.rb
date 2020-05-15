class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:publishable_token],
      secret_token: Rails.application.credentials.iex_client[:secret_token],
      endpoint: "https://sandbox.iexapis.com/v1",
    )
    begin
      new(ticker: ticker_symbol.upcase, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol), logo: ("https://storage.googleapis.com/iex/api/logos/" + ticker_symbol.upcase + ".png"))
    rescue => exception
      nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.get_logo(ticker_symbol)
    #https://storage.googleapis.com/iex/api/logos/sticker.png
  end
end
