require 'rails_helper'

describe 'Participante adciona nova postagem a um evento' do
  it 'e vê formulário' do
    event = build(:event, event_id: 1, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Event).to receive(:all).and_return([ event ])

    login_as user
    visit root_path
    click_on 'Eventos'
    click_on 'DevWeek'
    click_on 'Adicionar Postagem'

    expect(page).to have_content 'Nova Postagem'
    expect(page).to have_field 'Título'
    expect(page).to have_field 'Conteúdo'
    expect(page).to have_button 'Salvar'
  end

  xit 'pela tela de detalhes do evento' do
    event = build(:event, event_id: 1, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    allow(Event).to receive(:all).and_return([ event ])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    expect(page).to have_link 'Adicionar Postagem'
  end
end
