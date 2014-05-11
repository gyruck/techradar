class BlipsController < ApplicationController
  def index
    render locals: { blips: Blip.order(:name).select('distinct name') }
  end

  def show
    blip = Blip.find(params[:id])
    render locals: { blip: blip }
  end
end
