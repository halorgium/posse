module Github
  class PostReceive
    def initialize(&block)
      @block = block
    end

    def call(env)
      request = Rack::Request.new(env)
      if payload = Payload.handle(request.params["payload"])
        @block.call(payload)
        Rack::Response.new(["handled"], 201).finish
      else
        Rack::Response.new(["bad request"], 400).finish
      end
    end
  end
end
