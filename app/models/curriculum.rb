class Curriculum
  attr_accessor :contents, :tasks
  def initialize(contents: [], tasks: [])
    @contents = build_contents(contents)
    @tasks = build_tasks(tasks)
  end

  def self.request_curriculum_by_schedule_item_code(schedule_item_id)
    curriculum_params = SpeakersApiService.get_curriculum(schedule_item_id)
    build_curriculum(curriculum_params)
  rescue Faraday::Error => error
    Rails.logger.error(error)
    build_curriculum({})
  end

  private

  def self.build_curriculum(curriculum_params)
    curriculum_data = curriculum_params && curriculum_params[:curriculum] ? curriculum_params[:curriculum] : {}
    Curriculum.new(
      contents: curriculum_data[:curriculum_contents] || [],
      tasks: curriculum_data[:curriculum_tasks] || []
    )
  end

  def build_contents(contents)
    Array(contents).map do |content|
      Content.new(
        code: content[:code], title: content[:title],
        description: content[:description], external_video_url: content[:external_video_url],
        files: content[:files]
      )
    end
  end

  def build_tasks(tasks)
    Array(tasks).map do |task|
      Task.new(
        code: task[:code], title: task[:title],
        description: task[:description], certificate_requirement: task[:certificate_requirement],
        attached_contents: task[:attached_contents]
      )
    end
  end
end
