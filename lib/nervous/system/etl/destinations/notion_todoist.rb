module Nervous
  module System
    module ETL
      module Destinations
        class NotionTodoist
          def initialize(env)
            @token = env['NOTION_TOKEN']
            @collection_id = env["NOTION_TODOIST_ID"]
            @client = Helpers::NotionAPI.new(@token)
          end

          def write(row)
            notion_id = row.record.notion_id
            response = if notion_id && !notion_id.empty?
              puts "Updating #{notion_id} : #{row.record.title}"
              @client.update_page(notion_id, properties: row.properties)
            else
              puts "Creating: #{row.record.title}"
              @client.create_page({ "database_id" => @collection_id }, properties: row.properties)
            end

            if response["object"] == "page"
              row.record.update(notion_id: response["id"])
            end
          end
        end
      end
    end
  end
end
