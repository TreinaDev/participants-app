require "rails_helper"

describe 'Usuário acessa página incial' do
  context 'não autenticado' do
    it 'com sucesso' do
      visit root_path

      expect(page).to have_content 'Seu Próximo Evento Começa Aqui'
      expect(page).to have_content 'Prepare-se para Aprender e se Inspirar!'
      within('.main-links') do
        expect(page).to have_link 'Eventos'
      end
      expect(page).to have_css 'img[src="https://images.pexels.com/photos/2774556/pexels-photo-2774556.jpeg?auto=compress&cs=tinysrgb&w=600"]'
    end

    it 'e vê seção de recursos principais' do
      visit root_path

      expect(page).to have_content 'Recursos Principais'
      expect(page).to have_css 'h3', text: 'Ingressos Digitais'
      expect(page).to have_css 'p', text: 'QR Code único para cada ingresso com controle de acesso inteligente para múltiplos dias de evento.'
      expect(page).to have_css 'h3', text: 'Feed Social'
      expect(page).to have_css 'p', text: 'Interaja com outros participantes, compartilhe experiências e receba atualizações oficiais do evento.'
      expect(page).to have_css 'h3', text: 'Lembretes Inteligentes'
      expect(page).to have_css 'p', text: 'Receba notificações quando as vendas de ingressos iniciarem para seus eventos favoritos.'
    end

    it 'e vê seção de convite' do
      visit root_path

      expect(page).to have_css 'h2', text: 'Comece a usar hoje mesmo'
      expect(page).to have_css 'p', text: 'Junte-se a milhares de pessoas que já estão conectadas através de eventos incríveis.'
      expect(page).to have_link 'Inscrever-se'
    end

    it 'e vê o footer' do
      visit root_path

      within('footer') do
        expect(page).to have_content '© Copyright 2025 Participants | Todos os direitos reservados'
        expect(page).to have_css 'text', text: 'Participants'
      end
    end

    it 'e navega até a página de eventos' do
      visit root_path
      within('.main-links') do
        click_on 'Eventos'
      end

      expect(current_path).to eq events_path(locale: 'pt-BR')
    end

    it 'e navega até a página de cadastro' do
      visit root_path
      within('.links-sign-up') do
        click_on 'Inscrever-se'
      end

      expect(current_path).to eq new_user_registration_path
    end
  end

  context 'autenticado' do
    it 'acessa página root' do
      user = create(:user)

      login_as user
      visit root_path

      expect(current_path).to eq root_path
    end

    it 'e acessa dashboard' do
      user = create(:user)

      login_as user
      visit root_path
      click_on 'Participants'

      expect(current_path).to eq dashboard_index_path
    end
  end
end
