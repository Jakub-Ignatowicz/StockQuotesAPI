class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_rescue
  rescue_from ActiveRecord::RecordNotUnique, with: :conflict_rescue
  rescue_from Pagy::OverflowError, with: :bad_request_rescue

  private

  # can't find a way to inject status code into method to create generic error handler

  def conflict_rescue(error)
    render json: { error: }, status: :conflict
  end

  def bad_request_rescue(error)
    render json: { error: }, status: :bad_request
  end

  def not_found_rescue(error)
    render json: { error: }, status: :not_found
  end
end

