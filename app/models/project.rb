class Project < ActiveRecord::Base
  def self.by_param(param)
    where(:name => param).first
  end

  validates_uniqueness_of :name

  has_many :branches

  def to_param
    name
  end
end
