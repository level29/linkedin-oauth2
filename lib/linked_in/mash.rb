module LinkedIn
  # Coerces LinkedIn JSON to a nice Ruby hash
  # LinkedIn::Mash inherits from Hashie::Mash
  class Mash < ::Hashie::Mash

    # a simple helper to convert a json string to a Mash
    def self.from_json(json_string)
      result_hash = JSON.load(json_string)
      new(result_hash)
    end

    # returns a Date if we have year, month and day, and no conflicting key
    def to_date
      if !self.has_key?('to_date'.freeze) && contains_date_fields?
        Date.civil(self.year, self.month, self.day)
      else
        super
      end
    end

    def timestamp
      value = self['timestamp'.freeze]
      if value.kind_of? Integer
        value = value / 1000 if value > 9999999999
        Time.at(value)
      else
        value
      end
    end


    protected ############################################################


    def contains_date_fields?
      self.year? && self.month? && self.day?
    end

    # overload the convert_key mash method so that the LinkedIn
    # keys are made a little more ruby-ish
    def convert_key(key)
      case key.to_s
      when '_key'.freeze
        'id'.freeze
      when '_total'.freeze
        'total'.freeze
      when 'values'.freeze
        'all'.freeze
      when 'numResults'.freeze
        'total_results'.freeze
      else
        underscore(key)
      end
    end

    # borrowed from ActiveSupport
    # no need require an entire lib when we only need one method
    def underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, '/'.freeze)
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2'.freeze)
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2'.freeze)
      word.tr!("-".freeze, "_".freeze)
      word.downcase!
      word
    end
  end
end
