module Irc
  class Payload
    def self.handle(json)
      new(json).handle
    end

    def initialize(json)
      @json = json
    end
    attr_reader :json

    def handle
      if valid?
        self
      end
    end

    def inspect
      "#<Irc::Message body=#{body.inspect} user=#{user.inspect} source=#{source.inspect}>"
    end

    def body
      data["body"]
    end

    def user
      data["user"]
    end

    def source
      data["source"]
    end

    def valid?
      body && user && source
    end

    def data
      @data ||= JSON.parse(json)
    end
  end
end
