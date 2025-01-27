require 'rails_helper'

describe 'Usuário acessa ingressos de um evento' do
  it 'pela página de meus eventos' do
    user = create(:user)
    batches = [ {
      id: 1,
      name: 'Entrada - Meia',
      limit_tickets: 20,
      start_date: 5.days.ago.to_date,
      value: 20.00,
      end_date: 2.month.from_now.to_date,
      event_id: 1
      },
      {
      id: 2,
      name: 'Entrada - PDC',
      limit_tickets: 30,
      start_date: 5.day.ago.to_date,
      value: 10.00,
      end_date: 10.day.from_now.to_date,
      event_id: 1
      }
    ]
    event = build(:event, name: 'DevWeek', batches: batches)
    events = [ event ]
    create(:ticket, event_id: event.event_id, batch_id: 1, user: user, date_of_purchase: 5.days.ago.to_date)
    create(:ticket, event_id: event.event_id, batch_id: 2, user: user, date_of_purchase: 15.days.ago.to_date)
    allow(Event).to receive(:request_my_events).and_return(events)

    login_as user
    visit root_path
    click_on 'Meus Eventos'
    click_on 'DevWeek'

    expect(page).to have_content 'Entrada - Meia'
    expect(page).to have_content "#{5.days.ago.to_date}"
    expect(page).to have_content 'Entrada - PDC'
    expect(page).to have_content "#{15.days.ago.to_date}"
  end
end
