FactoryBot.define do
  factory :user do
    name { 'André' }
    last_name { "Kanamura" }
    sequence(:email) { |n| "person#{n}@example.com" }
    cpf { CPF.generate }
    password { "12345678" }

    factory :user_with_favorites do 
      transient do
        favorites_count { 2 }
      end
      
      favorites do 
        Array.new(favorites_count) {association(:favorite, user: instance)}
      end
    end

  end
end
