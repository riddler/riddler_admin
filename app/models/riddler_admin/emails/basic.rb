module RiddlerAdmin
  module Emails
    class Basic < ::RiddlerAdmin::Email
      def self.model_name
        Email.model_name
      end

      def definition_hash options=nil
        hash = super.merge "subject" => subject,
          "body" => body,
          "css" => css

        hash
      end
    end
  end
end
