# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Destinations
        class Base < ETL::Base
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
end
