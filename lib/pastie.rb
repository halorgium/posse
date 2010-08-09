require 'net/http'
require 'net/https'
require 'json'

class Pastie
  class Error < RuntimeError; end
  class PasteNotCreatedError < Error; end

  USE_NEW_API = true

  def initialize(attributes = {})
    @language = :ruby
    self.attributes = attributes
  end

  attr_accessor :title, :code, :language, :hash, :id
  alias_method :to_s, :code

  def url
    if USE_NEW_API
      "https://pastie.engineyard.com/paste/#{@hash || @id || @_id}"
    else
      "https://pastie.engineyard.com/pastes/#{@hash || @id || @_id}"
    end
  end

  def raw_url
    "#{url}.txt"
  end

  def save
    create! if new_record?
  end

  def attributes=(attributes)
    %w(title hash language code id _id).each do |attribute|
      value = if attributes.has_key? attribute
        attributes[attribute]
      elsif attributes.has_key? attribute.to_sym
        attributes[attribute.to_sym]
      end

      if value
        instance_variable_set("@#{attribute}", value)
      end
    end
  end

  def new_record?
    @id.nil?
  end

  private
    def create!
      if USE_NEW_API
        self.attributes = post("host" => "pastie.engineyard.com", "path" => "/api/paste", "paste[language]" => "text", "paste[code]" => @code, "paste[title]" => @title)
      else
        self.attributes = post("paste[language]" => @language, "paste[code]" => @code)
      end
    end

    def post(parameters = {})
      begin
        host = parameters['host'] || "pastie.engineyard.com"
        path = parameters['path'] || "/pastes.json"
        req = Net::HTTP::Post.new path
        req.set_form_data(parameters.merge({ "pastie_api_key" => "S516sO7c3tMIC29DYxdwZpDw5S3s871UilRrPtoe" }))
        http = Net::HTTP.new(host, 443)
        http.use_ssl = true
        res = http.start do |http|
          http.request(req)
        end
        raise PasteNotCreatedError, "Error occured : #{res.code}" unless res.code =~ /[23]0\d/
        JSON.parse(res.body)
      rescue Timeout::Error => e
        raise PasteNotCreatedError, "Error occured : #{e}"
      end
    end
end
