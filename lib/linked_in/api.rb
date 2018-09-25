module LinkedIn
  class API

    attr_accessor :access_token

    # TODO set bearer token?
    # Or does it work as is
    def initialize(access_token=nil)
      access_token = parse_access_token(access_token)
      verify_access_token!(access_token)
      @access_token = access_token

      @connection = LinkedIn::Connection.new params: default_params,
                                             headers: default_headers

      initialize_endpoints
    end

    extend Forwardable # Composition over inheritance
    def_delegators :@people, :connections

    def_delegators :@messages, :send_message

    def_delegators :@share_and_social_stream, :add_share,


    private ##############################################################

    def initialize_endpoints
      @people = LinkedIn::People.new(@connection)
      @messages = LinkedIn::Messages.new(@connection)
      @share_and_social_stream = LinkedIn::ShareAndSocialStream.new(@connection)
    end

    def default_params
      # https//developer.linkedin.com/documents/authentication
      return {oauth2_access_token: @access_token.token}
    end

    def default_headers
      # https://developer.linkedin.com/docs/guide/v2/concepts/protocol-version
      return {"X-RestLi-Protocol-Version".freeze => "2.0.0".freeze}
    end

    def verify_access_token!(access_token)
      if not access_token.is_a? LinkedIn::AccessToken
        raise no_access_token_error
      end
    end

    def parse_access_token(access_token)
      if access_token.is_a? LinkedIn::AccessToken
        return access_token
      elsif access_token.is_a? String
        return LinkedIn::AccessToken.new(access_token)
      end
    end

    def no_access_token_error
      msg = LinkedIn::ErrorMessages.no_access_token
      LinkedIn::InvalidRequest.new(msg)
    end
  end
end
