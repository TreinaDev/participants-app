require 'rails_helper'

RSpec.describe Content, type: :model do
  describe '#initialize' do
    it 'cria um conteúdo com os atributos corretos' do
      content = Content.new(code: 'C1', title: 'Conteúdo 1', description: 'Descrição do conteúdo', external_video_url: 'http://video.com', files: [])
      expect(content.code).to eq('C1')
      expect(content.title).to eq('Conteúdo 1')
      expect(content.description).to eq('Descrição do conteúdo')
      expect(content.external_video_url).to eq('http://video.com')
      expect(content.files).to eq([])
    end
  end
end
