# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    # Catch-all for unhandled errors (must be first, as rescue_from is evaluated in reverse order)
    rescue_from StandardError do |exception|
      log_internal_error(exception)
      render_error(exception, :internal_server_error)
    end

    rescue_from ActionController::BadRequest do |exception|
      render_error(exception, :bad_request)
    end

    rescue_from ActionController::ParameterMissing do |exception|
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

    rescue_from ActiveRecord::InvalidForeignKey do |exception|
      render_error(exception, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotDestroyed do |exception|
      render_error(exception, :unprocessable_entity)
    end

    rescue_from Error::Unauthorized do |exception|
      render_error(exception, :forbidden)
    end
  end

  private

  def render_error(exception, status = :internal_server_error)
    error_response = { message: exception.message }

    # Add validation errors if present
    if exception.respond_to?(:record) && exception.record&.errors&.any?
      error_response[:errors] = exception.record.errors.messages
    end

    render json: error_response, status: status
  end

  def log_internal_error(exception)
    Rails.logger.error({
      error_class: exception.class.name,
      error_message: exception.message,
      backtrace: exception.backtrace&.first(10),
      request_id: request.request_id,
      user_id: current_user&.id,
      path: request.path,
      method: request.method,
      params: request.params.except(:controller, :action)
    }.to_json)
  end
end
