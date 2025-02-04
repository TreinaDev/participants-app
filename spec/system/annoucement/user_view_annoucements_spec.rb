require 'rails_helper'

describe 'Usuário acessa feed do evento e vê comunicados oficiais' do
  it 'com sucesso' do
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', content: 'NOVA TAXA: PAGUEM!')

    event = build(:event, name: 'DevWeek', announcements: [ announcement ])
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    allow(Event).to receive(:all).and_return([ event ])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'DevWeek'

    expect(page).to have_content 'Taxa extra de R$100,00'
    expect(page).to have_content 'NOVA TAXA: PAGUEM!'
  end
end
