require "nervous/system"
require 'standalone_migrations'
require 'tasks/standalone_migrations'
ActiveRecord::Base.schema_format = :sql
StandaloneMigrations::Tasks.load_tasks