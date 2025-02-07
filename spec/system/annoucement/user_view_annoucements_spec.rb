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
    batches = [ {
        batch_id: '1',
        name: 'Entrada - Meia',
        limit_tickets: 20,
        start_date: 5.days.ago.to_date,
        value: 20.00,
        end_date: 2.month.from_now.to_date,
        event_id: '1'
      }
    ]
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with(event.event_id, '1').and_return(batches[0])

    login_as user
    visit root_path
    within('nav') do
      click_on 'Meus Eventos'
    end
    click_on 'Acessar Conteúdo do Evento'

    expect(page).to have_content 'Taxa extra de R$100,00'
    expect(page).to have_content 'NOVA TAXA: PAGUEM!'
  end
end
