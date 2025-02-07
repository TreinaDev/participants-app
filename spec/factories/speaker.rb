FactoryBot.define do
  factory :speaker do
    first_name { "Sílvio" }
    last_name { "Santos" }
    sequence(:profile_image_url) { |n| "http://localhost:3000/speaker/#{n}/speaker.jpg" }
    sequence(:profile_url) { |n| "http://localhost:3000/speaker/#{n}/profile.jpg" }
    role { "Professor" }

    initialize_with do
      new(
        first_name: first_name,
        last_name: last_name,
        profile_image_url: profile_image_url,
        profile_url: profile_url,
        role: role
      )
    end
  end
end
