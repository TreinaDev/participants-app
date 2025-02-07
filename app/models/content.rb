class Content
  attr_accessor :code, :title, :description, :external_video_url, :files
  def initialize(code:, title:, description:, external_video_url:, files: [])
    @code = code
    @title = title
    @description = description
    @external_video_url = external_video_url
    @files = files files || []
  end

  private

  def self.build_contents(data)
    data.map { |content| Content.new(code: content[:code], title: content[:title],
                description: content[:description], external_video_url: content[:external_video_url],
                files: content[:files]) }
  end
end
