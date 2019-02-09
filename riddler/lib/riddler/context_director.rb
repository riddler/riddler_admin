module Riddler

  class ContextDirector
    attr_reader :params, :headers

    def initialize params: {}, headers: {}
      @params = params
      @headers = headers
      @ctx = ::Riddler::Context.new params: params, headers: headers
      @ids_extracted = false
      @builders_applied = false
    end

    # Return the context with only IDs extracted
    def simple_context
      extract_ids
      @ctx
    end

    # Create a new context and use registered builders to fill it in
    def context
      extract_ids
      apply_builders
      @ctx
    end

    private

    def extract_ids
      return if @ids_extracted

      builders.each do |builder|
        unless builder.data_available?
          ::Riddler.logger.debug "data not available for builder", context_builder: builder.class.name
          next
        end
        ::Riddler.logger.debug "extracting ids", context_builder: builder.class.name
        builder.extract_ids
      end

      @ids_extracted = true
    end

    def apply_builders
      return if @builders_applied

      builders.each do |builder|
        unless builder.data_available?
          ::Riddler.logger.debug "data not available for builder", context_builder: builder.class.name
          next
        end
        ::Riddler.logger.debug "processing context builder", context_builder: builder.class.name
        builder.process
      end

      @builders_applied = true
    end

    def builders
      @builders ||= ::Riddler.configuration.context_builders.map do |builder_class|
        builder = builder_class.new @ctx
      end
    end
  end

end
