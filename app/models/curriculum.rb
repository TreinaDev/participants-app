class Curriculum
  attr_accessor :contents, :tasks, :tasks_available, :certificate_url
  def initialize(contents: [], tasks: [], tasks_available:, certificate_url:)
    @contents = build_contents(contents)
    @tasks = build_tasks(tasks)
    @tasks_available = tasks_available
    @certificate_url = certificate_url
  end

  def self.request_curriculum_by_schedule_item_and_user_code(schedule_item_id, user_code)
    curriculum_params = SpeakersApiService.get_curriculum_by_user(schedule_item_id, user_code)
    build_curriculum(curriculum_params)
  rescue Faraday::Error => error
    Rails.logger.error(error)
    build_curriculum({})
  end

  def self.request_finalize_task(user_code, task_code)
    SpeakersApiService.post_complete_task(user_code, task_code)
    {
      ok: true
    }
  rescue Faraday::Error => error
    Rails.logger.error(error)
    {
      ok: false
    }
  end

  private

  def self.build_curriculum(curriculum_params)
    curriculum_data = curriculum_params && curriculum_params[:curriculum] ? curriculum_params[:curriculum] : {}
    Curriculum.new(
      contents: curriculum_data[:curriculum_contents] || [],
      tasks: curriculum_data[:curriculum_tasks] || [],
      tasks_available: curriculum_data[:tasks_available] || nil,
      certificate_url: curriculum_data[:certificate_url] || nil
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
        task_status: task[:task_status],
        attached_contents: task[:attached_contents]
      )
    end
  end
end
