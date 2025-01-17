FactoryBot.define do
  factory :user do
    name { 'André' }
    last_name { "Kanamura" }
    sequence(:email) { |n| "person#{n}@example.com" }
    cpf { CPF.generate }
    password { "12345678" }
  end
end
