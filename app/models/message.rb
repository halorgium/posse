class Message
  class DeployRequest < Struct.new(:cluster, :branch, :force, :user, :source)
    def reply(body)
      Message.say(source, "#{user}, #{body}")
    end
  end

  def self.handle(payload)
    new(payload).handle
  end

  def initialize(payload)
    @payload = payload
  end
  attr_reader :payload

  def handle
    Rails.logger.info "Got irc: #{payload.inspect}"
    case payload.body
    when /^(?:ship|deploy) ([-\w_]+)(?: ([-\w_]+))?$/
      request = DeployRequest.new($1, $2, false, user, source)
      Cluster.deploy(request)
    when /^(?:force) ([-\w_]+)(?: ([-\w_]+))?$/
      request = DeployRequest.new($1, $2, true, user, source)
      Cluster.deploy(request)
    when /^check (\w+)$/
      say(source, user + ", checking is not yet implemented")
    else
      say(source, user + ", what do you mean: " + body);
    end
  end

  def body
    payload.body
  end

  def user
    payload.user
  end

  def source
    payload.source
  end

  def say(destination, body)
    self.class.say(destination, body)
  end

  def self.say(destination, body)
    callback = "http://ec2-174-129-31-245.compute-1.amazonaws.com:8001/callback"
    Net::HTTP.post_form(URI(callback), {:body => body, :to => destination})
    nil
  rescue Errno::ECONNREFUSED => e
    Rails.logger.error("#{e.class}: #{e.message}")
    Rails.logger.debug(e.backtrace.join("\n"))
    nil
  end
end
