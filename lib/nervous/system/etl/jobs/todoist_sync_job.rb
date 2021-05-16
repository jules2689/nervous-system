module Nervous
  module System
    module ETL
      module Jobs
        module TodoistSyncJob
          module_function
          
          def setup(config)
            if config[:backend] && !Nervous::System::SUPPORTED_BACKENDS.include?(config[:backend])
              raise "Unsupported backend: #{config[:backend]}. Supported backends: #{Nervous::System::SUPPORTED_BACKENDS.join(', ')}"
            end

            Kiba.parse do
              pre_process do
                puts "Running Todoist ETL with backend #{config[:backend]}"
              end

              source ETL::Sources::Todoist, config[:env]
              transform ETL::Transformers::TodoistActiveRecord

              case config[:backend]
              when Nervous::System::SUPPORTED_NOTION_BACKEND
                transform ETL::Transformers::TodoistNotion
                destination ETL::Destinations::NotionTodoist, config[:env]
              end

              post_process do
                puts "Finished processing todoist"
              end
            end
          end
        end
      end
    end
  end
end
