module PriceCalculator
  PRICE_OPTIONS = {
    "0円プラン" => 0,
    "59,800円プラン" => 59800,
    "99,800円プラン" => 99800
  }.freeze

  def self.calculate_total_price(choice)
    price = choice.to_i
    unless PRICE_OPTIONS.values.include?(price)
      return { error: "無効なプランが選択されました。" }
    end

    { total_price: price }
  end

  def self.format_price(price)
    ActionController::Base.helpers.number_with_delimiter(price)
  end
end
