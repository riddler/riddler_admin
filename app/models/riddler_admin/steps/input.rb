module RiddlerAdmin
  module Steps
    class Input < Steps::Content
      def self.model_name
        Step.model_name
      end
    end
  end
end
