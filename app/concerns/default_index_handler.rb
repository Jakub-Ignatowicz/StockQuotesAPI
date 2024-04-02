module DefaultIndexHandler
  extend ActiveSupport::Concern

  include ModelClassHelper
  include Pagy::Backend

  def index
    items = params[:items]
    items = 100 if items.to_i > 100

    query = model_class.all

    permitted_params.each do |param|
      query = query.where(param => params[param]) if params[param].present?
    end

    @pagy, @records = pagy(query, items:)
    @records = model_representer.new(@records).as_json

    @pagy_metadata = pagy_metadata(@pagy)

    render json: {
      records: @records,
      pagination: {
        current_page: @pagy_metadata[:page],
        pages_count: @pagy_metadata[:pages],
        render_count: @pagy_metadata[:items],
        items_count: @pagy_metadata[:count],
        prev_url: @pagy_metadata[:prev_url],
        next_url: @pagy_metadata[:next_url]
      }
    }
  end
end
