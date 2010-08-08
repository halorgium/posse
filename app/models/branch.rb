class Branch < ActiveRecord::Base
  belongs_to :project

  def build(payload)
    # TODO
  end
end
