module RiddlerAdmin
  module Steps
    class Redirect < Step
      def self.model_name
        Step.model_name
      end

      def definition_hash options=nil
        hash = super
        # hash["location"] = ?
        hash
      end
    end
  end
end
