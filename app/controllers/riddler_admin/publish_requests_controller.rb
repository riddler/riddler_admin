require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class PublishRequestsController < ApplicationController
    before_action :set_publish_request, only: [:show, :edit, :update, :destroy, :approve, :publish]

    def index
      @publish_requests = PublishRequest.all
    end

    def show
      @preview_contexts = ::RiddlerAdmin::PreviewContext.all
    end

    def approve
      @publish_request.approve
    end

    def publish
      @publish_request.publish
    end

    def new
      hash = {}

      if step = Step.find_by_id(params["step_id"])
        hash[:content] = step
        hash[:content_definition] = step.definition_hash.to_yaml
        @publish_request = PublishRequest.new hash
      else
        redirect_to publish_requests_path, notice: "Content must be provided in step_id"
      end
    end

    def create
      @publish_request = PublishRequest.new publish_request_params

      if @publish_request.save
        redirect_to @publish_request, notice: "Publish request was successfully created."
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @publish_request.update publish_request_params
        @publish_request.refresh_data input_headers: request.headers.to_h

        redirect_to @publish_request, notice: "Publish request was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @publish_request.destroy
      redirect_to publish_requests_url, notice: "Publish request was successfully destroyed."
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_publish_request
      @publish_request = PublishRequest.find params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    def publish_request_params
      params.require(:publish_request).permit(:title, :description, :content_type, :content_id, :content_definition)
    end
  end
end
