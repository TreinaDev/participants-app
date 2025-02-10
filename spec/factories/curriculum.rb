FactoryBot.define do
  factory :curriculum do
    tasks_available { true }
    contents { [] }
    tasks { [] }

    initialize_with do
      new(
        contents: contents,
        tasks: tasks,
        tasks_available: tasks_available
      )
    end
  end
end
