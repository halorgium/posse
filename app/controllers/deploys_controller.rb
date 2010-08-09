class DeploysController < ApplicationController
  def show
    @deploy = Deploy.find(params[:id])
    render
  end
end
