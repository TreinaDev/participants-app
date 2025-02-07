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
    expect(page).to have_link 'Ver Comunicado'
  end

  it 'e vê até 50 caracteres do conteúdo' do
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM OU SERÃO PRIVADOS DA MELHOR EXPERIÊNCIA DE TODA A SUA VIDA OXENTE. É PAGAR OU LARGAR. ESCOLHA LOGO!!!!!!')

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

    expect(page).not_to have_content announcement.description
    expect(page).to have_content announcement.description.truncate(50)
  end

  it 'e não tem um ingresso' do
    user = create(:user)
    announcement = build(:announcement, title: 'Taxa extra de R$100,00', description: 'NOVA TAXA: PAGUEM!')

    event = build(:event, name: 'DevWeek')
    event.announcements << announcement
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
    visit my_event_path(id: event.event_id, locale: :'pt-BR')

    expect(page).to have_content 'Você não participa deste evento'
  end
end
