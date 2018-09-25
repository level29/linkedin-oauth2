require 'time'
module LinkedIn
  # People APIs
  #
  # @see https://developer.linkedin.com/docs/guide/v2/people
  # @see https://developer.linkedin.com/docs/guide/v2/people/profile-api Profile API
  # @see https://developer.linkedin.com/docs/ref/v2/profile/basic-profile Basic Profile Fields
  # @see https://developer.linkedin.com/docs/guide/v2/people/connections-api Connections API
  class People < APIResource
    DEFAULT_CONNECTIONS_OPTIONS = {q: :viewer, count: 50}

    # @!macro new profile_args
    #   @overload me()
    #     Fetches your own profile
    #   @return [LinkedIn::Mash]

    # Retrieve a current member's LinkedIn profile.
    #
    # Required permissions: r_basicprofile, r_fullprofile
    #
    # @see https://developer.linkedin.com/docs/guide/v2/people/profile-api
    # @macro profile_args
    # @macro multi_profile_options
    # def me(options={})
    #   path = me_path(options)
    #   get(path, options)
    # end
    #
    #

    # TODO how to we get pictures? what options should we request?
    # TODO what is q=viewer? in docs
    # Retrieve a list of 1st degree connections for a user who has
    # granted access to his/her account
    #
    # Permissions: r_network
    #
    # @see https://developer.linkedin.com/docs/guide/v2/people/connections-api
    # https://api.linkedin.com/v2/connections?q=viewer&projection=(elements*(to~(id,localizedFirstName,localizedLastName)))
    # @macro profile_args
    def connections(options={})
      opts = DEFAULT_CONNECTIONS_OPTIONS.merge(options)
      path = "/connections"
      get(path, opts)
    end

    private ##############################################################
  end
end
