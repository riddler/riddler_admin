module RiddlerAdmin
  def table_name_prefix
    "riddler_"
  end

  class Engine < ::Rails::Engine
    isolate_namespace RiddlerAdmin
  end
end
