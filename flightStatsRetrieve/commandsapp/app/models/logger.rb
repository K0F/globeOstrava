


#require File.expand_path('../boot', __FILE__)
require 'flightstats'
require 'rails'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module RubyInRailsApp
  class Application < Rails::Application
    # the new line added for autoload of lib
    config.autoload_paths += %W(#{config.root}/lib)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    FlightStats.app_id = '7584d207'
    FlightStats.app_key = '9f429b1d65cba4eccccb4b7158470673'
    FlightStats.logger = Rails.logger


    flight_tracks = FlightStats::FlightStatus.track_departing_on 'UA', 901, 2013, 5, 1

    flight_tracks.puts  end
end


