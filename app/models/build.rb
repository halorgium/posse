class Build < ActiveRecord::Base
  belongs_to :commit
  belongs_to :branch

  def run
    Builder.enqueue(id)
  end

  def run!
    update_attributes!(:started_at => DateTime.now)
    Rails.logger.info "Building #{commit.identifier} on #{branch.name} for #{project.name}"

    checkout.setup
    checkout.run(project.build_command)

    completed(0, checkout.output)
  rescue Exception => exception
    Posse.raise_if_unsafe(exception)

    status = exception.respond_to?(:exit_status) ? exception.exit_status : nil

    checkout.output << <<-EOT
Exception
#{exception.class}: #{exception.message}
#{exception.backtrace.join("\n")}
    EOT
    completed(status, checkout.output)
  end

  def completed(exit_status, output)
    update_attributes!(:completed_at => DateTime.now, :exit_status => exit_status, :output => output)
  end

  def dir
    @dir ||= Rails.root.join("tmp/checkouts/build-#{id}-#{Time.now.to_i}")
  end

  def checkout
    @checkout ||= Checkout.new(project.git_uri, branch_name, identifier, dir)
  end

  def success?
    exit_status == 0
  end

  def status
    if started_at
      if completed_at
        if success?
          "succeeded"
        else
          "failed"
        end
      else
        "running"
      end
    else
      "pending"
    end
  end

  def identifier
    commit.identifier
  end

  def branch_name
    branch.name
  end

  def project
    branch.project
  end
end
