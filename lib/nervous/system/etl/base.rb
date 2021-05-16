# frozen_string_literal: true

module Nervous
  module System
    module ETL
      class Base
        def initialize(logger)
          @logger = logger
        end

        def log(message)
          @logger.info "├── #{message}"
        end
      end
    end
  end
end
