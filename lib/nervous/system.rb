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
require "kiba-common/dsl_extensions/logger"

module Nervous
  module System
    class Error < StandardError; end

    SUPPORTED_BACKENDS = [
      SUPPORTED_NOTION_BACKEND = :notion
    ].freeze

    def self.root
      File.expand_path("..", __dir__)
    end
  end
end

# Load various files from the `lib` directory
Dir.glob(File.join(Nervous::System.root, "models/**/*.rb")).sort.each { |f| require f }
Dir.glob(File.join(Nervous::System.root, "helpers/**/*.rb")).sort.each { |f| require f }
Dir.glob(File.join(Nervous::System.root, "nervous/**/*.rb")).sort.each { |f| require f }

# Load ActiveRecord connection
@environment = ENV["RACK_ENV"] || "development"
@dbconfig = YAML.safe_load(File.read(File.join(Nervous::System.root, "db/config.yml")))
ActiveRecord::Base.establish_connection(@dbconfig[@environment])
