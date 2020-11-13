class V1::StoresController < ApplicationController
  def index
    @stores = Store.all
  end
end
