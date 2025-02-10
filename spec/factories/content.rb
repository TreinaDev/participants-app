FactoryBot.define do
  factory :content do
    code { "MH0IBQ8O" }
    title { "Ruby PDF" }
    description { "<strong>Descrição Ruby PDF</strong>" }
    external_video_url { "<iframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/idaXF2Er4TU' frameborder='0' allowfullscreen></iframe>" }
    files { [
      { filename: "puts.png", file_download_url: "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--97207adb5d87fac1fb977c3ae5b3896f2de5fe1a/puts.png" }
      ] }

    initialize_with do
      new(
        code: code,
        title: title,
        description: description,
        external_video_url: external_video_url,
        files: files,
      )
    end
  end
end
