require 'rails_helper'

describe 'Usuário remove curtida da postagem' do
  it 'na tela de detalhes do post' do
    user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    create(:ticket, user: user, event_id: event.event_id)
    post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')

    login_as user
    visit event_post_path(event_id: event.event_id, id: post)

    expect(page).to have_css('#unlike-button')
    expect(page).not_to have_css('like-button')
  end

  it 'com sucesso' do
    user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    create(:ticket, user: user, event_id: event.event_id)
    post = create(:post, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')
    create(:like, post: post, user: user)

    login_as user
    visit event_post_path(event_id: event.event_id, id: post)
    find('#unlike-button').click

    expect(page).to have_content 'Curtida removida com sucesso'
    expect(page).to have_content '1 curtida'
    expect(page).to have_css('#like-button')
    expect(page).not_to have_css('#unlike-button')
  end
end
