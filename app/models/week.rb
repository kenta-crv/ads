class Week < ApplicationRecord
    validates :check_in_date, :check_out_date, presence: true
    validate :check_out_after_check_in
  
    private
  
    def check_out_after_check_in
      return if check_out_date.blank? || check_in_date.blank?
  
      if check_out_date <= check_in_date
        errors.add(:check_out_date, "はチェックイン日より後の日付に設定してください")
      end
    end
  end
  