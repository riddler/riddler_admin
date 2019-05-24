require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class ActionsController < ApplicationController
    before_action :set_action, only: [:show, :edit, :update, :destroy]
    before_action :set_action_class

    # GET /actions/new
    def new
      hash = {}

      if step = Step.find_by_id(params["step_id"])
        hash[:actionable] = step
      end

      @action = @action_class.new hash
    end

    # POST /actions
    def create
      @action = @action_class.new action_create_params

      if @action.save
        render :show
      else
        render :new
      end
    end

    # PATCH/PUT /actions/1
    def update
      if @action.update action_params
        redirect_to @action, notice: 'Action was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /actions/1
    def destroy
      @action.destroy
      render :destroy
    end

    # PUT /actions/sort
    def sort
      action_order = params.fetch "action_order"

      action_order.each_with_index do |action_id, index|
        action = Action.find_by_id action_id
        action.update_attribute :position, index+1
      end

      head :no_content
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_action
        @action = Action.find params[:id]
      end

      def set_action_class
        class_name = params.fetch(:ra_action, {}).delete("type") ||
          params.delete(:type)
        class_name = RiddlerAdmin::Action.default_class.name if class_name.blank?

        @action_class = class_name.constantize
      end

      # Only allow a trusted parameter "white list" through.
      def action_create_params
        params.require(:ra_action).permit(:id, :name, :type, :actionable_type, :actionable_id, :include_predicate, :transition_type)
      end

      # Only allow a trusted parameter "white list" through.
      def action_params
        params.require(:ra_action).permit(:name, :include_predicate, :transition_type)
      end
  end
end
