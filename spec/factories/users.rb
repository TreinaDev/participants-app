FactoryBot.define do
  factory :user do
    name { 'André' }
    last_name { "Kanamura" }
    sequence(:email) { |n| "person#{n}@example.com" }
    cpf { CPF.generate }
    password { "12345678" }
    code { SecureRandom.alphanumeric(6) }

    factory :user_with_favorites do
      transient do
        favorites_count { 2 }
      end
      favorites do
        Array.new(favorites_count) { association(:favorite, user: instance) }
      end
    end

    factory :user_with_tickets do
      transient do
        tickets_count { 1 }
      end
      tickets do
        Array.new(tickets_count) { association(:ticket, user: instance) }
      end
    end
  end
end
