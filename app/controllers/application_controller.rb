class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action do
    ActiveStorage::Current.url_options = { host: request.base_url }
  end
  around_action :switch_locale

  def after_sign_in_path_for(resource)
    dashboard_index_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :last_name, :cpf ])
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def check_user_is_participant(event_id)
    unless current_user.participates_in_event?(event_id)
      redirect_to root_path, alert: I18n.t("custom.generic.negate_access")
    end
  end
end
