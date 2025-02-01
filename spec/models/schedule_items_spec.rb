require 'rails_helper'

RSpec.describe ScheduleItem, type: :model do
  context 'Retorna duração' do
    it 'com sucesso' do
      schedules = [
        {
          date: 	"2025-02-14",
          schedule_items: [
            {
              name:	"Palestra",
              start_time:	"2025-02-14T09:00:00.000-03:00",
              end_time:	"2025-02-14T10:00:00.000-03:00"
            }
          ]
        }
      ]

      event = build(:event, schedules: schedules)
      schedule_item = event.schedules[0].schedule_items[0]

      expect(schedule_item.duration).to eq 60
    end

    it 'é retorna 0 quando o final da atividade e antes do início' do
      schedules = [
        {
          date: 	"2025-02-14",
          schedule_items: [
            {
              name:	"Palestra",
              start_time:	"2025-02-14T10:00:00.000-03:00",
              end_time:	"2025-02-14T09:00:00.000-03:00"
            }
          ]
        }
      ]

      event = build(:event, schedules: schedules)
      schedule_item = event.schedules[0].schedule_items[0]

      expect(schedule_item.duration).to eq 0
    end
  end
end
