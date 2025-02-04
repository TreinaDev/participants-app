require 'rails_helper'

describe 'Usuário acessa a página de conteúdos do evento' do
  it 'com sucesso, por participar do evento' do
    user = create(:user)
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
    event = build(:event, name: 'DevWeek', batches: batches, event_id: '1')
    events = [ event ]
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1', user: user)
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    login_as user
    get my_event_path(event.event_id, locale: :'pt-BR')

    expect(response.status).to eq 200
  end
  it 'e falha, por não participar do evento' do
    user = create(:user)
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
    event = build(:event, name: 'DevWeek', batches: batches, event_id: '1')
    events = [ event ]
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    login_as user
    get my_event_path(event.event_id, locale: :'pt-BR')

    expect(response.status).to eq 302
    expect(flash[:alert]).to eq 'Você não participa deste evento!'
  end

  it 'e falha, por não estar logado' do
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
    event = build(:event, name: 'DevWeek', batches: batches, event_id: '1')
    events = [ event ]

    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    get my_event_path(event.event_id, locale: :'pt-BR')

    expect(response.status).to eq 302
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end
end
