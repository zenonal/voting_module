Rails.application.config.middleware.use OmniAuth::Builder do
  
        provider :twitter, '0gri1SFWIKogZJ3maGfPEQ', 'FqwS7NtvTb5H0eWttQ2w6PRtQjgLXBdzqKaBeptZQ'
        if ENV['RAILS_ENV'] == 'development'
                provider :facebook, '202977543065805', '7d528a25c5c42fea923abe4cc32d02a7' 
        else
                provider :facebook, '112773305478994', 'dca7a2c9691e5f513909f89efbd190a5',
                        {:scope => 'email', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
        end
  provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :domain => 'gmail.com'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
  provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  provider :linked_in, 'm4rA1MJuUuxTjMfLVWYSReXhaf8sPQCjRPbHJCORebTuQs93BII0a25PmHQrL8oA', 'hXsbcCZe-jtpbhLVq7JvQq1wAFrxhDtt5E73FkWEqtLJJGkCJDsqPvvXDNfh-ZPO'
end

class OmniAuth::Strategies::Facebook
  def callback_phase
    env['REQUEST_METHOD'] = 'GET'
    openid = Rack::Facebook.new(lambda{|env| [200,{},[]]}, @store)
    openid.call(env)
    @openid_response = env.delete('rack.facebook.response')
    ActiveRecord::Base.logger.debug "###########" + @openid_response.to_yaml + "#########"

    if @openid_response && @openid_response.status == :success
      super
    else
      fail!(:invalid_credentials)
    end
  end
end