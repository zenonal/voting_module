class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery
  include SslRequirement
  helper_method :filter_index
  
  before_filter :set_locale
  before_filter :set_mode
  before_filter {|c| Authorization.current_user = c.current_user}
  
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
  
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end
  
  def set_mode
    if cookies[:tutorial].blank?
      if user_signed_in?
        if current_user.sign_in_count <= 1
          cookies[:tutorial] = true
        else
          cookies[:tutorial] = false
        end
      end
    end
  end
  
  
  #helper method
  def filter_index(bills)
    if params[:filter] && !params[:filter][:level].blank?
      if params[:user_level] == "off"
         @bill = bills.where(:level => params[:filter][:level]).all(:order => "created_at DESC")
         @geo = t("#{bills[0].class.name.pluralize.downcase}.#{params[:filter][:level]}")
      else
         @bill = bills.user_geographical_level(current_user,params[:filter][:level]).all(:order => "created_at DESC")
         if params[:filter][:level] == "communal"
           @geo = current_user.commune.name
         end
         if params[:filter][:level] == "provincial"
            @geo = current_user.province.name
         end
         if params[:filter][:level] == "regional"
            @geo = current_user.region.name
         end
         if params[:filter][:level] == "federal"
            @geo = params[:filter][:level]
         end
      end
    else
       @bill = bills.all(:order => "created_at DESC")
       if params[:user_level] == "off"
         @geo = t("#{bills[0].class.name.pluralize.downcase}.no_geo")
       else
         @geo = current_user.commune.name + ", " + current_user.province.name + ", "
         @geo += current_user.region.name + " " + t('and') + " " + t("#{bills[0].class.name.pluralize.downcase}.federal") + " " + t('level')
       end
    end
  end
  
  
  protected
  def permission_denied
    flash[:error] = t('custom_error.perm_denied')
    redirect_to root_url
  end
  
  def set_layout
    (cookies[:tutorial] == "true") ? "tutorial" : "application"
  end
end
