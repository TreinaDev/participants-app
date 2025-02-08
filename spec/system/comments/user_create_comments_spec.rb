require 'rails_helper'

describe 'Usuário cria comentário em postagem' do
  it 'na página de detalhes da postagem' do
    user = create(:user)
    event = build(:event, name: 'DevWeek')
    events = [ event ]
    create(:post, event_id: event.event_id, title: 'Primeiro post')
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(event)
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
    click_on 'Primeiro post'

    expect(page).to have_button 'Adicionar Comentário'
  end

  it 'com sucesso' do
    user = create(:user, name: 'Carlos')
    event = build(:event, name: 'DevWeek')
    create(:ticket, user: user, event_id: event.event_id)
    post = create(:post, event_id: event.event_id, title: 'Primeiro post')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit event_post_path(event_id: event.event_id, id: post.id, locale: :'pt-BR')
    find('#comment_content').set('Comentário Teste')
    click_on 'Adicionar Comentário'

    expect(current_path).to eq event_post_path(event_id: event.event_id, id: post.id, locale: :'pt-BR')
    expect(page).to have_content 'Comentário adicionado'
    expect(page).to have_content 'Comentário Teste'
    expect(page).to have_content 'Carlos'
    expect(page).to have_content I18n.l(Comment.last.created_at, format: :short)
  end

  it 'e vê mensagem não pode ficar em branco' do
    user = create(:user, name: 'Carlos')
    event = build(:event, name: 'DevWeek')
    create(:ticket, user: user, event_id: event.event_id)
    post = create(:post, event_id: event.event_id, title: 'Primeiro post')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit event_post_path(event_id: event.event_id, id: post.id, locale: :'pt-BR')
    find('#comment_content').set('')
    click_on 'Adicionar Comentário'

    expect(page).to have_content 'Falha ao salvar o comentário'
    expect(page).to have_content 'Conteúdo não pode ficar em branco'
  end

  it 'e vê mensagem tamanho máximo do conteúdo' do
    user = create(:user, name: 'Carlos')
    event = build(:event, name: 'DevWeek')
    create(:ticket, user: user, event_id: event.event_id)
    post = create(:post, event_id: event.event_id, title: 'Primeiro post')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit event_post_path(event_id: event.event_id, id: post.id, locale: :'pt-BR')
    find('#comment_content').set('a' * 201)
    click_on 'Adicionar Comentário'

    expect(page).to have_content 'Falha ao salvar o comentário'
    expect(page).to have_content 'Conteúdo é muito longo (máximo: 200 caracteres)'
  end
end
