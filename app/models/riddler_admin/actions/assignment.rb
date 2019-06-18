module RiddlerAdmin
  module Actions
    class Assignment < ::RiddlerAdmin::Action
      def self.model_name
        ::RiddlerAdmin::Action.model_name
      end

      def definition_hash opts=nil
        hash = super
        hash["variable"] = options["variable"]
        hash["value"] = options["value"]
        hash
      end
    end
  end
end
