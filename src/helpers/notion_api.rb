require 'net/http'
require 'uri'
require 'json'

module Helpers
  class NotionAPI
    NOTION_VERSION = "2021-05-13"

    def initialize(token)
      @token = token
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
        puts request.body
      end
    end

    def update_page(page_id, properties: {})
      uri = URI.parse("https://api.notion.com/v1/pages/#{page_id}")
      perform_request(Net::HTTP::Patch.new(uri)) do |request|
        request.content_type = "application/json"
        request.body = { "properties" => properties }.to_json
      end
    end

    private

    def perform_request(request)
      request["Authorization"] = "Bearer #{@token}"
      request["Notion-Version"] = NOTION_VERSION
      req_options = {
        use_ssl: request.uri.scheme == "https",
      }

      yield(request) if block_given?
      
      response = Net::HTTP.start(request.uri.hostname, request.uri.port, req_options) do |http|
        http.request(request)
      end

      JSON.parse(response.body)
    end
  end
end
