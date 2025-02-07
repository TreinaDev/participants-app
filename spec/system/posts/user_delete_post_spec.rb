require 'rails_helper'

describe 'Usuário deleta postagem de um evento' do
  it 'pela página de detalhes de um evento' do
    event = build(:event, event_id: '1', name: 'DevWeek')
    events = [ event ]
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    post = create(:post, event_id: event.event_id, user: user, title: 'Título Original', content: 'Conteúdo Original')
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(3)
    allow(Event).to receive(:all).and_return(events)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'DevWeek'
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
