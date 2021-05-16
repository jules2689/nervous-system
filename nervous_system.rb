# frozen_string_literal: true

require "rubygems"
require "bundler/setup"
require "active_record"
require "kiba"
require "dotenv/load"

ROOT = File.expand_path("..", __dir__)
$LOAD_PATH.unshift(File.join(ROOT, "src"))

@environment = ENV["RACK_ENV"] || "development"
@dbconfig = YAML.safe_load(File.read(File.join(ROOT, "db/config.yml")))
ActiveRecord::Base.establish_connection @dbconfig[@environment]

Dir.glob(File.join(ROOT, "src/**/*.rb")).sort.each { |f| require f }
