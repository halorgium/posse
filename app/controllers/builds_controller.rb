class BuildsController < ApplicationController
  def show
    @build = Build.find(params[:id])
    render
  end
end
