# frozen_string_literal: true

require "geekbot"

module Nervous
  module System
    module ETL
      module Jobs
        module GeekbotSyncJob
          module_function

          def setup(config)
            if config[:backend] && !Nervous::System::SUPPORTED_BACKENDS.include?(config[:backend])
              raise "Unsupported backend: #{config[:backend]}. " \
                "Supported backends: #{Nervous::System::SUPPORTED_BACKENDS.join(", ")}"
            end

            Kiba.parse do
              extend Kiba::Common::DSLExtensions::Logger

              pre_process do
                logger.info "Running Geekbot ETL with backend #{config[:backend]}"
              end

              source ETL::Sources::Geekbot, config[:env], logger
              transform ETL::Transformers::Geekbot::ActiveRecord, logger

              case config[:backend]
              when Nervous::System::SUPPORTED_NOTION_BACKEND
                transform ETL::Transformers::Geekbot::Notion, logger
                destination ETL::Destinations::Notion, config[:env], config[:env]["NOTION_GEEKBOT_ID"], logger
              end

              post_process do
                logger.info "Finished processing Geekbot"
              end
            end
          end
        end
      end
    end
  end
end
