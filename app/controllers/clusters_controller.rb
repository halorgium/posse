class ClustersController < ApplicationController
  def index
    @project = Project.by_param(params[:project_id])
    @clusters = @project.clusters
    render
  end

  def show
    @cluster = Cluster.find(params[:id])
    render
  end
end
