class Project < ActiveRecord::Base
  def self.by_param(param)
    where(:name => param).first
  end

  def self.handle(payload)
    Rails.logger.info "Got post-receive: #{payload.inspect}"
    if project = where(:git_uri => payload.uri).first
      project.build(payload)
    end
  end

  validates_uniqueness_of :name

  has_many :branches
  has_many :commits
  has_many :clusters

  def latest_branches
    branches.order(:created_at).reverse_order.limit(10)
  end

  def latest_builds
    Build.order(:created_at).reverse_order.where(:branch_id => branches).limit(10)
  end

  def build(payload)
    unless branch = branches.where(:name => payload.branch).first
      branch = branches.new(:name => payload.branch)
      branch.save!
    end

    head = payload.head
    unless commit = commits.where(:identifier => head.identifier).first
      commit = commits.new(:identifier => head.identifier)
    end
    commit.commited_at = head.commited_at
    commit.message     = head.message
    commit.author      = head.author
    commit.save!

    branch.build(commit)
  end

  def build_command
    "script/ci"
  end

  def to_param
    name
  end
end
