# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Sources
        class Base < ETL::Base
          def first_log(message)
            @logger.info "┌── [#{self.class.name.split("::").last}] #{message}"
          end
        end
      end
    end
  end
end
