class LanguageController < ApplicationController
        def fra
                I18n.locale = :fr
                Rails.cache.write("locales_page", true)
                if ENV['RAILS_ENV']=="production" 
                        cookies.permanent[:choose_lang] = {
                                :value => false,
                                :domain => set_domain
                        }
                else
                        cookies.permanent[:choose_lang] = false
                end
                unless session[:jumpback_no_locale].nil?
                        redirect_to session[:jumpback_no_locale]
                else
                        redirect_to root
                end
        end

        def eng
                I18n.locale = :en
                Rails.cache.write("locales_page", true)
                if ENV['RAILS_ENV']=="production" 
                        cookies.permanent[:choose_lang] = {
                                :value => false,
                                :domain => set_domain
                        }
                else
                        cookies.permanent[:choose_lang] = false
                end
                unless session[:jumpback_no_locale].nil?
                        redirect_to session[:jumpback_no_locale]
                else
                        redirect_to root
                end
        end

        def ndl
                I18n.locale = :nl
                Rails.cache.write("locales_page", true)
                if ENV['RAILS_ENV']=="production" 
                        cookies.permanent[:choose_lang] = {
                                :value => "false",
                                :domain => set_domain
                        }
                else
                        cookies.permanent[:choose_lang] = false
                end
                unless session[:jumpback_no_locale].nil?
                        redirect_to session[:jumpback_no_locale]
                else
                        redirect_to root
                end
        end

        def info
                if cookies[:info_active] == "true"
                        cookies[:info_active] = false
                else
                        cookies[:info_active] = true
                end
                redirect_to session[:jumpback] 
        end
        def intro
                if cookies[:show_intro] == "true"
                        cookies[:show_intro] = false
                else
                        cookies[:show_intro] = true
                end
                redirect_to session[:jumpback] 
        end
        
        
        private
        def set_domain
                if request.domain == "heroku.com"
                        dom = ".votingmodule.heroku.com"
                        return dom
                elsif request.domain == "jegouverne.be"
                        dom = ".jegouverne.be"
                        return dom
                elsif request.domain == "ikregeer.be"
                        dom = ".ikregeer.be"
                        return dom
                end
        end
end
