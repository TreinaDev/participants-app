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

  validates :name, :last_name, :cpf, presence: true
  validates :cpf, uniqueness: { case_sensitive: false }
  validate :cpf_valid

  after_create :create_profile

  def participates_in_event? (event_id)
    Ticket.where(user: self, event_id: event_id).any?
  end

  def full_name
    self.name + " "  + self.last_name
  end

  private

  def create_profile
    create_profile!()
  end

  def cpf_valid
    unless CPF.valid?(self.cpf)
      self.errors.add(:cpf, :invalid_cpf)
    end
  end
end
