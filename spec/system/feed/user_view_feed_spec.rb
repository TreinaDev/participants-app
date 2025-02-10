require 'rails_helper'

describe 'Usuário visita página de detalhes de um evento' do
  context 'e é participante do evento' do
    it 'vendo o feed existente' do
      event1 = build(:event, event_id: '1', name: 'DevWeek')
      event2 = build(:event, event_id: '2', name: 'Ruby')
      events = [ event1, event2 ]
      user1 = create(:user)
      user2 = create(:user)
      create(:ticket, event_id: event1.event_id, user: user1)
      create(:ticket, event_id: event1.event_id, user: user2)
      create(:ticket, event_id: event2.event_id, user: user2)
      post1 = create(:post, user: user1, event_id: event1.event_id.to_i, title: 'Título Teste 1')
      post2 = create(:post, user: user2, event_id: event1.event_id.to_i, title: 'Título Teste 2')
      create(:post, user: user2, event_id: event2.event_id.to_i, title: 'Título Teste 3')
      allow(Event).to receive(:request_event_by_id).and_return(event1)
      allow(Event).to receive(:all).and_return(events)
      batches = [ build(:batch, batch_id: '1') ]
      target_event_id = event1.event_id
      target_batch_id = batches[0].batch_id
      allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

      login_as user1
      visit root_path
      within('nav') do
        click_on 'Meus Eventos'
      end
      click_on 'Acessar Conteúdo do Evento'

      expect(page).to have_content('Feed')
      expect(page).to have_link('Título Teste 1')
      expect(page).to have_content("#{I18n.l(post1.created_at, format: :short)}")
      expect(page).to have_link('Título Teste 2')
      expect(page).to have_content("#{I18n.l(post2.created_at, format: :short)}")
      expect(page).not_to have_link('Título Teste 3')
    end

    it 'e não existem postagens no feed' do
      user = create(:user)
      event = build(:event, event_id: '1', name: 'DevWeek')
      allow(Event).to receive(:request_event_by_id).and_return(event)
      batches = [ build(:batch, name: 'Entrada - Meia') ]
      target_event_id = event.event_id
      target_batch_id = batches[0].batch_id
      ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
      allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

      login_as user
      visit my_event_path(id: event.event_id)
      click_on 'Feed'

      expect(page).to have_content('Feed')
      expect(page).to have_content 'Não existem postagens para esse evento'
    end
  end

  context 'e não participa do evento' do
    it 'e não consegue ver o feed do evento' do
      user = create(:user)
      event = build(:event, event_id: '1', name: 'DevWeek')
      create(:post, event_id: event.event_id.to_i, title: 'Título Teste')
      allow(Event).to receive(:request_event_by_id).and_return(event)

      login_as user
      visit event_by_name_path(event_id: event.event_id, name: event.name.parameterize, locale: :'pt-BR')

      expect(page).not_to have_content('Feed')
      expect(page).not_to have_link('Título Teste')
    end

    it 'e não esta autenticado' do
      event = build(:event, event_id: '1', name: 'DevWeek')
      create(:post, event_id: event.event_id.to_i, title: 'Título Teste')
      allow(Event).to receive(:request_event_by_id).and_return(event)

      visit event_by_name_path(event_id: event.event_id, name: event.name.parameterize, locale: :'pt-BR')

      expect(page).not_to have_content('Feed')
      expect(page).not_to have_link('Título Teste')
    end
  end
end
