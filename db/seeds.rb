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
SocialMedium.create(name: 'Instagram', icon: Rails.root.join('spec', 'support', 'instagram.svg'))
SocialMedium.create(name: 'Linkedin', icon: Rails.root.join('spec', 'support', 'linkedin.svg'))
SocialMedium.create(name: 'GitHub', icon: Rails.root.join('spec', 'support', 'github.svg'))
SocialMedium.create(name: 'Reddit', icon: Rails.root.join('spec', 'support', 'reddit.svg'))
SocialMedium.create(name: 'Facebook', icon: Rails.root.join('spec', 'support', 'facebook.svg'))
