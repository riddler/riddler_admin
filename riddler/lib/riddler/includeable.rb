module Riddler
  module Includeable
    def include?
      return true unless has_include_predicate?
      Predicator.evaluate include_predicate, context.to_liquid
    end

    def include_predicate
      definition["include_predicate"]
    end

    private

    def has_include_predicate?
      definition.key?("include_predicate") and
        definition["include_predicate"].to_s.strip != ""
    end
  end
end
