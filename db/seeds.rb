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
FactoryBot.create(:ticket, user: user, event_id: 1, status_confirmed: true)
FactoryBot.create(:ticket, user: user, event_id: 2, status_confirmed: true)
FactoryBot.create(:ticket, user: user, event_id: 3, status_confirmed: true)
FactoryBot.create(:ticket, user: user, event_id: 4, status_confirmed: true)
FactoryBot.create(:post, title: 'Cozinhando frutos do mar', event_id: 1, created_at: 1.days.ago)
FactoryBot.create(:post, title: 'Aprendendo a fritar ovo', event_id: 1, created_at: 2.days.ago)
FactoryBot.create(:post, title: 'Miojo com atum', event_id: 1, created_at: 3.days.ago)
FactoryBot.create(:post, title: 'Sei fazer feijoada', event_id: 1, created_at: 4.days.ago)
FactoryBot.create(:post, title: 'Quem foi que inventou Java?', event_id: 2, created_at: 1.days.ago)
FactoryBot.create(:post, title: 'O Rails pode cair duas vezes num mesmo lugar?', event_id: 2, created_at: 2.days.ago)
FactoryBot.create(:post, title: 'Quantos anos são necessários para aprender C++?', event_id: 2, created_at: 3.days.ago)
FactoryBot.create(:post, title: 'CSS: ame-o ou deixe-o', event_id: 2, created_at: 4.days.ago)
FactoryBot.create(:post, title: 'Português: um idioma problemático', event_id: 3, created_at: 1.days.ago)
FactoryBot.create(:post, title: 'É baiano ou bahiano?', event_id: 3, created_at: 2.days.ago)
FactoryBot.create(:post, title: 'Devs que não tomam café', event_id: 4, created_at: 1.days.ago)
FactoryBot.create(:post, title: 'Devs que acordam 5 da manhã', event_id: 4, created_at: 2.days.ago)
