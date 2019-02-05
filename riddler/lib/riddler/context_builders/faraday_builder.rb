module Riddler
  module ContextBuilders
    class FaradayBuilder < ::Riddler::ContextBuilder
      def self.base_uri
        raise "The Faraday builder must define a class .base_uri method"
      end

      def connection
        @connection ||= build_connection
      end

      private

      def build_connection
        Faraday.new url: self.class.base_uri do |conn|
          conn.response :json, :content_type => /\bjson$/
          conn.request :url_encoded
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
