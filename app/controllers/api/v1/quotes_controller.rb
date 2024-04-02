class Api::V1::QuotesController < ApplicationController
  include DefaultShowHandler
  include DefaultIndexHandler
  include DefaultDestroyHandler
  include DefaultCreateHandler
  include DefaultUpdateHandler

  private

  def permitted_params
    %i[time open close high low volume instrument_id]
  end

  def model_params
    params.require(:quote).permit(*permitted_params)
  end
end

