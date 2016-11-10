require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QAWeb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    # config.paths.add 'lib', glob:'*.rb'
    # config.autoload_paths += Dir[Rails.root.join('lib', '*')]
  end
end
