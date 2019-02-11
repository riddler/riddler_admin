module RiddlerAdmin
  module ApplicationHelper
    def page_title
      [
        ::RiddlerAdmin.config.main_app_name,
        ::RiddlerAdmin.config.app_name
      ].compact.join " - "
    end

    def brand_link
      if ::RiddlerAdmin.config.main_app_name.present?
        link_to ::RiddlerAdmin.config.main_app_name, main_app.root_path, class: "navbar-brand"
      else
        link_to ::RiddlerAdmin.config.app_name, riddler_admin.root_path, class: "navbar-brand"
      end
    end

    def additional_javascript_includes
      return if ::RiddlerAdmin.config.javascript_includes.blank?
      javascript_include_tag *::RiddlerAdmin.config.javascript_includes
    end
  end
end
