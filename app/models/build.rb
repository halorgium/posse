class Build < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  default_url_options[:host] = "posse.halorgium.net"

  belongs_to :commit
  belongs_to :branch
  has_many :deploys

  def deploy(request, cluster)
    if cluster.important? && successfully_deployed?
      request.reply("#{name} already deployed #{short_identifier}")
    else
      deploy = deploys.new(:cluster_id => cluster, :user => request.user, :source => request.source, :force => request.force)
      if deploy.save
        deploy.run
      else
        raise "Invalid deploy: #{deploy.errors.inspect}"
      end
    end
  end

  def successfully_deployed?
    deploys.where(:cluster_id => cluster, :status => true).any?
  end

  def run
    Building.enqueue(id)
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
    Message.say("#minion-", "#{project_name} (#{branch_name}): #{human_status}. #{url}")
  end

  def url
    url_for(self)
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

  def succeeded?
    status == "succeeded"
  end

  def human_status
    if succeeded?
      "Built #{short_identifier} successfully"
    elsif failed?
      "Built #{short_identifier} and failed"
    else
      "Unknown status: #{short_identifier}"
    end
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

  def project
    branch.project
  end

  def project_name
    project.name
  end
end
