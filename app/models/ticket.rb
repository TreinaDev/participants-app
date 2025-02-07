class Ticket < ApplicationRecord
  belongs_to :user

  enum :payment_method, paypal: 0, pix: 1, credit_card: 2, bank_slip: 3, cash: 4

  validates :batch_id, :payment_method, presence: true
  validates :token, uniqueness: true
  validates :token, length: { is: 36 }

  before_validation :set_ticket_token, :set_date_of_purchase, on: :create
  before_save :mark_status_as_confirmed

  enum :usage_status, not_the_date: 0, usable: 2, used: 4

  private
  def set_ticket_token
    self.token = SecureRandom.alphanumeric(36)
  end

  def set_date_of_purchase
    self.date_of_purchase = DateTime.now
  end

  def mark_status_as_confirmed
    self.status_confirmed = true
  end
end
