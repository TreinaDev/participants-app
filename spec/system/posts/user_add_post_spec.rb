require 'rails_helper'

describe 'Participante adiciona nova postagem a um evento', type: :system, js: true do
  it 'e vê formulário' do
    event = build(:event, event_id: 1, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Event).to receive(:all).and_return([ event ])

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Eventos'
    end
    click_on 'DevWeek'
    click_on 'Adicionar Postagem'

    expect(page).to have_content 'Nova Postagem'
    expect(page).to have_field 'Título'
    expect(page).to have_css '#post_content'
    expect(page).to have_button 'Salvar'
  end

  it 'e não está autenticado' do
    event = build(:event, event_id: 1, name: 'DevWeek')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit new_event_post_path(event_id: event.event_id)

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    event = build(:event, event_id: 1, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    user = ticket.user
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(2)

    login_as user
    visit new_event_post_path(event_id: event.event_id, locale: :'pt-BR')
    fill_in 'Título', with: 'Título Teste'
    find(:css, "#post_content_trix_input_post", visible: false).set('Conteúdo Teste')
    click_on 'Salvar'

    expect(current_path).to eq event_by_name_path(event_id: event.event_id, name: event.name.parameterize, locale: :'pt-BR')
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
    find(:xpath, "//*[@id='post_content_trix_input_post']", visible: false).set('')
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
