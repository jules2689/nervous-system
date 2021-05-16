# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Transformers
        module Geekbot
          class ActiveRecord < Base
            URL_REGEX = /(https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b[-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)/

            def process(row)
              log("Saving row to database")
              record = GeekbotRecord.find_or_initialize_by(geekbot_id: row["id"])

              date = Time.at(row["timestamp"]).strftime("%Y-%m-%d")

              content = ""
              row["questions"].each do |q|
                content +=  "## #{q["question"]}\n\n"
                answer = q["answer"].gsub(URL_REGEX, '[\1](\1)')
                content +=  "#{answer}\n\n\n"
              end

              record.icon_url = row["member"]["profileImg"]
              record.name = row["member"]["realname"]
              record.content = content
              record.timestamp = row["timestamp"]
              record.date = date
              record.standup_id = row["standup_id"]
              record.title = "#{record.name}'s #{record.date} update"
              record.raw_data = row
              record.save!
              record
            end
          end
        end
      end
    end
  end
end
