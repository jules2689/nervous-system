# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Jobs
        module TodoistSyncJob
          module_function

          def setup(config)
            if config[:backend] && !Nervous::System::SUPPORTED_BACKENDS.include?(config[:backend])
              raise "Unsupported backend: #{config[:backend]}. " \
                "Supported backends: #{Nervous::System::SUPPORTED_BACKENDS.join(", ")}"
            end

            Kiba.parse do
              extend Kiba::Common::DSLExtensions::Logger

              pre_process do
                logger.info "Running Todoist ETL with backend #{config[:backend]}"
              end

              source ETL::Sources::Todoist, config[:env], logger
              transform ETL::Transformers::TodoistActiveRecord, logger

              case config[:backend]
              when Nervous::System::SUPPORTED_NOTION_BACKEND
                transform ETL::Transformers::TodoistNotion, logger
                destination ETL::Destinations::NotionTodoist, config[:env], logger
              end

              post_process do
                logger.info "Finished processing todoist"
              end
            end
          end
        end
      end
    end
  end
end
