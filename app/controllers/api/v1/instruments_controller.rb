class Api::V1::InstrumentsController < ApplicationController
  include DefaultShowHandler
  include DefaultIndexHandler
  include DefaultDestroyHandler
  include DefaultCreateHandler
  include DefaultUpdateHandler

  private

  def permitted_params
    %i[ticker name exchange_id]
  end

  def model_params
    params.require(:instrument).permit(*permitted_params)
  end
end

