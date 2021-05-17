# frozen_string_literal: true

require "todoist"

module Nervous
  module System
    module ETL
      module Sources
        class Geekbot < ETL::Base
          GEEKBOT_AFTER_TIME = "geekbot_after_time"

          def initialize(env, logger)
            @client = ::Geekbot::Client.new(access_token: env["GEEKBOT_ACCESS_TOKEN"])
            @standup_id = env["GEEKBOT_STANDUP_ID"]
            super(logger)
          end

          def each(&block)
            standups.each do |standup|
              first_log("Processing #{standup["id"]}")
              standup["standup_id"] = @standup_id
              block.call(standup)
            end
          end

          def standups
            params = { standup_id: @standup_id }
            if (time = GeekbotRecord.all.pluck(:timestamp).max)
              params[:after] = time
            end

            reports = @client.index_reports(params: params).body

            @logger.warn("No reports found for #{params.to_json}") if reports.empty?

            reports
          end
        end
      end
    end
  end
end
