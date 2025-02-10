FactoryBot.define do
  factory :task do
    code { "FNRVUEUB" }
    title { "Exercício Rails" }
    description { "Seu primeiro exercício ruby" }
    certificate_requirement { "Obrigatória" }
    task_status { false }
    attached_contents { [ build(:content) ] }

    initialize_with do
      new(
        code: code,
        title: title,
        description: description,
        certificate_requirement: certificate_requirement, task_status: task_status,
        attached_contents: attached_contents
      )
    end
  end
end
