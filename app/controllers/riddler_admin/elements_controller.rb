require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class ElementsController < ApplicationController
    before_action :set_element, only: [:show, :edit, :update, :destroy]
    before_action :set_element_class

    # GET /elements/new
    def new
      hash = {}

      if step = Step.find_by_id(params["step_id"])
        hash[:container] = step
      elsif element = RiddlerAdmin::Element.find_by_id(params[:element_id])
        hash[:container] = element
      end

      @element = @element_class.new hash
    end

    # POST /elements
    def create
      @element = @element_class.new element_create_params

      if @element.save
        render :show
      else
        render :new
      end
    end

    # PATCH/PUT /elements/1
    def update
      if @element.update element_params
        redirect_to @element, notice: 'Element was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /elements/1
    def destroy
      @element.destroy
      render :destroy
    end

    # PUT /elements/sort
    def sort
      element_order = params.fetch "element_order"

      element_order.each_with_index do |element_id, index|
        element = Element.find_by_id element_id
        element.update_attribute :position, index+1
      end

      head :no_content
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_element
        @element = Element.find(params[:id])
      end

      def set_element_class
        class_name = params.fetch(:element, {}).delete(:type) ||
          params.delete(:type)
        class_name = RiddlerAdmin::Element.default_class.name if class_name.blank?

        @element_class = class_name.constantize
      end

      # Only allow a trusted parameter "white list" through.
      def element_create_params
        params.require(:element).permit(:id, :name, :type, :text, :container_type, :container_id, :href, :include_predicate)
      end

      # Only allow a trusted parameter "white list" through.
      def element_params
        params.require(:element).permit(:name, :text, :href, :include_predicate)
      end
  end
end
