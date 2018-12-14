module RiddlerAdmin
  class StepSerializer < ActiveModel::Serializer
    attributes :id, :type

    # Used in serialization
    def type
      object.type.demodulize.underscore
    end

    #def definition_hash options=nil
    #  options ||= {}
    #  serializable_hash options.merge(serializable_hash_options)
    #end

    #def serializable_hash_options
    #  {
    #    methods: :object,
    #    except: excluded_attrs
    #  }
    #end

    #def excluded_attrs
    #  [:created_at, :updated_at, :name]
    #end
  end
end
