module ETL
  module Jobs
    module TodoistSyncJob
      module_function
      
      def setup(config)
        Kiba.parse do
          pre_process do
            puts "Running Todoist ETL"
          end

          source ETL::Sources::Todoist, ENV
          transform ETL::Transformers::TodoistActiveRecord
          transform ETL::Transformers::TodoistNotion
          destination ETL::Destinations::NotionTodoist, ENV

          post_process do
            puts "Finished processing todoist"
          end
        end
      end
    end
  end
end
