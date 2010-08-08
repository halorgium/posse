class Message
  def self.handle(payload)
    new(payload).handle
  end

  def initialize(payload)
    @payload = payload
  end
  attr_reader :payload

  def handle
    Rails.logger.info "Got irc: #{payload.inspect}"
  end
end
