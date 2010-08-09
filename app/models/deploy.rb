class Deploy < ActiveRecord::Base
  belongs_to :cluster
  belongs_to :build

  def run
    request.reply("#{project_name} (#{branch_name}@#{short_identifier}) to #{cluster_name}: Deploy #{status}")
    run!
  end

  def run!
    update_attributes!(:started_at => DateTime.now)
    Rails.logger.info "Deploying #{identifier} on #{branch_name} for #{project_name} to #{cluster_name}"

    checkout.setup
    checkout.run("#{project.deploy_command} #{cluster.cloud_name.inspect}")

    completed(0)
  rescue Exception => exception
    Posse.raise_if_unsafe(exception)

    status = exception.respond_to?(:exit_status) ? exception.exit_status : nil

    checkout.output << <<-EOT
Exception
#{exception.class}: #{exception.message}
#{exception.backtrace.join("\n")}
    EOT
    completed(status)
  end

  def completed(exit_status)
    log_message = upload_log

    update_attributes!(:completed_at => DateTime.now, :exit_status => exit_status)
    request.reply("#{project_name} (#{branch_name}@#{short_identifier}) to #{cluster_name}: Deploy #{status}. #{log_message}")
  end

  def upload_log
    title = "#{id}: Deploy Log for #{project_name} (#{branch_name}@#{short_identifier}) by #{user}"
    paste = Pastie.new(:code => checkout.output, :language => :plain_text, :title => title)
    paste.save
    update_attributes!(:log_url => paste.url)
    "log @ #{log_url}"
  rescue Exception => exception
    Posse.raise_if_unsafe(exception)

    "failed to upload log: #{exception.class}: #{exception.message}"
  end

  def dir
    @dir ||= Rails.root.join("tmp/checkouts/deploy-#{id}-#{Time.now.to_i}")
  end

  def checkout
    @checkout ||= Checkout.new(project.git_uri, branch_name, identifier, dir)
  end

  def request
    @request ||= Message::DeployRequest.new(cluster_name, build.branch_name, force, user, source)
  end

  def completed?
    completed_at
  end

  def success?
    exit_status == 0
  end

  def succeeded?
    status == "succeeded"
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

  def cluster_name
    cluster.name
  end

  def branch_name
    branch.name
  end

  def project_name
    project.name
  end

  def project
    branch.project
  end

  def branch
    build.branch
  end

  def commit
    build.commit
  end
end
