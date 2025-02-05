class Curriculum
  def self.request_curriculum_by_schedule_item_code(schedule_item_id)
    curriculum_params = SpeakersApiService.get_curriculum(schedule_item_id)
  end
end
