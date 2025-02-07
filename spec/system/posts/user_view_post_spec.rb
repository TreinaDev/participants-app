require 'rails_helper'

describe 'Participante vê postagem' do
  it 'a partir dos detalhes de um evento' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    events = [ event ]
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Event).to receive(:all).and_return(events)
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
    click_on 'Título Teste'

    expect(page).to have_content 'Título Teste'
    expect(page).to have_content 'Conteúdo Teste'
    expect(page).to have_content "Publicado em: #{I18n.l(post.created_at, format: :short)}"
  end

  it 'e não está autenticado' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    create(:ticket, event_id: event.event_id)
    post = create(:post, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')

    visit event_post_path(event_id: event.event_id, id: post)

    expect(current_path).to eq new_user_session_path
  end

  it 'e não participa deste evento' do
    user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    post = create(:post, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')

    login_as user
    visit event_post_path(event_id: event.event_id, id: post)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não participa deste evento'
  end

  it 'de outro participante do evento' do
    user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    create(:ticket, user: user, event_id: event.event_id)
    post = create(:post, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')

    login_as user
    visit event_post_path(event_id: event.event_id, id: post)

    expect(current_path).to eq event_post_path(event_id: event.event_id, id: post)
    expect(page).to have_content 'Título Teste'
    expect(page).to have_content 'Conteúdo Teste'
    expect(page).to have_content "#{I18n.l(post.created_at, format: :short)}"
  end
end
