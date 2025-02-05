require 'rails_helper'

describe 'Usuário acessa página de detalhes de comunicados oficiais' do
  it 'com sucesso' do
    event = build(:event, name: 'DevWeek')
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM!', event_id: event.event_id)
    announcement_two = build(:announcement, title: 'Taxa extra de R$500,00', description: 'NOVA TAXA: PAGUEM! PAGUEM COM A ALMA. PAGUEM OU O FUTURO NÃO LHES PERTENCERÁ. SEJAM PAGANTES E NÃO DEVEDORES', event_id: event.event_id)
    event.announcements << announcement << announcement_two
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    allow(Event).to receive(:all).and_return([ event ])
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Announcement).to receive(:request_announcement_by_id).and_return(announcement_two)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'DevWeek'
    within(".card-announcement-#{announcement_two.announcement_id}") do
      click_on 'Ver Comunicado'
    end
    expect(page).to have_content 'Taxa extra de R$500,00'
    expect(page).to have_content 'NOVA TAXA: PAGUEM! PAGUEM COM A ALMA. PAGUEM OU O FUTURO NÃO LHES PERTENCERÁ. SEJAM PAGANTES E NÃO DEVEDORES'
  end

  it 'e volta à página do evento' do
    event = build(:event, name: 'DevWeek')
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM!', event_id: event.event_id)
    announcement_two = build(:announcement, title: 'Taxa extra de R$500,00', description: 'NOVA TAXA: PAGUEM! PAGUEM COM A ALMA. PAGUEM OU O FUTURO NÃO LHES PERTENCERÁ. SEJAM PAGANTES E NÃO DEVEDORES', event_id: event.event_id)
    event.announcements << announcement << announcement_two
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    allow(Event).to receive(:all).and_return([ event ])
    allow(Event).to receive(:request_event_by_id).and_return(event, event)
    allow(Announcement).to receive(:request_announcement_by_id).and_return(announcement_two)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'DevWeek'
    within(".card-announcement-#{announcement_two.announcement_id}") do
      click_on 'Ver Comunicado'
    end
    click_on 'Voltar'

    expect(current_path).to eq event_by_name_path(event_id: event.event_id, name: event.name.parameterize, locale: 'pt-BR')
  end
end
