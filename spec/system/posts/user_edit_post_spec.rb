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

  it 'com sucesso ' do 
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
end
