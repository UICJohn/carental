module V1
  class VehiclesController < ApplicationController
    def index
      @vehicles = Vehicle.where(active: true)
    end

    def show
      @vehicle = Vehicle.find_by(id: params[:id])
    end
  end
end
