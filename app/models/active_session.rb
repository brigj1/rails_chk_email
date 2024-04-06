class ActiveSession < ApplicationRecord
  belongs_to :shopper

  has_secure_token :remember_token
end
