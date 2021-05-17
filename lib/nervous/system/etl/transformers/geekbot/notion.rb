# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Transformers
        module Geekbot
          class Notion < ETL::Base
            def process(record)
              log("Transforming to Notion Properties")
              properties = {}

              properties["Note Title"] = {
                "title": [
                  {
                    "type": "text",
                    "text": {
                      "content": "#{record.name}'s #{record.date} update"
                    }
                  }
                ]
              }

              properties["Person"] = {
                "select": {
                  "name": record.name
                }
              }

              properties["Category"] = {
                "select": {
                  "name": "Geekbot"
                }
              }

              properties["URL"] = {
                "url": "https://app.geekbot.com/dashboard/standup/#{record.standup_id}/view/timeline"
              }

              properties["Status"] = {
                "select": {
                  "name": "Open"
                }
              }

              properties["GeekbotId"] = {
                "number": record.geekbot_id.to_i
              }

              children = record.raw_data["questions"].flat_map do |q|
                [
                  {
                    "object": "block",
                    "type": "heading_2",
                    "heading_2": {
                      "text": [{ "type": "text", "text": { "content": q["question"] } }]
                    }
                  },
                  {
                    "object": "block",
                    "type": "paragraph",
                    "paragraph": {
                      "text": [
                        {
                          "type": "text",
                          "text": {
                            "content": q["answer"]
                          }
                        }
                      ]
                    }
                  }
                ]
              end

              OpenStruct.new(record: record, children: children, properties: properties)
            end
          end
        end
      end
    end
  end
end
