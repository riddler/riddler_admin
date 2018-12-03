require "ksuid"

module RiddlerAdmin
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    after_initialize :generate_id

    private

    def id_length
      return 21 unless self.class.const_defined? :ID_LENGTH
      self.class.const_get :ID_LENGTH
    end

    def generate_id
      return if id.present?
      model_key = self.class.const_get :MODEL_KEY
      ksuid = KSUID.new.to_s
      id_string = ksuid[0..(5+id_length)]
      self.id = [model_key, id_string].join "_"
    end
  end
end
