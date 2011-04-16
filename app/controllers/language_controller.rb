class LanguageController < ApplicationController
  def fra
    I18n.locale = :fr
    Rails.cache.write("locales_page", true)
    redirect_to root_url
	end
	
  def eng
    I18n.locale = :en
    Rails.cache.write("locales_page", true)
    redirect_to root_url
	end
	
  def ndl
    I18n.locale = :nl
    Rails.cache.write("locales_page", true)
    redirect_to root_url
	end

end
