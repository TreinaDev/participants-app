FactoryBot.define do
  factory :speaker do
    first_name { "Sílvio" }
    last_name { "Santos" }
    sequence(:photo_url) { |n| "http://localhost:3000/speaker/#{n}/speaker.jpg" }
    sequence(:profile_link) { |n| "http://localhost:3000/speaker/#{n}/profile.jpg" }
    occupation { "Professor" }

    initialize_with do
      new(
        first_name: first_name,
        last_name: last_name,
        photo_url: photo_url,
        profile_link: profile_link,
        occupation: occupation
      )
    end
  end
end
