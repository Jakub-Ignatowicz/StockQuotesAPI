module DefaultUpdateHandler
  extend ActiveSupport::Concern

  include ModelClassHelper

  def update
    record = model_class.find(params[:id])

    if record.update(model_params)
      render json: model_representer.new(record).as_json, status: :ok
    else
      render json: record.errors, status: :unprocessable_entity
    end
  end
end
