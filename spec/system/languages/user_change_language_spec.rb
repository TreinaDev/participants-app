require 'rails_helper'

describe 'Usuário troca de idioma' do
  it 'com sucesso' do
    visit root_path
    within('nav') do
      click_on 'English'
    end

    expect(page).to have_css 'h1', text: 'Available Events'
    expect(page).not_to have_css 'h1', text: 'Eventos disponíveis'
  end
end
