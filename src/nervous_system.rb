require "rubygems"
require "bundler/setup"
require "active_record"
require "dotenv/load"

ROOT = File.expand_path("../../", __FILE__)
$:.unshift(File.join(ROOT, "src"))

@environment = ENV['RACK_ENV'] || 'development'
@dbconfig = YAML.load(File.read(File.join(ROOT, 'db/config.yml')))
ActiveRecord::Base.establish_connection @dbconfig[@environment]

Dir.glob(File.join(ROOT, "src/**/*.rb")).each { |f| require f }
