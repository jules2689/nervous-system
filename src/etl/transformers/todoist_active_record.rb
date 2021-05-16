module ETL
  module Transformers
    class TodoistActiveRecord
      def process(row)
        record = TodoistRecord.find_or_initialize_by(external_id: row.id)
        record.title = row.content
        record.project_id = row.project_id
        record.section_id = row.section_id
        record.category = "#{row.project.name}/#{row.section&.name || 'Uncategorized'}"
        record.status = row.checked == 1 ? 'Archived' : 'Open'
        record.due_date = due_date(row["due"])
        record.raw_data = row.to_json
        record.save!
        record
      end

      def due_date(due)
        return nil if due.nil?

        if due["date"].end_with?('Z')
          return Time.strptime(due["date"], "%Y-%m-%dT%H:%M:%S%Z")
        end
        
        # TODO: This is a hack. We should be using the timezone of the user
        if due["date"].count('T') > 0
          return Time.strptime(due["date"], "%Y-%m-%dT%H:%M:%S")
        end

        Time.strptime(due["date"], "%Y-%m-%d")
      end
    end
  end
end
