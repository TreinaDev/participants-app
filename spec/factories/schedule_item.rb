FactoryBot.define do
  factory :schedule_item do
    name { "Nome Teste" }
    start_time { 2.days.from_now }
    end_time { 5.days.from_now }
    description { 'novo teste pra  passar' }
    schedule_type { 'activity' }
    responsible_name { 'Sílvio Santos' }
    responsible_email { 'silvio@sbt.com' }
    schedule_item_id  { "ABCD1423" }

    initialize_with do
      new(
        name: name,
        start_time: start_time,
        end_time: end_time,
        description: description,
        schedule_type: schedule_type,
        responsible_name: responsible_name,
        responsible_email: responsible_email,
        schedule_item_id: schedule_item_id
      )
    end
  end
end
