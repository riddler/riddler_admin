module RiddlerAdmin
  class Action < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "act".freeze
    ID_LENGTH = 6

    belongs_to :actionable, polymorphic: true, validate: true

    acts_as_list scope: [:actionable_type, :actionable_id, :callback]

    validates :callback, presence: true, inclusion: { in: %w[ entry exit ] }

    validates :title, presence: true

    validates :include_predicate, parseable_predicate: true

    def self.available_classes
      [
        Actions::HTTPRequest
      ]
    end

    def self.default_class
      Actions::HTTPRequest
    end
  end
end
