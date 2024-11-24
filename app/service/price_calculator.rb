# app/services/price_calculator.rb
module PriceCalculator
    NORMAL_PRICE_PER_NIGHT = 55000.00
    PEAK_PRICE_PER_NIGHT = 88000.00
  
    def self.calculate_total_price(check_in_date, check_out_date)
      num_days = (check_out_date - check_in_date).to_i
      normal_days = num_days # 仮にすべて通常日とする
      peak_days = 0          # ピーク日を含まないと仮定
      total_price = (normal_days * NORMAL_PRICE_PER_NIGHT) + (peak_days * PEAK_PRICE_PER_NIGHT)
  
      { normal_days: normal_days, peak_days: peak_days, total_price: total_price }
    end
  end
  