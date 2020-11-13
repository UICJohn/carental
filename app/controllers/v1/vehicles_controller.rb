module V1
  class VehiclesController < ApplicationController
    def index
      @vehicles = VehiclesSearch.new(search_params).search
    end

    def show
      @vehicle = Vehicle.find_by(id: params[:id])
    end

    private

    def search_params
      params.permit(:pick_up_store_id, :starts_at, :expires_at)
    end
  end
end
