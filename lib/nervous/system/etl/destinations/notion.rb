# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Destinations
        class Notion < ETL::Base
          def initialize(env, collection_id, logger)
            @collection_id = collection_id
            @client = Helpers::NotionAPI.new(env["NOTION_TOKEN"], env["NOTION_UNOFFICIAL_TOKEN"], env["NOTION_SPACE_ID"])
            super(logger)
          end

          def write(row)
            notion_id = row.record.notion_id
            response = if notion_id && !notion_id.empty?
                         log("Updating Notion Page #{notion_id}")
                         @client.update_page(notion_id, properties: row.properties)
                       else
                         log("Creating Notion Page for #{row.record.title}")
                         @client.create_page({ "database_id" => @collection_id }, children: row.children, properties: row.properties)
                       end

            case response["object"]
            when "page"
              if row.record.respond_to?(:icon_url)
                log("Uploading '#{row.record.icon_url}' for Notion Page '#{response["id"]}'")
                @client.set_page_icon_url(response["id"], row.record.icon_url)
              end
              row.record.update(notion_id: response["id"])
              final_log("Finished")
            else
              final_log(response.inspect, error: true)
            end
          end
        end
      end
    end
  end
end
