# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Destinations
        class NotionTodoist < Base
          def initialize(env, logger)
            @token = env["NOTION_TOKEN"]
            @collection_id = env["NOTION_TODOIST_ID"]
            @client = Helpers::NotionAPI.new(@token)
            super(logger)
          end

          def write(row)
            notion_id = row.record.notion_id
            response = if notion_id && !notion_id.empty?
                         final_log("Updating #{notion_id} : #{row.record.title}")
                         @client.update_page(notion_id, properties: row.properties)
                       else
                         final_log("Creating: #{row.record.title}")
                         @client.create_page({ "database_id" => @collection_id }, properties: row.properties)
                       end

            row.record.update(notion_id: response["id"]) if response["object"] == "page"
          end
        end
      end
    end
  end
end
