class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.xml
 
  def index
    @authentications = current_user.authentications if current_user
  end

  # POST /authentications
  # POST /authentications.xml
  def create
    #render :text => request.env["omniauth.auth"].to_yaml
    #if false
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = t('devise.sessions.signed_in')
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = t('devise.sessions.signed_in')
      redirect_to authentications_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = t('devise.sessions.signed_in')
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  #end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.xml
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = t('devise.sessions.signed_out')
    redirect_to authentications_url
  end
  
  def facebook_setup
          unless ENV['RAILS_ENV'] == 'development'
                  if request.domain == "jegouverne.be"
                          request.env['omniauth.strategy'].client_id = '287319927971980'
                          request.env['omniauth.strategy'].client_secret = 'a6f58a5519f19c3033b8d5b6b7655374'
                          
                  elsif request.domain == "ikbestuur.be"
                          request.env['omniauth.strategy'].client_id = '204872852931427'
                          request.env['omniauth.strategy'].client_secret = 'fc1ee3542c4f91b11a8b7b1099de2bf5'
                  elsif request.domain == "heroku.com"
                            request.env['omniauth.strategy'].client_id = '112773305478994'
                            request.env['omniauth.strategy'].client_secret = 'dca7a2c9691e5f513909f89efbd190a5'
                            
                  end
                  render :text => "Setup complete.", :status => 404 
          else
                 request.env['omniauth.strategy'].client_id = '202977543065805'
                 request.env['omniauth.strategy'].client_secret = '7d528a25c5c42fea923abe4cc32d02a7'
                 render :text => "Setup complete.", :status => 404 
          end
      
  end
  def twitter_setup
            unless ENV['RAILS_ENV'] == 'development'
                    if request.domain == "jegouverne.be"
                            request.env['omniauth.strategy'].client_id = 'ObhPkGCJXF4QjYPEBqbA'
                            request.env['omniauth.strategy'].client_secret = 'CjOWc4g4uTFOjUAEDeGSUzMa1HV8B0vutsY2WhKLmkI'

                    elsif request.domain == "ikbestuur.be"
                            request.env['omniauth.strategy'].client_id = 'tRZ0xhSBLUJeVYrNVmKHg'
                            request.env['omniauth.strategy'].client_secret = 'UyyzfmQgPchbBorlbhDsP0FtOJno2oKWVGmcEABB3eA'
                    end
                    render :text => "Setup complete.", :status => 404 
            end
    end
    def linkedin_setup
            unless ENV['RAILS_ENV'] == 'development'
                        if request.domain == "jegouverne.be"
                                request.env['omniauth.strategy'].client_id = 'wn09b4ip1mth'
                                request.env['omniauth.strategy'].client_secret = 'lwUvn9smnqEBAkHc'

                        elsif request.domain == "ikbestuur.be"
                                request.env['omniauth.strategy'].client_id = '8xh06kps8p52'
                                request.env['omniauth.strategy'].client_secret = 'KmyqdbdZvHuHNhwy'
                        end
                        render :text => "Setup complete.", :status => 404 
                end
            
    end
end
