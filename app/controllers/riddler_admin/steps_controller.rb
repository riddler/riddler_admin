require "riddler/protobuf/content_management_services_pb"
require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class StepsController < ApplicationController
    before_action :set_step, only: [:show, :edit, :update, :destroy, :internal_preview, :preview, :toggle]
    before_action :set_step_class

    # GET /steps
    def index
      @steps = Step.all
    end

    # GET /steps/1
    def show
      @step_definition = @step.definition_hash
      @preview_contexts = ::RiddlerAdmin::PreviewContext.all
    end

    # GET /steps/new
    def new
      hash = {}

      if step = Step.find_by_id(params["step_id"])
        hash[:stepable] = step
      end

      @step = @step_class.new hash
    end

    # GET /steps/1/edit
    def edit
    end

    # Should always comes from the admin tool
    def internal_preview
      @preview_context = ::RiddlerAdmin::PreviewContext.find_by_id params["pctx_id"]
      if @preview_context.nil?
        render(status: 400, json: {message: "Invalid pctx_id"}) and return
      end

      request_proto = ::Riddler::Protobuf::PreviewContentRequest.new \
        definition_json: @step.definition_hash.to_json,
        context_json: @preview_context.data.to_json

      content_proto = content_management_grpc.preview_content request_proto
      @preview_hash = JSON.parse content_proto.content_json
    end

    def sort
      step_order = params.fetch "step_order"

      step_order.each_with_index do |step_id, index|
        step = Step.find_by_id step_id
        step.update_attribute :position, index+1
      end

      head :no_content
    end

    # POST /steps/1/preview
    def preview
      if @step.preview_enabled
        request_headers = PreviewContext.convert_headers request.headers.to_h
        definition = @step.definition_hash

        use_case = ::Riddler::UseCases::PreviewStep.new definition,
          params: params.to_unsafe_h,
          headers: request_headers

        render json: use_case.process
      else
        render json: {status: "disabled"}
      end
    end

    def toggle
      @step.update_attributes(preview_enabled: !@step.preview_enabled)
      redirect_to @step
    end

    # POST /steps
    def create
      @step = @step_class.new(step_params)

      if @step.save
        redirect_to @step, notice: "Step was successfully created."
      else
        render :new
      end
    end

    # PATCH/PUT /steps/1
    def update
      if @step.update(step_params)
        redirect_to @step, notice: "Step was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /steps/1
    def destroy
      @step.destroy
      redirect_to steps_url, notice: "Step was successfully destroyed."
    end

    private

    def content_management_grpc
      ::Riddler::Protobuf::ContentManagement::Stub.new \
        ::RiddlerAdmin.configuration.riddler_grpc_address,
        :this_channel_is_insecure
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_step
      @step = Step.find(params[:id])
    end

    def set_step_class
      class_name = params.fetch(:step, {}).delete(:type) ||
        params.delete(:type)
      class_name = RiddlerAdmin::Step.default_class.name if class_name.blank?

      @step_class = class_name.constantize
    end

    # Only allow a trusted parameter "white list" through.
    def step_params
      params.require(:step).permit(:title, :name, :type, :stepable_type, :stepable_id, :include_predicate)
    end
  end
end
