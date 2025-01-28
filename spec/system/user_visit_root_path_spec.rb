require "rails_helper"

describe 'Usuário acessa página incial' do
  it 'com sucesso' do
    events = []
    events << build(:event, banner: 'https://cdn.pixabay.com/photo/2024/09/19/18/08/rose-9059411_1280.jpg', name: 'Aprendendo a voar', start_date: 2.day.from_now)
    events << build(:event, banner: 'https://cdn.pixabay.com/photo/2022/10/02/13/07/autumn-7493439_960_720.jpg', name: 'Aprendendo a nadar', start_date: 3.day.from_now)
    events << build(:event, banner: 'https://cdn.pixabay.com/photo/2024/12/23/07/48/heavenly-bamboo-9286035_1280.jpg', name: 'Aprendendo sobre Python', start_date: 4.day.from_now)
    events << build(:event, banner: 'https://cdn.pixabay.com/photo/2025/01/17/16/06/building-9340309_1280.jpg', name: 'Aprendendo a cozinhar', start_date: 5.day.from_now)
    allow(Event).to receive(:all).and_return(events)

    visit root_path

    expect(page).to have_content 'Aprendendo a voar'
    expect(page).to have_css 'img[src="https://cdn.pixabay.com/photo/2024/09/19/18/08/rose-9059411_1280.jpg"]'

    expect(page).to have_content 'Aprendendo a nadar'
    expect(page).to have_css 'img[src="https://cdn.pixabay.com/photo/2022/10/02/13/07/autumn-7493439_960_720.jpg"]'

    expect(page).to have_content 'Aprendendo sobre python'
    expect(page).to have_css 'img[src="https://cdn.pixabay.com/photo/2024/12/23/07/48/heavenly-bamboo-9286035_1280.jpg"]'

    expect(page).not_to have_content 'Aprendendo a cozinhar'
    expect(page).not_to have_css 'img[src="https://cdn.pixabay.com/photo/2025/01/17/16/06/building-9340309_1280.jpg"]'
  end
end
