class ApplicationController < ActionController::Base
  include SslRequirement
  protect_from_forgery
  before_filter :set_locale
  before_filter {|c| Authorization.current_user = c.current_user}
  
  
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end
  
  protected
  def permission_denied
    flash[:error] = t('custom_error.perm_denied')
    redirect_to root_url
  end
end
