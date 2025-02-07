require 'rails_helper'

describe 'Usuário curte postagem' do
  it 'pela página de detalhes de uma postagem' do
    user = create(:user)
    other_user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    create(:ticket, user: user, event_id: event.event_id)
    create(:ticket, user: other_user, event_id: event.event_id)
    post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')

    login_as other_user
    visit event_post_path(event_id: event.event_id, id: post)

    expect(page).to have_css('#like-button')
  end

  it 'com sucesso' do
    user = create(:user)
    other_user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    create(:ticket, user: user, event_id: event.event_id)
    create(:ticket, user: other_user, event_id: event.event_id)
    post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')
    create_list(:like, 2, post: post)

    login_as other_user
    visit event_post_path(event_id: event.event_id, id: post)
    find('#like-button').click

    expect(page).to have_content 'Você curtiu a postagem com sucesso'
    expect(page).not_to have_css('#like-button')
    expect(page).to have_content '4 curtidas'
  end

  it 'cria curtida automática do dono ao criar postagem' do
    user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    create(:ticket, user: user, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)
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
    visit new_event_post_path(event_id: event.event_id, locale: :'pt-BR')
    fill_in 'Título', with: 'Título Teste'
    find(:css, "#post_content_trix_input_post", visible: false).set('Conteúdo Teste')
    click_on 'Salvar'
    click_on "Título Teste"

    expect(page).to have_content '1 curtida'
  end
end
