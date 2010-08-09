class Deploy < ActiveRecord::Base
  belongs_to :cluster
  belongs_to :build

  def run
    request.reply("deploying!!")
    run!
  end

  def run!
    update_attributes!(:started_at => DateTime.now)
    Rails.logger.info "Deploying #{identifier} on #{build.branch_name} for #{build.project_name} to #{cluster.name}"

    checkout.setup
    checkout.run("#{project.deploy_command} #{cluster.cloud_name.inspect}")

    completed(true, checkout.output)
  rescue Exception => exception
    Posse.raise_if_unsafe(exception)

    status = exception.respond_to?(:exit_status) ? exception.exit_status : nil

    checkout.output << <<-EOT
Exception
#{exception.class}: #{exception.message}
#{exception.backtrace.join("\n")}
    EOT
    completed(false, checkout.output)
  end

  def completed(status, output)
    update_attributes!(:completed_at => DateTime.now, :status => status, :output => output)
    request.reply("#{project_name} (#{branch_name}@#{short_identifier}): Deploy #{status}")
  end

  def dir
    @dir ||= Rails.root.join("tmp/checkouts/deploy-#{id}-#{Time.now.to_i}")
  end

  def checkout
    @checkout ||= Checkout.new(project.git_uri, branch_name, identifier, dir)
  end

  def request
    @request ||= Message::DeployRequest.new(cluster.name, build.branch_name, force, user, source)
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

  def short_identifier
    commit.short_identifier
  end

  def branch_name
    branch.name
  end

  def project_name
    branch.project.name
  end

  def branch
    build.branch
  end

  def commit
    build.commit
  end
end
