class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery
  include SslRequirement
  helper_method :filter_index
  
  before_filter :set_locale
  before_filter :set_mode
  before_filter {|c| Authorization.current_user = c.current_user}
  before_filter :set_tutorial
  
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
  
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end
  
  def set_mode
    if cookies[:tutorial_active].blank?
      if user_signed_in?
        if current_user.sign_in_count <= 1
          cookies[:tutorial_active] = true
        else
          cookies[:tutorial_active] = false
        end
      end
    end
  end
  
  def set_tutorial
    if cookies[:tutorial_index].nil?
      cookies[:tutorial_index] = 1
    end
    if defined?(@tutorial_positions).nil? || @tutorial_positions.nil?
      @tutorial_positions= Rails.cache.read('tutorial_positions')
    end
    if @tutorial_positions[params[:controller]] && @tutorial_positions[params[:controller]][params[:action]]
      cookies[:tutorial_length] = @tutorial_positions[params[:controller]][params[:action]].size
      cookies[:tutorial_controller] = params[:controller]
      cookies[:tutorial_action] = params[:action]
      cookies[:tutorial_hposition] = @tutorial_positions[params[:controller]][params[:action]]["step#{cookies[:tutorial_index].to_i}"]["left"]
      cookies[:tutorial_vposition] = @tutorial_positions[params[:controller]][params[:action]]["step#{cookies[:tutorial_index].to_i}"]["top"]
    end
  end
  
  def restart_tutorial
    cookies[:tutorial_index] = 1
    cookies[:tutorial_hposition] = @tutorial_positions[cookies[:tutorial_controller]][cookies[:tutorial_action]]["step#{cookies[:tutorial_index].to_i}"]["left"]
    cookies[:tutorial_vposition] = @tutorial_positions[cookies[:tutorial_controller]][cookies[:tutorial_action]]["step#{cookies[:tutorial_index].to_i}"]["top"]
  end
  
  #helper method
  def filter_index(bills)
    if params[:filter] && params[:filter][:level]
      level = params[:filter][:level].to_i
    else
      level = nil
    end
    if params[:filter] && params[:filter][:phase]
      phase = params[:filter][:phase].to_i
      if (params[:controller] == "referendums") && (phase==2)
        phase = nil
      end
    else  
        phase = nil
    end
    if params[:filter] && level && !(level == 0)
      if params[:user_level] == "off" || current_user.commune.nil?
         @bills = bills.where(:level => level.to_s).all(:order => "created_at DESC")
         @geo = t("#{bills[0].class.name.pluralize.downcase}.level#{level}")
      else
         @bills = bills.user_geographical_level(current_user,level).all(:order => "created_at DESC")
         if level == 1
           @geo = current_user.commune.name
         end
         if level == 2
            @geo = current_user.province.name
         end
         if level == 3
            @geo = current_user.region.name
         end
         if level == 4
            @geo = params[:filter][:level]
         end
      end
    else
       @bills = bills.all(:order => "created_at DESC")
       if params[:user_level] == "off" || !user_signed_in? || current_user.commune.nil?
         @geo = t("#{bills[0].class.name.pluralize.downcase}.no_geo")
       else
         unless current_user.commune.nil?
           @geo = current_user.commune.name + ", " + current_user.province.name + ", "
           @geo += current_user.region.name + " " + t('and') + " " + t("#{bills[0].class.name.pluralize.downcase}.level4") + " " + t('level')
         else
           @geo = t("#{bills[0].class.name.pluralize.downcase}.no_geo")
         end
       end
    end
    if phase && phase >= 0
      @bills = bills[0].class.filter_phase(@bills,phase)
      @phase = t("#{bills[0].class.name.pluralize.downcase}.phase#{phase}")
    else
      @bills = bills[0].class.filter_phase(@bills,2,3,4,5)
      @phase = t("#{bills[0].class.name.pluralize.downcase}.phase_default")
    end
    if params[:filter] && !params[:filter][:category].blank?
      @bills = bills[0].class.filter_category(@bills,params[:filter][:category])
      @categ = params[:filter][:category]
    else
      @categ = t("#{bills[0].class.name.pluralize.downcase}.category_default")
    end
  end
  
  def not_current_languages
    resp = []
    LANGUAGES.each do |l|
      if l.to_sym != I18n.locale
        resp << l
      end
    end
    return resp
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
