require 'cgi'
require 'uri'

module OmniAuth
  module Strategies
    class OAuth2
      include OmniAuth::Strategy
      
      def initialize(app, name, client_id, client_secret, options = {})
        super(app, name)
        @options = options
        @client = ::OAuth2::Client.new(client_id, client_secret, options)
      end
      
      attr_accessor :client_id, :client_secret, :options
      
      def request_phase(options = {})
        redirect @client.web_server.authorize_url({:redirect_uri => callback_url}.merge(options))
      end
      
      def callback_phase
        verifier = request.params['code']
        @access_token = @client.web_server.get_access_token(verifier, :redirect_uri => callback_url)
        super
      rescue ::OAuth2::HTTPError => e
        fail!(:invalid_credentials)
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'credentials' => {
            'token' => @access_token.token
          }
        })
      end
    end
  end
end