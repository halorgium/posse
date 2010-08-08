class Deploy < ActiveRecord::Base
  belongs_to :cluster
  belongs_to :build

  def status
    if started_at
      if completed_at
        if success?
          "succeeded"
        else
          "failed"
        end
      else
        "deploying"
      end
    else
      "pending"
    end
  end
end
