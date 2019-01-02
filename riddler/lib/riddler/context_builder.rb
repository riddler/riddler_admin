module Riddler

  class ContextBuilder
    attr_reader :params, :headers

    def initialize params: {}, headers: {}
      @params = params
      @headers = headers
    end

    def build
      ::Riddler::Context.new params: params, headers: headers
    end
  end

end
