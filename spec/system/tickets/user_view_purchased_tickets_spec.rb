require 'rails_helper'

describe 'Usuário acessa ingressos de um evento' do
  it 'pela página de meus eventos' do
    user = create(:user)
    batches = [ {
      batch_id: '1',
      name: 'Entrada - Meia',
      limit_tickets: 20,
      start_date: 5.days.ago.to_date,
      value: 20.00,
      end_date: 2.month.from_now.to_date,
      event_id: '1'
      },
      {
      batch_id: '2',
      name: 'Entrada - PDC',
      limit_tickets: 30,
      start_date: 5.day.ago.to_date,
      value: 10.00,
      end_date: 10.day.from_now.to_date,
      event_id: '1'
    }
    ]
    event = build(:event, name: 'DevWeek', batches: batches, event_id: '1')
    events = [ event ]
    allow(SecureRandom).to receive(:alphanumeric).with(36).and_return('AAAAAABBBBBBCCCCCCDDDDDDDDDDDDDDDDDD')
    travel_to 5.days.ago do
      create(:ticket, event_id: event.event_id, batch_id: '1', user: user)
    end
    allow(SecureRandom).to receive(:alphanumeric).with(36).and_return('AAAAAABBBBBBCCCCCCEEEEEEEEEEEEEEEEEE')
    travel_to 10.days.ago do
      create(:ticket, event_id: event.event_id, batch_id: '1', user: user)
    end
    allow(SecureRandom).to receive(:alphanumeric).with(36).and_return('AAAAAABBBBBBCCCCCCFFFFFFFFFFFFFFFFFF')
    travel_to 15.days.ago do
      create(:ticket, event_id: event.event_id, batch_id: '2', user: user)
    end
    allow(Event).to receive(:request_my_events).and_return(events)
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Batch).to receive(:request_batch_by_id).with("1", '2').and_return(batches[1])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    login_as user
    visit root_path
    click_on 'Meus Eventos'
    within("#event_id_#{event.event_id}") do
      click_on 'Acessar Conteúdo do Evento'
    end

    expect(page).to have_content event.name
    expect(page).to have_content 'Entrada - Meia x2'
    expect(page).to have_content "Data\n#{I18n.l(5.days.ago, format: :date)}"
    expect(page).to have_content "Horário\n#{I18n.l(5.days.ago, format: :hour)}"
    expect(page).to have_content "Nº do Ingresso\nAAAAAABBBBBBCCCCCCDDDDDDDDDDDDDDDDD"
    expect(page).to have_content "Local\n#{event.local_event}"
    expect(page).to have_content 'AAAAAABBBBBBCCCCCCEEEEEEEEEEEEEEEEEE'
    expect(page).to have_content 'Entrada - PDC x1'
    expect(page).to have_content 'AAAAAABBBBBBCCCCCCFFFFFFFFFFFFFFFFFF'
  end

  it 'e não está logado' do
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
    event = build(:event, name: 'DevWeek', batches: batches, event_id: 1)
    events = [ event ]
    create(:ticket, event_id: event.event_id, batch_id: '1', user: user)
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    visit my_event_path(id: event.event_id, locale: :'pt-BR')

    expect(current_path).to eq new_user_session_path
  end

  it 'e é redirecionado se não tiver ingressos deste evento' do
    owner = create(:user)
    other_user = create(:user)
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
    event = build(:event, name: 'DevWeek', batches: batches, event_id: 1)
    events = [ event ]
    create(:ticket, event_id: event.event_id, batch_id: '1', user: owner)
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    login_as other_user
    visit my_event_path(id: event.event_id, locale: :'pt-BR')

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não participa deste evento'
  end

  it 'e pode acessar o QrCode de um ticket específico', js: true do
    user = create(:user)
    batches = [
      {
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
    qrcode = RQRCode::QRCode.new(ticket.token)
    generated_svg = qrcode.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    ).to_s.strip
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    login_as user
    visit my_event_path(id: event.event_id, locale: :'pt-BR')
    click_on 'Ingressos'
    click_on 'QR Code'

    sleep(1)
    rendered_svg = page.evaluate_script("document.querySelector('##{ticket.token} svg')?.outerHTML").strip
    expect(current_path).to eq event_batch_ticket_path(event_id: event.event_id, batch_id: ticket.batch_id, id: ticket.id, locale: :'pt-BR')
    expect(page).to have_css('svg')
    expect(page).to have_css('svg[shape-rendering="crispEdges"]')
    expect(normalize_svg(rendered_svg)).to eq(normalize_svg(generated_svg))
  end
end
