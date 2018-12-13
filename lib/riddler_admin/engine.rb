module RiddlerAdmin
  class Engine < ::Rails::Engine
    isolate_namespace RiddlerAdmin

    models_path = root.join "app/models"

    %w[ elements steps ].each do |model_dir|
      config.autoload_paths << models_path.join(model_dir)
    end
  end
end
