require 'rails_helper'

describe 'Usuário autenticado acessa o dashboard' do
  it 'com sucesso' do
    user = create(:user)

    login_as user
    visit dashboard_index_path

    expect(current_path).to eq dashboard_index_path
  end

  it 'sem postagens realizadas' do
    user = create(:user)

    login_as user
    visit dashboard_index_path

    expect(page).to have_content 'Ainda não há publicações.'
    expect(page).to have_content '🚀 Participe de eventos e veja novos conteúdos!' 
    expect(page).to have_link 'Participar Agora'
  end

  it 'e visualiza últimas dez postagens de todos os seus eventos' do
    user = create(:user)
    event_one = build(:event, name: 'Aprendendo a cozinhar')
    event_two = build(:event, name: 'DevWeek')
    event_three = build(:event, name: 'Soletrando')
    event_four = build(:event, name: 'Dev con')
    events = [ event_one, event_two, event_three, event_four ]

    create(:ticket, user: user, event_id: event_one.event_id, status_confirmed: true)
    create(:ticket, user: user, event_id: event_two.event_id, status_confirmed: true)
    create(:ticket, user: user, event_id: event_three.event_id, status_confirmed: true)
    create(:ticket, user: user, event_id: event_four.event_id, status_confirmed: true)

    create(:post, title: 'Cozinhando frutos do mar', event_id: event_one.event_id, created_at: 1.days.ago)
    create(:post, title: 'Aprendendo a fritar ovo', event_id: event_one.event_id, created_at: 2.days.ago)
    create(:post, title: 'Miojo com atum', event_id: event_one.event_id, created_at: 3.days.ago)
    create(:post, title: 'Sei fazer feijoada', event_id: event_one.event_id, created_at: 4.days.ago)
    create(:post, title: 'Quem foi que inventou Java?', event_id: event_two.event_id, created_at: 1.days.ago)
    create(:post, title: 'O Rails pode cair duas vezes num mesmo lugar?', event_id: event_two.event_id, created_at: 2.days.ago)
    create(:post, title: 'Quantos anos são necessários para aprender C++?', event_id: event_two.event_id, created_at: 3.days.ago)
    create(:post, title: 'CSS: ame-o ou deixe-o', event_id: event_two.event_id, created_at: 4.days.ago)
    create(:post, title: 'Português: um idioma problemático', event_id: event_three.event_id, created_at: 1.days.ago)
    create(:post, title: 'É baiano ou bahiano?', event_id: event_three.event_id, created_at: 2.days.ago)
    create(:post, title: 'Devs que não tomam café', event_id: event_four.event_id, created_at: 1.days.ago)
    create(:post, title: 'Devs que acordam 5 da manhã', event_id: event_four.event_id, created_at: 2.days.ago)
    allow(Event).to receive(:request_events_posts).and_return(events)

    login_as user
    visit dashboard_index_path

    expect(page).to have_content 'Cozinhando frutos do mar'
    expect(page).to have_content 'Quem foi que inventou Java?'
    expect(page).to have_content 'Português: um idioma problemático'
    expect(page).to have_content 'Devs que não tomam café'
    expect(page).to have_content 'Aprendendo a fritar ovo'
    expect(page).to have_content 'O Rails pode cair duas vezes num mesmo lugar?'
    expect(page).to have_content 'É baiano ou bahiano?'
    expect(page).to have_content 'Devs que acordam 5 da manhã'
    expect(page).to have_content 'Miojo com atum'
    expect(page).to have_content 'Quantos anos são necessários para aprender C++?'
    expect(page).not_to have_content 'Sei fazer feijoada'
    expect(page).not_to have_content 'CSS: ame-o ou deixe-o'
  end


  it 'e visualiza autor, data e evento das ultimas postagens' do
    user = create(:user)
    event_three = build(:event, name: 'Soletrando')
    events = [ event_three ]


    create(:ticket, user: user, event_id: event_three.event_id, status_confirmed: true)
    post = create(:post, title: 'Português: um idioma problemático', event_id: event_three.event_id, created_at: 1.days.ago)
    allow(Event).to receive(:request_events_posts).and_return(events)

    login_as user
    visit dashboard_index_path

    expect(page).to have_content 'Dashboard'
    expect(page).to have_content 'Acompanhe os últimos posts e novidades dos seus eventos.'
    expect(page).to have_content '📢 Português: um idioma problemático'
    expect(page).to have_content "👤 André • 📅 #{I18n.l(post.created_at, format: :short)}"
    expect(page).to have_content "🎉 Evento: Soletrando"
  end

  it 'e não pode acessar se não estiver autenticado' do
    visit dashboard_index_path

    expect(current_path).to eq user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e não vê feed de eventos que não comprou ingresso' do
    user = create(:user)
    event_one = build(:event, name: 'Aprendendo a cozinhar')
    event_two = build(:event, name: 'DevWeek')
    event_three = build(:event, name: 'Soletrando')
    event_four = build(:event, name: 'Dev con')
    events = [ event_one, event_two, event_three, event_four ]

    create(:ticket, user: user, event_id: event_one.event_id, status_confirmed: true)
    create(:ticket, user: user, event_id: event_two.event_id, status_confirmed: true)

    create(:post, title: 'Cozinhando frutos do mar', event_id: event_one.event_id, created_at: 1.days.ago)
    create(:post, title: 'Aprendendo a fritar ovo', event_id: event_one.event_id, created_at: 2.days.ago)
    create(:post, title: 'Miojo com atum', event_id: event_one.event_id, created_at: 3.days.ago)
    create(:post, title: 'Sei fazer feijoada', event_id: event_one.event_id, created_at: 4.days.ago)
    create(:post, title: 'Quem foi que inventou Java?', event_id: event_two.event_id, created_at: 1.days.ago)
    create(:post, title: 'O Rails pode cair duas vezes num mesmo lugar?', event_id: event_two.event_id, created_at: 2.days.ago)
    create(:post, title: 'Quantos anos são necessários para aprender C++?', event_id: event_two.event_id, created_at: 3.days.ago)
    create(:post, title: 'CSS: ame-o ou deixe-o', event_id: event_two.event_id, created_at: 4.days.ago)
    create(:post, title: 'Português: um idioma problemático', event_id: event_three.event_id, created_at: 1.days.ago)
    create(:post, title: 'É baiano ou bahiano?', event_id: event_three.event_id, created_at: 2.days.ago)
    create(:post, title: 'Devs que não tomam café', event_id: event_four.event_id, created_at: 1.days.ago)
    create(:post, title: 'Devs que acordam 5 da manhã', event_id: event_four.event_id, created_at: 2.days.ago)
    allow(Event).to receive(:request_events_posts).and_return(events)

    login_as user
    visit dashboard_index_path

    expect(page).to have_content 'Cozinhando frutos do mar'
    expect(page).to have_content 'Quem foi que inventou Java?'
    expect(page).to have_content 'Aprendendo a fritar ovo'
    expect(page).to have_content 'O Rails pode cair duas vezes num mesmo lugar?'
    expect(page).to have_content 'Miojo com atum'
    expect(page).to have_content 'Quantos anos são necessários para aprender C++?'
    expect(page).to have_content 'Sei fazer feijoada'
    expect(page).not_to have_content 'Português: um idioma problemático'
    expect(page).not_to have_content 'É baiano ou bahiano?'
    expect(page).not_to have_content 'Devs que não tomam café'
    expect(page).not_to have_content 'Devs que acordam 5 da manhã'
  end
end
