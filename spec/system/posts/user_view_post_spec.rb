require 'rails_helper'

describe 'Participante vê postagem' do
  it 'a partir dos detalhes de um evento' do
    user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    events = [ event ]
    post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Event).to receive(:all).and_return(events)
    batches = [ build(:batch, name: 'Entrada - Meia') ]
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
