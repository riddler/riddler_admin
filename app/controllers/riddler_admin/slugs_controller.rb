require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class SlugsController < ApplicationController
    before_action :set_slug, only: [:show, :edit, :update, :destroy, :toggle_status, :publish]
    before_action :check_deploy_ability, only: [:create, :update]

    def index
      @slugs = Slug.all
    end

    def show
    end

    def new
      @slug = Slug.new
    end

    def create
      @slug = Slug.new slug_params

      if @slug.save
        redirect_to slugs_url, notice: "Slug was successfully created."
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @slug.update slug_params
        redirect_to slugs_url, notice: "Slug was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      raise "Destroying slugs is not currently supported"
      @slug.destroy
      redirect_to slugs_url, notice: "Slug was successfully destroyed."
    end

    private

    def check_deploy_ability
      if !riddler_user_can_deploy?
        redirect_to slugs_url, notice: "Slug creation/modification not allowed"
        return false
      end
      true
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_slug
      @slug = Slug.find params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    def slug_params
      params.require(:slug).permit :name, :status, :content_definition_id,
          :persist_interaction, :interaction_identity, :target_predicate
    end
  end
end
