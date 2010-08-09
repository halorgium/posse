class Cluster < ActiveRecord::Base
  validates_presence_of :name, :cloud_name
  validates_uniqueness_of :name, :scope => :project_id
  validates_uniqueness_of :irc_name

  belongs_to :project
  has_many :deploys

  def self.deploy(request)
    Rails.logger.info("Got deploy request: #{request.inspect}")
    if cluster = where(:irc_name => request.cluster).first
      cluster.deploy(request)
    else
      request.reply("unknown env: #{request.cluster}")
    end
  end

  def deploy(request)
    if allows_user?(request.user)
      if current_deploy.nil? || current_deploy.completed?
        request.branch ||= default_branch

        if allows_branch?(request.branch)
          project.deploy(request, self)
        else
          request.reply("Branch #{request.branch} disallowed for #{irc_name.inspect}")
        end
      else
        request.reply("already deploying #{irc_name}: requested by #{current_deploy.user} in #{current_deploy.source} at #{current_deploy.created_at}")
      end
    else
      request.reply("not allowed to ship #{irc_name}")
    end
  end

  def important?
    %w[staging production].include?(name)
  end

  def allows_user?(user)
    %w[sr halorgium atmos benburkert martinemde larrytheliquid smerritt adelcambre geemus].include?(user)
  end

  def allows_branch?(branch)
    branch_regexp ? branch_regexp =~ branch : true
  end

  def branch_regexp
    branch_restriction && Regexp.new(branch_restriction)
  end

  def current_status
    current_deploy ? current_deploy.status : "unknown"
  end

  def current_deploy
    deploys.order(:updated_at).reverse_order.first
  end

  def default_branch
    read_attribute(:default_branch) || "master"
  end
end
