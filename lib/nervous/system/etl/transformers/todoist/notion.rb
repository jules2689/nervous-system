# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Transformers
        module Todoist
          class Notion < ETL::Base
            def process(record)
              log("Transforming to Notion Properties")
              properties = {}

              properties["Note Title"] = {
                "title": [
                  {
                    "type": "text",
                    "text": {
                      "content": record.title
                    }
                  }
                ]
              }

              properties["Category"] = {
                "select": {
                  "name": record.category
                }
              }

              if record.due_date
                # TODO: Add a Start Date
                # "start": "2021-04-26",
                #
                properties["Reminder"] = {
                  "date": { "start": record.due_date.strftime("%Y-%m-%d") }
                }
              end

              properties["Status"] = {
                "select": {
                  "name": record.status
                }
              }

              properties["external_id"] = {
                "number": record.external_id.to_i
              }

              properties["project_id"] = {
                "number": record.project_id.to_i
              }

              OpenStruct.new(record: record, children: {}, properties: properties)
            end
          end
        end
      end
    end
  end
end
