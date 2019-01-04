require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class StepsController < ApplicationController
    before_action :set_step, only: [:show, :edit, :update, :destroy, :preview]
    before_action :set_step_class

    # GET /steps
    def index
      @steps = Step.all
    end

    # GET /steps/1
    def show
      @step_definition = @step.definition_hash
    end

    # GET /steps/new
    def new
      @step = Step.new
    end

    # GET /steps/1/edit
    def edit
    end

    # POST /steps/1/preview
    def preview
      render json: {status: 'disabled'}.to_json && return unless @step.preview_enabled

      original_headers = request.headers.to_h.
        select{|k,v| k.starts_with? "HTTP_"}.
        map{|k,v| [k.downcase.gsub(/^http_/, ""), v] }

      request_headers = Hash[original_headers]

      definition = @step.definition_hash

      @use_case = ::Riddler::UseCases::PreviewStep.new definition,
        params: params.to_unsafe_h,
        headers: request_headers
    end

    # POST /steps
    def create
      @step = @step_class.new(step_params)

      if @step.save
        redirect_to @step, notice: 'Step was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /steps/1
    def update
      if @step.update(step_params)
        redirect_to @step, notice: 'Step was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /steps/1
    def destroy
      @step.destroy
      redirect_to steps_url, notice: 'Step was successfully destroyed.'
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
        params.require(:step).permit(:name)
      end
  end
end
