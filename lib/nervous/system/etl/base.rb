# frozen_string_literal: true

module Nervous
  module System
    module ETL
      class Base
        def initialize(logger)
          @logger = logger
        end

        def log(message)
          @logger.info "├── [#{self.class.name.split("::").last}] #{message}"
        end

        def first_log(message)
          @logger.info "┌── [#{self.class.name.split("::").last}] #{message}"
        end

        def final_log(message, error: false)
          if error
            @logger.error "└── [#{self.class.name.split("::").last}] #{message}"
          else
            @logger.info "└── [#{self.class.name.split("::").last}] #{message}"
          end
        end
      end
    end
  end
end
