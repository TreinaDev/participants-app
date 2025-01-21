class Ticket < ApplicationRecord
  belongs_to :user

  enum :status, confirmed: 0
  enum :payment_method, paypal: 0, pix: 1, credit_card: 2, bank_slip: 3, cash: 4
end
