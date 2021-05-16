# frozen_string_literal: true

require "todoist"

module Nervous
  module System
    module ETL
      module Sources
        class Todoist < Base
          def initialize(env, logger)
            @client = ::Todoist::Client.create_client_by_token(env["TODOIST_TOKEN"])
            super(logger)
          end

          def each(&block)
            items.values.each do |item|
              first_log("Processing #{item.id}")
              block.call(item)
            end
          end

          def items
            @client.sync_items.collection.map do |id, item|
              item.project = project(item.project_id)
              item.section = section(item.section_id) if item.section_id
              [id, item]
            end.to_h
          end

          def project(id)
            @projects ||= @client.sync_projects.collection
            @projects[id]
          end

          def section(id)
            @sections ||= {}
            @sections[id] ||= begin
              if (section = @client.api_helper.get_response("/sections/get", section_id: id)["section"])
                OpenStruct.new(section)
              end
            end
          rescue ::Todoist::Util::NetworkHelper::NetworkError => e
            puts "Could not get section #{id} : #{e}"
            nil
          end
        end
      end
    end
  end
end
