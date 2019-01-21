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
      @step = Step.new
    end

    # GET /steps/1/edit
    def edit
    end

    # Should always comes from the admin tool
    def internal_preview
      @preview_context = ::RiddlerAdmin::PreviewContext.find params["pctx_id"]

      @use_case = ::Riddler::UseCases::AdminPreviewStep.new @step.definition_hash,
        preview_context_data: @preview_context.data

      @preview_hash = @use_case.process
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
      params.require(:step).permit(:title, :name)
    end
  end
end
