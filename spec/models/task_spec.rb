require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#initialize' do
    it 'cria uma tarefa com os atributos corretos' do
      task = Task.new(code: 'T1', title: 'Tarefa 1', description: 'Descrição da tarefa', task_status: false, certificate_requirement: 'Opcional', attached_contents: [])
      expect(task.code).to eq('T1')
      expect(task.title).to eq('Tarefa 1')
      expect(task.description).to eq('Descrição da tarefa')
      expect(task.task_status).to eq(false)
      expect(task.certificate_requirement).to eq('Opcional')
      expect(task.attached_contents).to eq([])
    end
  end

  describe '#need_certificate' do
    it 'retorna true se a tarefa for obrigatória para certificado' do
      task = Task.new(code: 'T2', title: 'Tarefa 2', description: 'Descrição', task_status: false, certificate_requirement: 'Obrigatória')
      expect(task.need_certificate).to be true
    end

    it 'retorna false se a tarefa não for obrigatória' do
      task = Task.new(code: 'T3', title: 'Tarefa 3', description: 'Descrição', task_status: false, certificate_requirement: 'Opcional')
      expect(task.need_certificate).to be false
    end
  end
end
