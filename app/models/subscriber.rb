class Subscriber < ApplicationRecord
  validates :endpoint, presence: true, uniqueness: true
end
