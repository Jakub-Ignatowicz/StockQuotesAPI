class Api::V1::ExchangesController < ApplicationController
  include DefaultShowHandler
  include DefaultIndexHandler
  include DefaultDestroyHandler
  include DefaultCreateHandler
  include DefaultUpdateHandler

  private

  def permitted_params
    %i[mic name]
  end

  def model_params
    params.require(:exchange).permit(*permitted_params)
  end
end
