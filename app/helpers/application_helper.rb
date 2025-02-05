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

  def formatted_currency(amount, locale: I18n.locale)
    converted_amount = locale == :'pt-BR' ? amount  : (amount.to_f / 5)
    number_to_currency(converted_amount, locale: locale)
  end

  def button_to_back
    link_to I18n.t("custom.back"), :back, class: "btn-back ml-6"
  end

  def form_link_to_back
    link_to :back, class: "absolute top-2 left-2", id: "back-button" do
      content_tag(:svg, class: "w-[35px] h-[35px] text-purple-700 hover:text-purple-500", aria: { hidden: true }, xmlns: "http://www.w3.org/2000/svg", width: "24", height: "24", fill: "none", viewBox: "0 0 24 24") do
        content_tag(:path, "", stroke: "currentColor", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "m17 16-4-4 4-4m-6 8-4-4 4-4")
      end
    end
  end
end
