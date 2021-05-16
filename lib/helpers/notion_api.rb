# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Helpers
  class NotionAPI
    NOTION_VERSION = "2021-05-13"

    def initialize(token, unofficial_token, space_id)
      @token = token
      @unofficial_token = unofficial_token
      @space_id = space_id
    end

    def databases
      uri = URI.parse("https://api.notion.com/v1/databases")
      perform_request(uri)
    end

    def database(id)
      uri = URI.parse("https://api.notion.com/v1/databases/#{id}")
      perform_request(Net::HTTP::Get.new(uri))
    end

    def create_page(parent, children: {}, properties: {})
      uri = URI.parse("https://api.notion.com/v1/pages")
      perform_request(Net::HTTP::Post.new(uri)) do |request|
        request.content_type = "application/json"
        body = { "parent" => parent }
        body["children"] = children unless children.empty?
        body["properties"] = properties unless properties.empty?
        request.body = body.to_json
      end
    end

    def update_page(page_id, properties: {})
      uri = URI.parse("https://api.notion.com/v1/pages/#{page_id}")
      perform_request(Net::HTTP::Patch.new(uri)) do |request|
        request.content_type = "application/json"
        request.body = { "properties" => properties }.to_json
      end
    end

    ## Unofficial

    def set_page_icon_url(page_id, url)
      operations = [
        {
          id: page_id,
          table: "block",
          path: ["format", "page_icon"],
          command: "set", "args": url,
        }
      ]
      uri = URI.parse("https://www.notion.so/api/v3/saveTransactions")
      perform_unofficial_request(uri, operations)
    end

    private

    def perform_unofficial_request(uri, body)
      request = Net::HTTP::Post.new(uri)
      request["Cookie"] = "token_v2=#{@unofficial_token}"
      request["Content-Type"] = "application/json"

      payload = {
        requestId: extract_id(SecureRandom.hex(16)),
        transactions: [
          {
            id: extract_id(SecureRandom.hex(16)),
            shardId: 955_090,
            spaceId: @space_id,
            operations: body,
          },
        ],
      }
      request.body = payload.to_json

      response = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      JSON.parse(response.body)
    end

    def extract_id(url_or_id)
      # ! parse and clean the URL or ID object provided.
      # ! url_or_id -> the block ID or URL : ``str``
      http_or_https = url_or_id.match(/^(http|https)/) # true if http or https in url_or_id...
      collection_view_match = url_or_id.match(/(\?v=)/)

      if (url_or_id.length == 36) && ((url_or_id.split("-").length == 5) && !http_or_https)
        # passes if url_or_id is perfectly formatted already...
        url_or_id
      elsif (http_or_https && (url_or_id.split("-").last.length == 32)) || (!http_or_https && (url_or_id.length == 32)) || (collection_view_match)
        # passes if either:
        # 1. a URL is passed as url_or_id and the ID at the end is 32 characters long or
        # 2. a URL is not passed and the ID length is 32 [aka unformatted]
        pattern = [8, 13, 18, 23]
        if collection_view_match
          id_without_view = url_or_id.split("?")[0]
          clean_id = id_without_view.split("/").last
          pattern.each { |index| clean_id.insert(index, "-") }
          clean_id
        else
          id = url_or_id.split("-").last
          pattern.each { |index| id.insert(index, "-") }
          id
        end
      else
        raise ArgumentError, "Expected a Notion page URL or a page ID. Please consult the documentation for further information."
      end
    end

    def perform_request(request)
      request["Authorization"] = "Bearer #{@token}"
      request["Notion-Version"] = NOTION_VERSION
      req_options = {
        use_ssl: request.uri.scheme == "https"
      }

      yield(request) if block_given?

      response = Net::HTTP.start(request.uri.hostname, request.uri.port, req_options) do |http|
        http.request(request)
      end

      JSON.parse(response.body)
    end
  end
end
