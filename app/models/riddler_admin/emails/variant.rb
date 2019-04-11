module RiddlerAdmin
  module Emails
    class Variant < Email
      has_many :emails, -> { order position: :asc },
        dependent: :destroy,
        as: :emailable

      def self.model_name
        Email.model_name
      end

      def definition_hash options=nil
        hash = super
        hash["emails"] = emails.map { |e| e.definition_hash }
        hash
      end
    end
  end
end
