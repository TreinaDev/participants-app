class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :favorites
  has_many :tickets
  has_many :reminders
  has_one :profile
  has_many :likes
  has_many :comments

  before_validation :generate_code, on: :create

  validates :name, :last_name, :cpf, presence: true
  validates :code, length: { is: 6 }
  validates :code, uniqueness: true
  validates :cpf, uniqueness: { case_sensitive: false }
  validates :code, presence: true
  validate :cpf_valid

  after_create :create_profile

  def participates_in_event? (event_id)
    Ticket.where(user: self, event_id: event_id).any?
  end

  def has_event_reminder?(event)
    self.reminders.pluck(:event_id).include?(event)
  end

  def full_name
    self.name + " "  + self.last_name
  end

  private

  def generate_code
    loop do
      self.code = SecureRandom.alphanumeric(6)
      break unless User.exists?(code: self.code)
    end
  end

  def create_profile
    create_profile!()
  end

  def cpf_valid
    unless CPF.valid?(self.cpf)
      self.errors.add(:cpf, :invalid_cpf)
    end
  end
end
