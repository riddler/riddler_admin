require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class FeatureFlagsController < ApplicationController
    before_action :set_feature_flag, only: [:show, :edit, :update, :destroy]

    def index
      @feature_flags = FeatureFlag.all
    end

    def show
    end

    def new
      @feature_flag = FeatureFlag.new
    end

    def create
      @feature_flag = FeatureFlag.new feature_flag_params

      if @feature_flag.save
        redirect_to @feature_flag, notice: "Feature flag was successfully created."
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @feature_flag.update feature_flag_params
        redirect_to @feature_flag, notice: "Feature flag was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @feature_flag.destroy
      redirect_to feature_flags_url, notice: "Feature flag was successfully destroyed."
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_feature_flag
      @feature_flag = FeatureFlag.find params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    def feature_flag_params
      params.require(:feature_flag).permit(:name, :enabled)
    end
  end
end
