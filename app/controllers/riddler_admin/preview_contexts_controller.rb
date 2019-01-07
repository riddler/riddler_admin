require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class PreviewContextsController < ApplicationController
    before_action :set_preview_context, only: [:show, :edit, :update, :destroy]

    def index
      @preview_contexts = PreviewContext.all
    end

    def show
    end

    def new
      @preview_context = PreviewContext.new
    end

    def create
      @preview_context = PreviewContext.new preview_context_params

      if @preview_context.save
        @preview_context.refresh_data input_headers: request.headers.to_h

        redirect_to @preview_context, notice: "Preview context was successfully created."
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @preview_context.update preview_context_params
        @preview_context.refresh_data input_headers: request.headers.to_h

        redirect_to @preview_context, notice: "Preview context was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @preview_context.destroy
      redirect_to preview_contexts_url, notice: "Preview context was successfully destroyed."
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_preview_context
      @preview_context = PreviewContext.find params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    def preview_context_params
      params.require(:preview_context).permit(:title, :params, :headers)
    end
  end
end
