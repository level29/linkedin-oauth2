module LinkedIn
  # Share and Social Stream APIs
  #
  # @see https://developer.linkedin.com/docs/guide/v2/shares
  # @see https://developer.linkedin.com/docs/guide/v2/shares/share-api Share API
  #
  #
  class ShareAndSocialStream < APIResource
    # Create a share for the authenticated user
    #
    # Permissions: w_share
    #
    # @see https://developer.linkedin.com/docs/guide/v2/shares/share-api
    #
    # @macro share_input_fields
    # @return [void]
    def add_share(share)
      path = "/shares"
      defaults = {distribution: {linkedInDistributionTarget: {visibleToGuest: "true"}}}
      post(path, MultiJson.dump(defaults.merge(share)))
    end
  end
end
