# frozen_string_literal: true

module Nervous
  module System
    module ETL
      module Transformers
        module Todoist
          class ActiveRecord < Base
            def process(row)
              log("Saving row to database")
              record = TodoistRecord.find_or_initialize_by(external_id: row.id)
              record.title = row.content
              record.project_id = row.project_id
              record.section_id = row.section_id
              record.category = "#{row.project.name}/#{row.section&.name || "Uncategorized"}"
              record.status = row.checked == 1 ? "Archived" : "Open"
              record.due_date = due_date(row["due"])
              record.raw_data = row.to_json
              record.save!
              record
            end

            def due_date(due)
              return nil if due.nil?

              return Time.strptime(due["date"], "%Y-%m-%dT%H:%M:%S%Z") if due["date"].end_with?("Z")

              # TODO: This is a hack. We should be using the timezone of the user
              return Time.strptime(due["date"], "%Y-%m-%dT%H:%M:%S") if due["date"].count("T").positive?

              Time.strptime(due["date"], "%Y-%m-%d")
            end
          end
        end
      end
    end
  end
end
