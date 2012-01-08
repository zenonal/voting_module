Rails.application.config.middleware.use OmniAuth::Builder do
  
        provider :twitter, '0gri1SFWIKogZJ3maGfPEQ', 'FqwS7NtvTb5H0eWttQ2w6PRtQjgLXBdzqKaBeptZQ', :setup => true
        
        if ENV['RAILS_ENV'] == 'development'
                provider :facebook, '202977543065805', '7d528a25c5c42fea923abe4cc32d02a7', :setup => true
                
        else
                provider :facebook, '112773305478994', 'dca7a2c9691e5f513909f89efbd190a5',
                        {:setup => true, :scope => 'email', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
        end
  provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :domain => 'gmail.com'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp'), {:name => 'open_id', :identifier => 'https://www.e-contract.be/eid-idp/endpoints/openid/auth', :required => []}
  provider :linked_in, 'm4rA1MJuUuxTjMfLVWYSReXhaf8sPQCjRPbHJCORebTuQs93BII0a25PmHQrL8oA', 'hXsbcCZe-jtpbhLVq7JvQq1wAFrxhDtt5E73FkWEqtLJJGkCJDsqPvvXDNfh-ZPO', 
                :setup => true
end
