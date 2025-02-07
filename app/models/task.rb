class Task
  attr_accessor :code, :title, :description, :certificate_requirement, :attached_contents
  def initialize(code:, title:, description:, certificate_requirement:, attached_contents: [])
    @code = code
    @title = title
    @description = description
    @certificate_requirement = certificate_requirement
    @attached_contents = attached_contents || []
  end

  private

  def self.build_tasks(data)
    data.map { |task| Task.new(code: task[:code], title: task[:title],
                description: task[:description], certificate_requirement: task[:certificate_requirement],
                attached_contents: task[:attached_contents]) }
  end
end
