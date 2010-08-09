class Checkout
  class Error < StandardError
    def initialize(exit_status, command, checkout)
      super("Failed to execute command: #{command} returned #{exit_status.inspect}")
      @exit_status = exit_status
      @command     = command
      @checkout    = checkout
    end
    attr_reader :exit_status, :command, :checkout
  end

  def initialize(uri, branch, commit, dir)
    @uri    = uri
    @branch = branch
    @commit = commit
    @dir    = dir

    @uri << ".git" unless @uri[-4..-1] == ".git"
  end

  def setup
    run("git clone #{@uri} #{@dir}", false)
    run("git fetch origin")
    run("git checkout origin/#{@branch}")
    run("git reset --hard #{@commit}")
  end

  def output
    @output ||= ""
  end

  def run(cmd, cd = true)
    dir = cd ? @dir : "/"

    output << "Running #{cmd.inspect}\n"

    ENV["POSSE_GIT_SSHKEY"] = Rails.root.join("config/git.id_rsa")
    ENV["GIT_SSH"]          = Rails.root.join("config/git_ssh")
    status = Open4.spawn(
      "(#{cmd} 2>&1)",
      :dir   => dir,
      :out   => output,
      :err   => output,
      :quiet => true
    )

    output << "Finished #{cmd.inspect}: #{status.exitstatus.inspect}\n"

    unless status.success?
      raise Error.new(status.exitstatus, cmd, self)
    end

    true
  end
end
