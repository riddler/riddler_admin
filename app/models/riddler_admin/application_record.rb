require "ulid"

module RiddlerAdmin
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    after_initialize :generate_id

    private

    def random_length
      return 16 unless self.class.const_defined? :CARDINALITY
      size = self.class.const_get :CARDINALITY

      case size
        when :small then 4
        when :medium then 8
        when :large then 12
        else 16
      end
    end

    def generate_id
      return if id.present?
      model_key = self.class.const_get :MODEL_KEY
      ulid = ULID.generate
      id_string = ulid[0...(10+random_length)]
      self.id = [model_key, id_string].join "_"
    end
  end
end
