module RiddlerAdmin
  module Actions
    class HTTPRequest < ::RiddlerAdmin::Action
      def self.model_name
        ::RiddlerAdmin::Action.model_name
      end

      def definition_hash opts=nil
        hash = super
        hash["request_method"] = options["request_method"]
        hash["url_template"] = options["url_template"]
        hash["body_template"] = options["body_template"]
        hash
      end
    end
  end
end
