module ApplicationHelper
  def page_title(text)
    content_tag(:h1, class: "text-3xl font-extrabold text-center text-black mt-8 mb-6") do
      text
    end
  end

  def form_title(text)
    content_tag(:h3, class: "text-2xl font-extrabold text-center text-black mt-8 mb-6") do
      text
    end
  end

  def delete_favorite(text, path)
    button_to(path, method: :delete, class: "font-bold text-2xl text-red-500 hover:text-red-700 ml-2 focus:outline-none absolute top-2 right-2 font-medium-border") do
      text
    end
  end
end
