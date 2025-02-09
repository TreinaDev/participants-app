require 'rails_helper'
include ActionView::RecordIdentifier

describe 'Participante edita postagem' do
  it 'e não está autenticado' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    post= create(:post, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit edit_event_post_path(event_id: event.event_id, id: post.id)

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    events = [ event ]
    post = create(:post, event_id: event.event_id, user: user, title: 'Título Original', content: 'Conteúdo Original')
    batches = [ build(:batch, name: 'Entrada - Meia') ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(4)
    allow(Event).to receive(:all).and_return(events)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Meus Eventos'
    end
    click_on 'Acessar Conteúdo do Evento'
    within("##{dom_id(post)}") do
      click_on 'Editar'
    end
    fill_in 'Título', with: 'Novo Título'
    find(:css, "#post_content_trix_input_#{dom_id(post)}", visible: false).set('Novo Conteúdo')
    click_on 'Salvar'

    post.reload
    expect(page).to have_content 'Postagem editada com sucesso'
    expect(post.title).to eq 'Novo Título'
    expect(post.content.to_plain_text).to eq 'Novo Conteúdo'
    expect(current_path).to eq event_by_name_path(event_id: event.event_id, name: event.name.parameterize, locale: :'pt-BR')
  end

  it 'com campos vazios' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    post = create(:post, event_id: event.event_id, user: user, title: 'Título Original', content: 'Conteúdo Original')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit edit_event_post_path(event_id: event.event_id, id: post.id, locale: :'pt-BR')
    fill_in 'Título', with: ''
    find(:css, "#post_content_trix_input_#{dom_id(post)}", visible: false).set('')
    click_on 'Salvar'

    expect(page).to have_content 'Falha ao salvar a postagem'
    expect(page).to have_content 'Título não pode ficar em branco'
    expect(page).to have_content 'Conteúdo não pode ficar em branco'
  end

  it 'pela página de detalhes de uma postagem' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    post = create(:post, event_id: event.event_id, user: user, title: 'Título Original', content: 'Conteúdo Original')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit event_post_path(event_id: event.event_id, id: post)

    expect(page).to have_content 'Editar'
  end

  it 'de um evento em que não participa' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    post = create(:post, event_id: event.event_id, user: user, title: 'Título Original', content: 'Conteúdo Original')
    other_user = create(:user)

    login_as other_user
    visit edit_event_post_path(event_id: event.event_id, id: post.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não participa deste evento'
  end

  it 'e não pode editar postagem de outro participante' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    ticket_1 = create(:ticket, event_id: event.event_id)
    user = ticket_1.user
    post = create(:post, event_id: event.event_id, user: user, title: 'Título Original', content: 'Conteúdo Original')
    ticket_2 = create(:ticket, event_id: event.event_id)
    other_user = ticket_2.user

    login_as other_user
    visit edit_event_post_path(event_id: event.event_id, id: post.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a essa página'
  end
end
