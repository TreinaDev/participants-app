require 'rails_helper'

describe 'Usuário troca de idioma' do
  it 'com sucesso' do
    visit events_path(locale: 'pt-BR')
    within('nav') do
      click_on 'English'
    end

    expect(page).to have_css 'h1', text: 'Available Events'
    expect(page).not_to have_css 'h1', text: 'Eventos disponíveis'
    within('nav') do
      expect(page).to have_link 'Português'
      expect(page).not_to have_link 'English'
    end
  end
end
