# frozen_string_literal: true

class CreateTodoistRecord < ActiveRecord::Migration[6.0]
  def change
    create_table :todoist_records do |t|
      t.text :title
      t.string :external_id, index: true
      t.integer :project_id
      t.string :notion_id
      t.integer :section_id
      t.string :category
      t.string :status
      t.datetime :due_date
      t.text :raw_data
      t.timestamps null: false
    end
  end
end
