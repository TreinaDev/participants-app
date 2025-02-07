class Content
  attr_accessor :code, :title, :description, :external_video_url, :files
  def initialize(code:, title:, description:, external_video_url:, files: [])
    @code = code
    @title = title
    @description = description
    @external_video_url = external_video_url
    @files = files || []
  end
end
