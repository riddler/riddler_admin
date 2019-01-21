module Riddler
  module Includeable
    def include?
      return true unless has_include_predicate?
      predicate = definition["include_predicate"]
      Predicator.evaluate predicate, context.to_liquid
    end

    private

    def has_include_predicate?
      definition.key?("include_predicate") and
        definition["include_predicate"].to_s.strip != ""
    end
  end
end
