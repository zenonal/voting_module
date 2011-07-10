class ApplicationController < ActionController::Base
        layout "application"
        protect_from_forgery
        unless ENV['RAILS_ENV']=="development" 
        include ::SslRequirement
        end
        helper_method :filter_index

        before_filter :set_locale
        before_filter :set_mode
        before_filter {|c| Authorization.current_user = c.current_user}
        before_filter :set_featured
        before_filter :mailer_set_url_options
        before_filter :jumpback
        
        
        def default_url_options(options={})
                #logger.debug "default_url_options is passed options: #{options.inspect}\n"
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

        def set_featured
                b = Initiative.filter_phase(Initiative.all,2,3,4,5)
                @featured_bills = [b[rand(b.count)]]
                b = Referendum.filter_phase(Referendum.all,2,3,4,5)
                @featured_bills << b[rand(b.count)]
        end

        #helper method
        def filter_index(bills)
                unless bills.blank? || bills.empty?
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
                        if !params[:search].blank?
                                @bills = bills.first.class.name.constantize.search_tank(params[:search], :paginate => false, :function => 1)
                                @bills = eval( "@bills.find_all {|b| b.content_#{I18n.locale} != ''}" )
                                a = Amendment.search_tank(params[:search], :paginate => false, :function => 1)
                                a = a.find_all {|b| b.class.name == "Amendment" }
                                @bills = @bills + a
                        end
                else
                        @bills = []
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
        def mailer_set_url_options
            ActionMailer::Base.default_url_options[:host] = request.host_with_port
        end
        
        def permission_denied
            if params[:controller] == "Initiative" || params[:controller] == "Amendment"
                if ((params[:action] == :create) || (params[:action] == :new)) && user.commune.nil?
                        flash[:error] = "blabla"
                        redirect_to root_url
                else
                        flash[:error] = t('custom_error.perm_denied')
                        redirect_to root_url
                end
            else
                flash[:error] = t('custom_error.perm_denied')
                redirect_to root_url
            end
        end

        def set_layout
                (cookies[:tutorial] == "true") ? "tutorial" : "application"
        end
        def jumpback
            session[:jumpback] = session[:jumpcurrent]
            session[:jumpcurrent] = request.request_uri
          end  

         def rescue_action_in_public(exception)
            case exception
             when ::ActionController::RedirectBackError
               jumpto = session[:jumpback] || {:controller => "/pages"}
               redirect_to jumpto
             else
               super
             end
          end
end
