module Riddler
  module UseCases
    class PreviewContext
      attr_reader :params, :headers

      def initialize params: {}, headers: {}
        @params = params
        @headers = headers
      end

      def context
        @context ||= generate_context
      end

      def process
        context.to_hash
      end

      private

      def generate_context
        director = ::Riddler::ContextDirector.new params: params,
          headers: headers
        director.context
      end
    end
  end
end
