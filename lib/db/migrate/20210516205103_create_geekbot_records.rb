class CreateGeekbotRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :geekbot_records do |t|
      t.integer :geekbot_id
      t.string :icon_url
      t.string :name
      t.text :content
      t.string :date
      t.integer :standup_id
      t.string :notion_id
      t.integer :timestamp
      t.string :title
      t.text :raw_data
    end
  end
end
