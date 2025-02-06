FactoryBot.define do
  factory :schedule do
      schedule_item
      date { '15/08/2025' }

    initialize_with do
      new(
        schedule_item: schedule_item,
        date: date
      )
    end
  end
end
