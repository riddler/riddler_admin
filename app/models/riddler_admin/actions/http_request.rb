module RiddlerAdmin
  module Actions
    class HTTPRequest < ::RiddlerAdmin::Action
      def self.model_name
        ::RiddlerAdmin::Action.model_name
      end
    end
  end
end
