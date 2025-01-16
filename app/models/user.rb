class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :favorites
  has_one :profile

  validates :name, :last_name, :cpf, presence: true
  validates :cpf, uniqueness: { case_sensitive: false }
  validate :cpf_valid

  private

  def cpf_valid
    unless CPF.valid?(self.cpf)
      self.errors.add(:cpf, :invalid_cpf)
    end
  end
end
