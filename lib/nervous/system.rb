# frozen_string_literal: true

require_relative "system/version"
begin
  require "dotenv/load"
rescue LoadError
  # Dotenv is not available
  # do nothing
end
require "active_record"
require "kiba"

# Load various files from the `lib` directory
ROOT = File.expand_path("../../", __FILE__)
Dir.glob(File.join(ROOT, "models/**/*.rb")).each { |f| require f }
Dir.glob(File.join(ROOT, "helpers/**/*.rb")).each { |f| require f }
Dir.glob(File.join(ROOT, "nervous/**/*.rb")).each { |f| require f }

# Load ActiveRecord connection
@environment = ENV['RACK_ENV'] || 'development'
@dbconfig = YAML.load(File.read(File.join(ROOT, 'db/config.yml')))
ActiveRecord::Base.establish_connection(@dbconfig[@environment])

module Nervous
  module System
    class Error < StandardError; end
  end
end
