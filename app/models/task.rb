class Task
  attr_accessor :code, :title, :description, :certificate_requirement, :task_status, :attached_contents
  def initialize(code:, title:, description:, certificate_requirement:, task_status:, attached_contents: [])
    @code = code
    @title = title
    @description = description
    @certificate_requirement = certificate_requirement
    @task_status = task_status
    @attached_contents = attached_contents || []
  end

  def need_certificate
    @certificate_requirement == "Obrigatória"
  end
end
