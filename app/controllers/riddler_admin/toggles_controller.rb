require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class TogglesController < ApplicationController
    before_action :set_toggle, only: [:show, :edit, :update, :destroy, :internal_preview]
    before_action :set_toggle_class

    def index
      @toggles = Toggle.all
    end

    def show
      @definition = @toggle.definition_hash
      @preview_contexts = ::RiddlerAdmin::PreviewContext.all
    end

    def new
      @toggle = @toggle_class.new
    end

    def create
      @toggle = @toggle_class.new toggle_params

      if @toggle.save
        redirect_to @toggle, notice: "Toggle was successfully created."
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @toggle.update toggle_params
        redirect_to @toggle, notice: "Toggle was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @toggle.destroy
      redirect_to toggles_url, notice: "Toggle was successfully destroyed."
    end

    # Should always comes from the admin tool
    def internal_preview
      @preview_context = ::RiddlerAdmin::PreviewContext.find_by_id params["pctx_id"]
      if @preview_context.nil?
        render(status: 400, json: {message: "Invalid pctx_id"}) and return
      end

      if ::RiddlerAdmin.configuration.remote_riddler?
        begin
          request_proto = ::Riddler::Protobuf::PreviewContentRequest.new \
            definition_json: @toggle.definition_hash.to_json,
            context_json: @preview_context.data.to_json

          content_proto = content_management_grpc.preview_content request_proto
          @preview_hash = JSON.parse content_proto.content_json
        rescue GRPC::Unavailable, GRPC::DeadlineExceeded
          @preview_hash = {"message" => "gRPC unavailable: #{$!}"}
        end
      else
        #use_case = ::Riddler::UseCases::AdminPreviewToggle.new @toggle.definition_hash,
        #  preview_context_data: @preview_context.data

        #@preview_hash = use_case.process.deep_stringify_keys
        @preview_hash = {}
        @preview_hash[@toggle.name] = "todo"
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_toggle
      @toggle = Toggle.find params[:id]
    end

    def set_toggle_class
      class_name = params.fetch(:toggle, {}).delete(:type) ||
        params.delete(:type)
      class_name = RiddlerAdmin::Toggle.default_class.name if class_name.blank?

      @toggle_class = class_name.constantize
    end

    # Only allow a trusted parameter "white list" through.
    def toggle_params
      params.require(:toggle).permit(:name, :title, :include_condition, :enabled)
    end
  end
end
