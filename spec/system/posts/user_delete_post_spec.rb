require 'rails_helper'

describe 'Usuário deleta postagem de um evento' do
  it 'pela página de detalhes de um evento' do
    user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    events = [ event ]
    post = create(:post, event_id: event.event_id, user: user, title: 'Título Original', content: 'Conteúdo Original')
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(3)
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
    click_on 'Título Original'

    expect(page).to have_content 'Excluir Postagem'
  end

  it 'e botão de deletar somente aparece para o dono do post' do
    other_user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    events = [ event ]
    ticket = create(:ticket, event_id: event.event_id)
    create(:ticket, event_id: event.event_id, user: other_user)
    post = create(:post, event_id: event.event_id, user: ticket.user, title: 'Título Original', content: 'Conteúdo Original')
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(3)
    allow(Event).to receive(:all).and_return(events)

    login_as other_user
    visit event_post_path(event_id: event.event_id, id: post)

    expect(page).not_to have_content 'Excluir Postagem'
  end

  it 'com sucesso' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    events = [ event ]
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    post = create(:post, event_id: event.event_id, user: user, title: 'Título Original', content: 'Conteúdo Original')
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(3)

    login_as user
    visit event_post_path(event_id: event.event_id, id: post)
    click_on 'Excluir Postagem'

    expect(current_path).to eq event_by_name_path(event_id: event.event_id, name: event.name.parameterize, locale: :'pt-BR')
    expect(page).to have_content 'Postagem excluida com sucesso'
    expect(page).not_to have_content 'Título Original'
    expect(page).not_to have_content 'Conteúdo Original'
  end

  it 'e vê mensagem de erro ao excluir com alguma falha' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    events = [ event ]
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    post = create(:post, event_id: event.event_id, user: user, title: 'Título Original', content: 'Conteúdo Original')
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(3)
    allow(Post).to receive(:find).and_return(post)
    allow(post).to receive(:destroy).and_return(false)

    login_as user
    visit event_post_path(event_id: event.event_id, id: post)
    click_on 'Excluir Postagem'

    expect(current_path).to eq event_post_path(event_id: event.event_id, id: post, locale: :'pt-BR')
    expect(page).to have_content 'Falha ao excluir a postagem'
    expect(page).to have_content 'Título Original'
    expect(page).to have_content 'Conteúdo Original'
  end
end
