require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class FeatureFlagsController < ApplicationController
    before_action :set_feature_flag, only: [:show, :edit, :update, :destroy, :internal_preview]
    before_action :set_feature_flag_class

    def index
      @feature_flags = FeatureFlag.all
    end

    def show
      @definition = @feature_flag.definition_hash
      @preview_contexts = ::RiddlerAdmin::PreviewContext.all
    end

    def new
      @feature_flag = @feature_flag_class.new
    end

    def create
      @feature_flag = @feature_flag_class.new feature_flag_params

      if @feature_flag.save
        redirect_to @feature_flag, notice: "FeatureFlag was successfully created."
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @feature_flag.update feature_flag_params
        redirect_to @feature_flag, notice: "FeatureFlag was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @feature_flag.destroy
      redirect_to feature_flags_url, notice: "FeatureFlag was successfully destroyed."
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
            definition_json: @feature_flag.definition_hash.to_json,
            context_json: @preview_context.data.to_json

          content_proto = content_management_grpc.preview_content request_proto
          @preview_hash = JSON.parse content_proto.content_json
        rescue GRPC::Unavailable, GRPC::DeadlineExceeded
          @preview_hash = {"message" => "gRPC unavailable: #{$!}"}
        end
      else
        use_case = ::Riddler::UseCases::AdminPreviewFeatureFlag.new @feature_flag.definition_hash,
          preview_context_data: @preview_context.data

        @preview_hash = use_case.process.deep_stringify_keys
        #@preview_hash = {}
        #@preview_hash[@feature_flag.name] = "todo"
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_feature_flag
      @feature_flag = FeatureFlag.find params[:id]
    end

    def set_feature_flag_class
      class_name = params.fetch(:feature_flag, {}).delete(:type) ||
        params.delete(:type)
      class_name = RiddlerAdmin::FeatureFlag.default_class.name if class_name.blank?

      @feature_flag_class = class_name.constantize
    end

    # Only allow a trusted parameter "white list" through.
    def feature_flag_params
      params.require(:feature_flag).permit(:name, :title, :include_condition, options: [:condition])
    end
  end
end
