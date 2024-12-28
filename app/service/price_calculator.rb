module PriceCalculator
  NORMAL_PRICE_PER_NIGHT = 25000.00
  PEAK_PRICE_PER_NIGHT = 35000.00
  MINIMUM_NIGHTS = 3
  INITIAL_COST = 12500.00

  WEEKLY_NORMAL_PRICE_PER_NIGHT = 20000.00
  WEEKLY_MINIMUM_NIGHTS = 7

  MONTHLY_NORMAL_PRICE_PER_NIGHT = 16000.00
  MONTHLY_MINIMUM_NIGHTS = 30

  PEAK_SEASONS = [
    (Date.new(Date.today.year, 12, 20)..Date.new(Date.today.year + 1, 1, 10)),
    (Date.new(Date.today.year, 1, 25)..Date.new(Date.today.year, 2, 10)),
    (Date.new(Date.today.year, 3, 20)..Date.new(Date.today.year, 4, 10)),
    (Date.new(Date.today.year, 4, 28)..Date.new(Date.today.year, 5, 10)),
    (Date.new(Date.today.year, 7, 1)..Date.new(Date.today.year, 8, 31))
  ]

  def self.calculate_total_price(check_in_date, check_out_date, mode: :estimate)
    num_days = (check_out_date - check_in_date).to_i

    case mode
    when :estimate
      minimum_nights = MINIMUM_NIGHTS
      normal_price_per_night = NORMAL_PRICE_PER_NIGHT
      peak_price_per_night = PEAK_PRICE_PER_NIGHT
    when :weekly
      minimum_nights = WEEKLY_MINIMUM_NIGHTS
      normal_price_per_night = WEEKLY_NORMAL_PRICE_PER_NIGHT
      peak_price_per_night = nil
    when :monthly
      minimum_nights = MONTHLY_MINIMUM_NIGHTS
      normal_price_per_night = MONTHLY_NORMAL_PRICE_PER_NIGHT
      peak_price_per_night = nil
    else
      return { error: "無効な予約モードです。" }
    end

    if num_days < minimum_nights
      return { error: "#{minimum_nights}泊以上で日数を選択してください。" }
    end

    total_price = (num_days * normal_price_per_night) + INITIAL_COST

    {
      normal_days: num_days,
      peak_days: 0, # Weekly/Monthlyにはピーク日は存在しない
      total_price: total_price,
      normal_price_per_night: normal_price_per_night,
      peak_price_per_night: peak_price_per_night,
      initial_cost: INITIAL_COST
    }
  end

  def self.format_price(price)
    ActionController::Base.helpers.number_with_delimiter(price)
  end
end
