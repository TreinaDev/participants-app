# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(name: 'Master', last_name: 'Teste', email: 'master@email.com', password: '123456', cpf: CPF.generate)
profile = user.profile
profile.update(city: 'Cidade Teste', state: 'Estado Teste')
SocialMedium.create(name: 'Instagram')
SocialMedium.create(name: 'Linkedin')
SocialMedium.create(name: 'GitHub')
SocialMedium.create(name: 'Reddit')
SocialMedium.create(name: 'Facebook')