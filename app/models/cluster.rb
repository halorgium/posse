class Cluster < ActiveRecord::Base
  validates_presence_of :name, :cloud_name
  validates_uniqueness_of :name, :scope => :project_id
  validates_uniqueness_of :irc_name

  belongs_to :project
  has_many :deploys

  def self.deploy(request)
    Rails.logger.info("Got deploy request: #{request.inspect}")
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
