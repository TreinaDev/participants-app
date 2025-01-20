module ApplicationHelper
  def page_title(text)
    content_tag(:h1, class: "text-3xl font-extrabold text-center dark:text-black mt-8 mb-6") do
      text
    end
  end

  def button_link(text, path)
    link_to(path, class: "text-white bg-gradient-to-br from-green-400 to-blue-600 hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-green-200 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2") do
      text
    end
  end

  def delete_button(text, path)
    button_to(path, method: :delete, class: "focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900") do
      text
    end
  end
end
