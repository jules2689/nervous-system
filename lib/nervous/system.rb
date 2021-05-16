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

module Nervous
  module System
    class Error < StandardError; end

    def self.root
      File.expand_path("../../", __FILE__)
    end
  end
end

# Load various files from the `lib` directory
Dir.glob(File.join(Nervous::System.root, "models/**/*.rb")).each { |f| require f }
Dir.glob(File.join(Nervous::System.root, "helpers/**/*.rb")).each { |f| require f }
Dir.glob(File.join(Nervous::System.root, "nervous/**/*.rb")).each { |f| require f }

# Load ActiveRecord connection
@environment = ENV['RACK_ENV'] || 'development'
@dbconfig = YAML.load(File.read(File.join(Nervous::System.root, 'db/config.yml')))
ActiveRecord::Base.establish_connection(@dbconfig[@environment])

