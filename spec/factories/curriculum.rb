FactoryBot.define do
  factory :curriculum do
    tasks_available { true }
    certificate_url { "http://localhost:3000/certificates/PIMZBVXM04DWVNVWI90H.pdf" }
    contents { [] }
    tasks { [] }

    initialize_with do
      new(
        contents: contents,
        tasks: tasks,
        tasks_available: tasks_available,
        certificate_url: certificate_url
      )
    end
  end
end
