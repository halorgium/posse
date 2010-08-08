class Project < ActiveRecord::Base
  def self.by_param(param)
    where(:name => param).first
  end

  def self.handle(payload)
    Rails.logger.info "Got post-receive: #{payload.inspect}"
  end

  validates_uniqueness_of :name

  has_many :branches

  def to_param
    name
  end
end
