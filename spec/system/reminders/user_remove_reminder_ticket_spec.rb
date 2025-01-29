require 'rails_helper'

describe 'Usuário remove lembrete' do
  it 'e deve estar logado' do
    events = []
    events << build(:event, name: 'Evento Teste 01')
    events << build(:event, name: 'Evento Teste 02')
    create(:reminder, event_id: events[0].event_id)
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'Evento Teste 01'

    expect(page).not_to have_button 'Remover Lembrete'
  end

  it 'e o lembrete deve pertencer àquele evento' do
    user = create(:user)
    events = []
    events << build(:event, name: 'Evento Teste 01')
    events << build(:event, name: 'Evento Teste 02')
    create(:reminder, event_id: events[1].event_id)
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    login_as user
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'Evento Teste 01'

    expect(page).not_to have_button 'Remover Lembrete'
  end

  it 'com sucesso' do
    user = create(:user)
    event = build(:event)
    create(:reminder, event_id: event.event_id, user: user)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')
    click_on 'Remover Lembrete'

    expect(page).to have_content 'Lembrete removido com sucesso'
    expect(page).to have_button 'Adicionar Lembrete'
    expect(page).not_to have_button 'Remover Lembrete'
  end
end
