class ClustersController < ApplicationController
  before_filter :fetch_project, :only => [:index, :new, :create]

  def index
    @clusters = @project.clusters
    render
  end

  def new
    @cluster = @project.clusters.new
    render
  end

  def create
    @cluster = @project.clusters.new(params[:cluster])
    if @cluster.save
      redirect_to @cluster
    else
      render :new
    end
  end

  def show
    @cluster = Cluster.find(params[:id])
    render
  end

  private

  def fetch_project
    @project = Project.by_param(params[:project_id])
  end
end
