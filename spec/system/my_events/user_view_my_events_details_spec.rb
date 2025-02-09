require 'rails_helper'
include ActionView::RecordIdentifier

describe "Participante de um evento acessa mais detalhes do evento", type: :system do
  it "e vê o botão para acessar mais detalhes do evento" do
    user = create(:user)
    event = build(:event)
    create(:ticket, event_id: event.event_id, user: user)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).to have_link 'Acessar Conteúdo do Evento'
  end

  it 'e não vê o botão caso não possua ingresso para esse evento' do
    user = create(:user)
    event = build(:event)

    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).not_to have_link 'Detalhes do Evento'
  end

  it 'e é redirecionado para a página de detalhes deste evento ao clicar o botão' do
    user = create(:user)
    event = build(:event, name: 'DevWeek', event_id: '1')
    events = [ event ]
    batches = [ build(:batch) ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    login_as user
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')
    click_on 'Acessar Conteúdo do Evento'

    expect(current_path).to eq my_event_path(event.event_id, locale: :'pt-BR')
    expect(page).to have_content 'DevWeek'
  end

  it "e consegue ver a agenda do evento" do
    user = create(:user)
    schedules = [
      {
        date: 	"2025-02-14",
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	"2025-02-14T09:00:00.000-03:00",
            end_time:	"2025-02-14T10:00:00.000-03:00",
            code: "GOEX84DP"
          },
          {
            name:	"Segunda Palestra",
            start_time:	"2025-02-14T10:00:00.000-03:00",
            end_time:	"2025-02-14T11:00:00.000-03:00",
            code: "6XD2I9RA"
          }
        ]
      },
      {
        date: 	"2025-02-15",
        schedule_items: [
          {
            name:	"Apresentação",
            start_time:	"2025-02-15T09:00:00.000-03:00",
            end_time:	"2025-02-15T10:00:00.000-03:00",
            code: "8XDGREWQ"
          }
        ]
      },
      {
        date: 	"2025-02-16",
        schedule_items: []
      }
    ]
    event = build(:event, name: 'DevWeek', event_id: '1', schedules: schedules)
    batches = [ build(:batch) ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit my_event_path(event.event_id, locale: :'pt-BR')

    expect(page).to have_content "14/02/2025"
    expect(page).to have_content "Palestra"
    expect(page).to have_content "Início: 09:00"
    expect(page).to have_content "Duração: 60min"
    expect(page).to have_content "Segunda Palestra"
    expect(page).to have_content "Início: 10:00"
    expect(page).to have_content "Duração: 60min"
    expect(page).to have_content "15/02/2025"
    expect(page).to have_content "Apresentação"
    expect(page).to have_content "Início: 09:00"
    expect(page).to have_content "Duração: 60min"
    expect(page).to have_content "16/02/2025"
    expect(page).to have_content 'Ainda não existe programação cadastrada para esse dia'
  end

  it 'e visualiza que não há programação para o evento' do
    user = create(:user)
    event = build(:event, name: 'DevWeek', event_id: '1')
    batches = [ build(:batch) ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit my_event_path(event.event_id, locale: :'pt-BR')

    expect(page).to have_content 'Ainda não existe programação cadastrada para esse evento'
  end

  it 'e consegue ver o feed do evento, ainda sem postagens' do
    user = create(:user)
    event = build(:event, name: 'DevWeek', event_id: '1')
    batches = [ build(:batch) ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit my_event_path(event.event_id, locale: :'pt-BR')

    expect(page).to have_content('Feed')
    expect(page).to have_content 'Não existem postagens para esse evento'
  end

  it "e consegue ver o feed de postagens" do
    user = create(:user)
    event = build(:event, name: 'DevWeek', event_id: '1')
    events = [ event ]
    batches = [ build(:batch) ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])

    post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Event).to receive(:all).and_return(events)

    login_as user
    visit my_event_path(event.event_id, locale: :'pt-BR')
    click_on 'Título Teste'

    expect(page).to have_content 'Título Teste'
    expect(page).to have_content 'Conteúdo Teste'
    expect(page).to have_content "Publicado em: #{I18n.l(post.created_at, format: :short)}"
  end

  it 'e consegue ver feedback no feed do evento' do
    user = create(:user, name: 'David', last_name: 'Martinez')
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
    event = build(:event, name: 'DevWeek', batches: batches, event_id: '1', start_date: 5.days.ago, end_date: 1.day.ago)
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1', user: user)
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as ticket.user
    feedback = create(:feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                      user: user, public: true)
    visit my_event_path(event.event_id, locale: :'pt-BR')

    within "#feed" do
      within "##{dom_id(feedback)}" do
        expect(page).to have_content 'Feedback'
        expect(page).to have_content 'David Martinez'
        expect(page).to have_content 'Título Padrão'
        expect(page).to have_content 'Nota: 3'
      end
    end
  end

  it 'e consegue ver feedback de um item de um evento no feed do evento' do
    user = create(:user, name: 'David', last_name: 'Martinez')
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
    schedules = [
      {
        date: 	5.day.ago,
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	5.day.ago.beginning_of_day + 9.hours,
            end_time:	5.day.ago.beginning_of_day + 10.hours,
            code: '1'
          }
        ]
      }
    ]
    event = build(:event, name: 'DevWeek', batches: batches, event_id: '1', start_date: 5.days.ago, end_date: 1.day.ago, schedules: schedules)
    schedule_item = event.schedules[0].schedule_items[0]
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1', user: user)
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as ticket.user
    item_feedback = create(:item_feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                                      user: user, public: true, schedule_item_id: schedule_item.schedule_item_id)
    visit my_event_path(event.event_id, locale: :'pt-BR')

    within "#feed" do
      within "##{dom_id(item_feedback)}" do
        expect(page).to have_content 'Feedback'
        expect(page).to have_content 'David Martinez'
        expect(page).to have_content 'Título Padrão'
        expect(page).to have_content 'Nota: 3'
      end
    end
  end

  it "e consegue chegar na página de conteudos de eventos através de meus eventos" do
    user = create(:user)
    event = build(:event, name: 'DevWeek', event_id: '1')
    events = [ event ]
    batches = [ build(:batch, name: 'Entrada - Meia') ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(events[0])
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Event).to receive(:all).and_return(events)

    login_as user
    visit root_path
    click_on 'Meus Eventos'
    within("#event_id_#{event.event_id}") do
      click_on 'Acessar Conteúdo do Evento'
    end

    expect(page).to have_content 'DevWeek'
    expect(page).to have_content 'Entrada - Meia'
    expect(page).to have_content 'Agenda do evento'
  end

  it "e não possui nenhum evento" do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Meus Eventos'

    expect(page).to have_content 'Você ainda não possui ingressos comprados'
  end

  it "e vê erro do servidor quando o aplicativo de eventos não esta no ar" do
    user = create(:user)
    event = build(:event, name: 'DevWeek', event_id: '1')
    batches = [ build(:batch, name: 'Entrada - Meia') ]
    target_batch_id = batches[0].batch_id
    create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)

    login_as user
    visit root_path
    click_on 'Meus Eventos'

    expect(page).to have_content 'Erro do servidor'
  end
end
