require 'rack/openid'
require 'gapps_openid'
require 'omniauth/openid'

module OmniAuth
  module Strategies
    class OpenID
      include OmniAuth::Strategy
      
      attr_accessor :options
      
      # Should be 'openid_url'
      # @see http://github.com/intridea/omniauth/issues/issue/13
      IDENTIFIER_URL_PARAMETER = 'identifier'
      
      AX = {
        :email => 'http://axschema.org/contact/email',
        :name => 'http://axschema.org/namePerson',
        :nickname => 'http://axschema.org/namePerson/friendly',
        :first_name => 'http://axschema.org/namePerson/first',
        :last_name => 'http://axschema.org/namePerson/last',
        :city => 'http://axschema.org/contact/city/home',
        :state => 'http://axschema.org/contact/state/home',
        :website => 'http://axschema.org/contact/web/default',
        :image => 'http://axschema.org/media/image/aspect11'
      }
      
      def initialize(app, store = nil, options = {})
        super(app, options[:name] || :open_id)
        @options = options
        @options[:required] ||= [AX[:email], AX[:first_name], AX[:last_name], 'email', 'fullname']
        @options[:optional] ||= [AX[:nickname], AX[:city], AX[:state], AX[:website], AX[:image], 'postcode', 'nickname']
        @store = store
      end
      
      def dummy_app
        lambda{|env| [401, {"WWW-Authenticate" => Rack::OpenID.build_header(
          :identifier => identifier,
          :return_to => callback_url,
          :required => @options[:required],
          :optional => @options[:optional]
        )}, []]}
      end
      
      def callback_url
        uri = URI.parse(request.url)
        uri.path += '/callback'
        uri.to_s
      end
      
      def identifier
        request[IDENTIFIER_URL_PARAMETER]
      end
      
      def request_phase
        identifier ? start : get_identifier
      end
      
      def start
        openid = Rack::OpenID.new(dummy_app, @store)
        response = openid.call(env)
        case env['rack.openid.response']
        when Rack::OpenID::MissingResponse, Rack::OpenID::TimeoutResponse
          fail!(:connection_failed)
        else
          response
        end
      end
      
      def get_identifier
        OmniAuth::Form.build('OpenID Authentication') do
          label_field('OpenID Identifier', IDENTIFIER_URL_PARAMETER)
          input_field('url', IDENTIFIER_URL_PARAMETER)
        end.to_response
      end
      
      def callback_phase
        env['REQUEST_METHOD'] = 'GET'
        
        openid = Rack::OpenID.new(lambda{|env| [200,{},[]]}, @store)
        openid.call(env)
        resp = env.delete('rack.openid.response')
        if resp && resp.status == :success
          request['auth'] = auth_hash(resp)
          @app.call(env)
        else
          fail!(:invalid_credentials)
        end
      end
      
      def auth_hash(response)
        OmniAuth::Utils.deep_merge(super(), {
          'uid' => response.display_identifier,
          'user_info' => user_info(response)
        })
      end
      
      def user_info(response)
        sreg_user_info(response).merge(ax_user_info(response))
      end
      
      def sreg_user_info(response)
        sreg = ::OpenID::SReg::Response.from_success_response(response)
        return {} unless sreg
        {
          'email' => sreg['email'],
          'name' => sreg['fullname'],
          'location' => sreg['postcode'],
          'nickname' => sreg['nickname']
        }.reject{|k,v| v.nil? || v == ''}
      end
      
      def ax_user_info(response)
        ax = ::OpenID::AX::FetchResponse.from_success_response(response)
        return {} unless ax
        {
          'email' => ax[AX[:email]],
          'name' => ax[AX[:name]],
          'location' => ("#{ax[AX[:city]]}, #{ax[AX[:state]]}" if Array(ax[AX[:city]]).any? && Array(ax[AX[:state]]).any?),
          'nickname' => ax[AX[:nickname]],
          'urls' => ({'Website' => Array(ax[AX[:website]]).first} if Array(ax[AX[:website]]).any?)
        }.inject({}){|h,(k,v)| h[k] = Array(v).first; h}.reject{|k,v| v.nil? || v == ''}
      end
    end
  end
end
