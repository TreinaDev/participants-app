require 'rails_helper'

describe 'Usuário acessa página de detalhes de comunicados oficiais' do
  it 'com sucesso' do
    user = create(:user)
    event = build(:event, name: 'DevWeek')
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM!')
    announcement_two = build(:announcement, title: 'Taxa extra de R$500,00', description: 'NOVA TAXA: PAGUEM! PAGUEM COM A ALMA. PAGUEM OU O FUTURO NÃO LHES PERTENCERÁ. SEJAM PAGANTES E NÃO DEVEDORES', announcement_id: 'ABGJLJ7')
    allow(Event).to receive(:all).and_return([ event ])
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Announcement).to receive(:request_announcements_by_event_id).and_return([ announcement, announcement_two ])
    allow(Announcement).to receive(:request_announcement_by_id).and_return(announcement_two)
    batches = [ build(:batch) ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit root_path
    within('nav') do
      click_on 'Meus Eventos'
    end
    click_on 'Acessar Conteúdo do Evento'
    within(".card-announcement-#{announcement_two.announcement_id}") do
      click_on 'Ver Comunicado'
    end

    expect(page).to have_content 'Taxa extra de R$500,00'
    expect(page).to have_content 'NOVA TAXA: PAGUEM! PAGUEM COM A ALMA. PAGUEM OU O FUTURO NÃO LHES PERTENCERÁ. SEJAM PAGANTES E NÃO DEVEDORES'
  end

  it 'e volta à página do evento' do
    user = create(:user)
    event = build(:event, name: 'DevWeek')
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM!')
    announcement_two = build(:announcement, title: 'Taxa extra de R$500,00', description: 'NOVA TAXA: PAGUEM! PAGUEM COM A ALMA. PAGUEM OU O FUTURO NÃO LHES PERTENCERÁ. SEJAM PAGANTES E NÃO DEVEDORES', announcement_id: 'ABGJLJ7')
    allow(Event).to receive(:all).and_return([ event ])
    allow(Event).to receive(:request_event_by_id).and_return(event, event)
    allow(Announcement).to receive(:request_announcements_by_event_id).and_return([ announcement, announcement_two ])
    allow(Announcement).to receive(:request_announcement_by_id).and_return(announcement_two)
    batches = [ build(:batch) ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit root_path
    within('nav') do
      click_on 'Meus Eventos'
    end
    click_on 'Acessar Conteúdo do Evento'
    within(".card-announcement-#{announcement_two.announcement_id}") do
      click_on 'Ver Comunicado'
    end
    click_on 'Voltar'

    expect(current_path).to eq my_event_path(id: event.event_id, locale: :'pt-BR')
  end

  it 'e deve estar logado' do
    event = build(:event, name: 'DevWeek')
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM!')
    create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:all).and_return([ event ])
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Announcement).to receive(:request_announcements_by_event_id).and_return([ announcement ])

    visit event_announcement_path(event_id: event.event_id, id: announcement.announcement_id)

    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ter um ingresso comprado' do
    event = build(:event, name: 'DevWeek')
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM!')
    announcement_two = build(:announcement, title: 'Taxa extra de R$500,00', description: 'NOVA TAXA: PAGUEM! PAGUEM COM A ALMA. PAGUEM OU O FUTURO NÃO LHES PERTENCERÁ. SEJAM PAGANTES E NÃO DEVEDORES')
    user = create(:user)
    allow(Event).to receive(:all).and_return([ event ])
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Announcement).to receive(:request_announcements_by_event_id).and_return([ announcement_two, announcement ])

    login_as user
    visit event_announcement_path(event_id: event.event_id, id: announcement.announcement_id)

    expect(current_path).to eq root_path
    expect(page).to have_content "Você não participa deste evento"
  end
end
