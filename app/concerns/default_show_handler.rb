module DefaultShowHandler
  extend ActiveSupport::Concern

  include ModelClassHelper

  def show
    record = model_class.find_by(id: params[:id])

    if record
      render json: model_representer.new(record).as_json
    else
      render json: { error: "#{model_class.name} not found" }, status: :not_found
    end
  end
end
