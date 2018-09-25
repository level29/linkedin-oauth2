module LinkedIn
  # The abstract class all API endpoints inherit from. Providers common
  # builder methods across all endpoints.
  #
  # TODO update these
  # Or remove.. if we don't want to support this
  # @!macro profile_options
  #   @options opts [String] :id LinkedIn ID to fetch profile for
  #   @options opts [String] :url The profile url
  #   @options opts [String] :lang Requests the language of the profile.
  #     Options are: en, fr, de, it, pt, es
  #   @options opts [Array, Hash] :fields fields to fetch. The list of
  #     fields can be found at
  #     https://developer.linkedin.com/documents/profile-fields
  #   @options opts [String] :secure (true) specify if urls in the
  #     response should be https
  #   @options opts [String] :"secure-urls" (true) alias to secure option
  #
  # @!macro share_input_fields
  # TODO images for thumbnail size
  # - Maximum metadata size: 256k
  # - Maximum file size: 7680kb
  # - Minimum image width: 150px
  # - Minimum image height: 80px
  #   @param [Hash] share content of the share
  #   @option share [String] :owner The URN of the owner of the share
  #   @option share [Hash] :text
  #     * :text (String) The share text
  #   @option share [String] :subject
  #   @option share [Hash] :distribution
  #     * :linkedInDistributionTarget (Hash)
  #   @option share [Hash] :content
  #     * :contentEntities [Hash]
  #       * :entityLocation [String] Url of share content
  #       * :thumbnails [optional, Hash]
  #     * :title [String] Title of the content
  #     * :description [String] Description of the content
  #
  #
  class APIResource

    def initialize(connection)
      @connection = connection
    end

    protected ############################################################

    def get(path, options={})
      url, params, headers = prepare_connection_params(path, options)

      response = @connection.get(url, params, headers)

      return Mash.from_json(response.body)
    end

    def post(path=nil, body=nil, headers=nil, &block)
      @connection.post(prepend_prefix(path), body, headers, &block)
    end

    def put(path=nil, body=nil, headers=nil, &block)
      @connection.put(prepend_prefix(path), body, headers, &block)
    end

    def delete(path=nil, params=nil, headers=nil, &block)
      @connection.delete(prepend_prefix(path), params, headers, &block)
    end

    def deprecated
      LinkedIn::Deprecated.new(LinkedIn::ErrorMessages.deprecated)
    end

    private ##############################################################

    def prepend_prefix(path)
      return @connection.path_prefix + path
    end

    # TODO this probably needs to be updated
    def prepare_connection_params(path, options)
      path = prepend_prefix(path)
      path += generate_field_selectors(options)

      headers = options.delete(:headers) || {}

      params = format_options_for_query(options)

      return [path, params, headers]
    end

    # Dasherizes the param keys
    # TODO why is this needed?
    def format_options_for_query(options)
      options.reduce({}) do |list, kv|
        key, value = kv.first.to_s.gsub("_","-"), kv.last
        list[key]  = value
        list
      end
    end

    def generate_field_selectors(options)
      default = LinkedIn.config.default_profile_fields || {}
      fields = options.delete(:fields) || default

      if options.delete(:public)
        return ":public"
      elsif fields.empty?
        return ""
      else
        return ":(#{build_fields_params(fields)})"
      end
    end

    def build_fields_params(fields)
      if fields.is_a?(Hash) && !fields.empty?
        fields.map {|i,v| "#{i}:(#{build_fields_params(v)})" }.join(',')
      elsif fields.respond_to?(:each)
        fields.map {|field| build_fields_params(field) }.join(',')
      else
        fields.to_s.gsub("_", "-")
      end
    end
  end
end
