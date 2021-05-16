# frozen_string_literal: true

class GeekbotRecord < ApplicationRecord
  self.table_name = "geekbot_records"

  serialize :raw_data, JSON
end
