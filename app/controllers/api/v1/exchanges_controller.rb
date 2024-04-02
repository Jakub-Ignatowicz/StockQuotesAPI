class Api::V1::ExchangesController < ApplicationController
  include DefaultIndexHandler

  private

  def permitted_params
    %i[mic name]
  end

  def model_params
    params.require(:exchange).permit(*permitted_params)
  end
end

