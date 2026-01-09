# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::BadRequest do |exception|
      render_error(exception, :bad_request)
    end

    rescue_from ActiveRecord::NotNullViolation do |exception|
      render_error(exception, :bad_request)
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      render_error(exception, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      render_error(exception, :not_found)
    end

    rescue_from Error::Unauthorized do |exception|
      render_error(exception, :unauthorized)
    end
  end

  private

  def render_error(exception, status = 500)
    render json: {
      message: exception.message,
      errors: exception.try(:record).try(:errors)
    }, status: status
  end
end
