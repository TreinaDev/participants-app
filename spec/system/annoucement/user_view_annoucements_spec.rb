require 'rails_helper'

describe 'Usuário acessa feed do evento e vê comunicados oficiais' do
  it 'com sucesso' do
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM!')

    event = build(:event, name: 'DevWeek')
    event.announcements << announcement
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

    save_page
    expect(page).to have_content 'Taxa extra de R$100,00'
    expect(page).to have_content 'NOVA TAXA: PAGUEM!'
    expect(page).to have_link 'Ver Comunicado'
  end

  it 'até 50 caracteres do conteúdo' do
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM OU SERÃO PRIVADOS DA MELHOR EXPERIÊNCIA DE TODA A SUA VIDA OXENTE. É PAGAR OU LARGAR. ESCOLHA LOGO!!!!!!')

    event = build(:event, name: 'DevWeek')
    event.announcements << announcement
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

    expect(page).not_to have_content 'NOVA TAXA: PAGUEM OU SERÃO PRIVADOS DA MELHOR EXPERIÊNCIA DE TODA A SUA VIDA OXENTE. É PAGAR OU LARGAR. ESCOLHA LOGO!!!!!!'
    expect(page).to have_content 'NOVA TAXA: PAGUEM OU SERÃO PRIVADOS DA MELHOR E..'
  end

  it 'se tiver um ingresso' do
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM!')

    event = build(:event, name: 'DevWeek')
    event.announcements << announcement
    allow(Event).to receive(:all).and_return([ event ])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'DevWeek'

    expect(page).not_to have_content 'Taxa extra de R$100,00'
    expect(page).not_to have_content 'NOVA TAXA: PAGUEM!'
    expect(page).not_to have_link 'Ver  Comunicado'
  end
end
