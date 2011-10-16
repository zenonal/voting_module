class LanguageController < ApplicationController
  def fra
    I18n.locale = :fr
    Rails.cache.write("locales_page", true)
    redirect_to session[:jumpback] 
	end
	
  def eng
    I18n.locale = :en
    Rails.cache.write("locales_page", true)
    redirect_to session[:jumpback] 
	end
	
  def ndl
    I18n.locale = :nl
    Rails.cache.write("locales_page", true)
    redirect_to session[:jumpback] 
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
end
