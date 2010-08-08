class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    render
  end

  def new
    @project = Project.new
    render
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def show
    @project = Project.by_param(params[:id])
    @branches = @project.latest_branches
    @builds = @project.latest_builds
    render
  end
end
