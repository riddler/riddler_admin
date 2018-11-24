module RiddlerAdmin
  class Engine < ::Rails::Engine
    isolate_namespace RiddlerAdmin

    def table_name_prefix
      "riddler_"
    end
  end
end
