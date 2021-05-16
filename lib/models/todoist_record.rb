# frozen_string_literal: true

class TodoistRecord < ApplicationRecord
  self.table_name = "todoist_records"

  validates :project_id, presence: true

  scope :recent, -> { order(updated_at: :desc) }
  scope :with_project, ->(project_id) { where(project_id: project_id) }
end
