module DefaultCreateHandler
  extend ActiveSupport::Concern

  include ModelClassHelper
  include Pagy::Backend

  def create
    record = model_class.new(model_params)

    if record.save
      render json: model_representer.new(record).as_json, status: :created
    else
      render json: record.errors, status: :unprocessable_entity
    end
  end
end
