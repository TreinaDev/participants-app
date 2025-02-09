require 'rails_helper'

describe 'Participante adiciona nova postagem a um evento', type: :system, js: true do
  it 'e não está autenticado' do
    event = build(:event, event_id: 1, name: 'DevWeek')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit new_event_post_path(event_id: event.event_id)

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user)
    event = build(:event, event_id: '1', name: 'DevWeek')
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(2)
    batches = [ build(:batch, name: 'Entrada - Meia') ]
    target_event_id = event.event_id
    target_batch_id = batches[0].batch_id
    ticket = create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit new_event_post_path(event_id: event.event_id, locale: :'pt-BR')
    fill_in 'Título', with: 'Título Teste'
    find(:css, "#post_content_trix_input_post", visible: false).set('Conteúdo Teste')
    click_on 'Salvar'

    expect(page).to have_content 'Postagem adicionada'
    expect(page).to have_content 'Título Teste'
  end

  it 'com campos vazios' do
    event = build(:event, event_id: 1, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit new_event_post_path(event_id: event.event_id, locale: :'pt-BR')
    fill_in 'Título', with: ''
    find(:css, "#post_content_trix_input_post", visible: false).set('')
    click_on 'Salvar'

    expect(page).to have_content 'Falha ao salvar a postagem'
    expect(page).to have_content 'Título não pode ficar em branco'
    expect(page).to have_content 'Conteúdo não pode ficar em branco'
  end

  it 'e não é participante' do
    event = build(:event, event_id: 1, name: 'DevWeek')
    user = create(:user)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit new_event_post_path(event_id: event.event_id, locale: :'pt-BR')

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não participa deste evento'
  end
end
