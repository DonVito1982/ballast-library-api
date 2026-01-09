# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

LOCALHOST_REGEX = %r{\Ahttp:\/\/localhost(:300\d)?\z}.freeze

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    hosts = []
    hosts << LOCALHOST_REGEX if Rails.env.development?

    origins hosts

    resource "*",
      headers: :any,
      credentials: true,
      methods: %i[get post put patch delete options head]
  end
end
