# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Destinations
        class Base < ETL::Base
          def final_log(message)
            @logger.info "└── [#{self.class.name.split('::').last}] #{message}"
          end
        end
      end
    end
  end
end
