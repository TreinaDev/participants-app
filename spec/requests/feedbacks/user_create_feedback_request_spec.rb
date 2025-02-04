require 'rails_helper'

describe 'Usuario cria feedback', type: :request do
  it 'e deve estar autenticado' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    post my_event_feedbacks_path(my_event_id: event.event_id), params: { feedback:
      {
        title: 'Avaliação',
        comment: 'Comentário',
        mark: 1
      }
    }

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end

  it 'mas o evento ainda está em andamento' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as ticket.user
    post my_event_feedbacks_path(my_event_id: event.event_id), params: { feedback:
      {
        title: 'Avaliação',
        comment: 'Comentário',
        mark: 1
      }
    }

    expect(response).to redirect_to root_path(locale: :'pt-BR')
    expect(flash[:alert]).to eq 'Este evento ainda está em andamento'
  end

  it 'com parâmetros incorretos' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    travel_to 6.days.from_now do
      login_as ticket.user
      post my_event_feedbacks_path(my_event_id: event.event_id), params: { feedback:
        {
          title: '',
          comment: '',
          mark: 10
        }
      }

      expect(flash[:alert]).to eq 'Falha ao salvar o Feedback'
    end
  end
end
