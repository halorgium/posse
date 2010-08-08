module Github
  class Payload
    Commit = Struct.new("Commit", :identifier, :author, :message, :commited_at)

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
      "#<Github::PostReceive::Payload head=#{head.inspect} branch=#{branch.inspect} uri=#{uri.inspect} commits=#{commits.size.inspect}>"
    end

    def valid?
      commits
    end

    def head
      commits.detect { |c| c.identifier == data["after"] }
    end

    def commits
      @commits ||= data["commits"].map do |commit|
        Commit.new(commit["id"],
                   normalize_author(commit["author"]),
                   commit["message"],
                   commit["timestamp"])
      end
    end

    def uri
      if uri = data["uri"]
        return uri
      end

      repository = data["repository"]

      if repository["private"]
        "git@github.com:#{URI(repository["url"]).path[1..-1]}"
      else
        uri = URI(repository["url"])
        uri.scheme = "git"
        uri.to_s
      end
    end

    def branch
      data["ref"].split("refs/heads/").last
    end

    def normalize_author(author)
      "#{author["name"]} <#{author["email"]}>"
    end

    def data
      @data ||= JSON.parse(json)
    end
  end
end
