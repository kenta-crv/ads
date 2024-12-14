module PriceCalculator
  NORMAL_PRICE_PER_NIGHT = 39500.00
  PEAK_PRICE_PER_NIGHT = 55000.00
  MINIMUM_NIGHTS = 3
  INITIAL_COST = 9000.00

  PEAK_SEASONS = [
    (Date.new(Date.today.year, 12, 20)..Date.new(Date.today.year + 1, 1, 10)),
    (Date.new(Date.today.year, 1, 25)..Date.new(Date.today.year, 2, 10)),
    (Date.new(Date.today.year, 3, 20)..Date.new(Date.today.year, 4, 10)),
    (Date.new(Date.today.year, 4, 28)..Date.new(Date.today.year, 5, 10)),
    (Date.new(Date.today.year, 7, 1)..Date.new(Date.today.year, 8, 31))
  ]

  def self.calculate_total_price(check_in_date, check_out_date)
    num_days = (check_out_date - check_in_date).to_i

    if num_days < MINIMUM_NIGHTS
      return { error: "宿泊日数は最低#{MINIMUM_NIGHTS}泊以上必要です。" }
    end

    normal_days = 0
    peak_days = 0

    num_days.times do |i|
      current_date = check_in_date + i.days
      if PEAK_SEASONS.any? { |season| season.cover?(current_date) }
        peak_days += 1
      else
        normal_days += 1
      end
    end

    total_price = (normal_days * NORMAL_PRICE_PER_NIGHT) + (peak_days * PEAK_PRICE_PER_NIGHT) + INITIAL_COST

    {
      normal_days: normal_days,
      peak_days: peak_days,
      total_price: total_price,
      normal_price_per_night: NORMAL_PRICE_PER_NIGHT,
      peak_price_per_night: PEAK_PRICE_PER_NIGHT,
      initial_cost: INITIAL_COST
    }
  end

  def self.format_price(price)
    ActionController::Base.helpers.number_with_delimiter(price)
  end
end
