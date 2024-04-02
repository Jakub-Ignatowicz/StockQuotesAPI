module DefaultDestroyHandler
  extend ActiveSupport::Concern

  include ModelClassHelper
  include Pagy::Backend

  def destroy
    record = model_class.find(params[:id])

    record.destroy!
    render json: model_representer.new(record).as_json, status: :ok
  end
end
