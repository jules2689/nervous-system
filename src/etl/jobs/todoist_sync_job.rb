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
          # transform SomeOtherTransform, transform_config...

          # # alternate block form
          # transform do |row|
          #   # return row, modified
          # end

          # destination SomeDestination, destination_config...

          post_process do
            puts "Finished processing todoist"
          end
        end
      end
    end
  end
end
