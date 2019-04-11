require_dependency "riddler_admin/application_controller"

module RiddlerAdmin
  class EmailsController < ApplicationController
    before_action :set_email, only: [:show, :edit, :update, :destroy, :internal_preview, :send_preview, :preview, :toggle]
    before_action :set_email_class

    # GET /emails
    def index
      @emails = ::RiddlerAdmin::Email.all
    end

    # GET /emails/1
    def show
      @email_definition = @email.definition_hash
      @preview_contexts = ::RiddlerAdmin::PreviewContext.all
    end

    # GET /emails/new
    def new
      @email = @email_class.new
    end

    # GET /emails/1/edit
    def edit
    end

    # Should always comes from the admin tool
    def internal_preview
      @preview_context = ::RiddlerAdmin::PreviewContext.find params["pctx_id"]

      @use_case = ::Riddler::UseCases::AdminPreviewEmail.new @email.definition_hash,
        preview_context_data: @preview_context.data

      @preview_hash = @use_case.process
    end

    def send_preview
      internal_preview
      email_subject = @preview_hash[:subject]
      email_body = @preview_hash[:body]

      render js: "alert('TODO: send email');"
    end

    def sort
      email_order = params.fetch "email_order"

      email_order.each_with_index do |email_id, index|
        email = Email.find_by_id email_id
        email.update_attribute :position, index+1
      end

      head :no_content
    end

    # POST /emails/1/preview
    def preview
      if @email.preview_enabled
        request_headers = PreviewContext.convert_headers request.headers.to_h
        definition = @email.definition_hash

        use_case = ::Riddler::UseCases::PreviewEmail.new definition,
          params: params.to_unsafe_h,
          headers: request_headers

        render json: use_case.process
      else
        render json: {status: "disabled"}
      end
    end

    def toggle
      @email.update_attributes(preview_enabled: !@email.preview_enabled)
      redirect_to @email
    end

    # POST /emails
    def create
      @email = @email_class.new email_params

      if @email.save
        redirect_to @email, notice: "Email was successfully created."
      else
        render :new
      end
    end

    # PATCH/PUT /emails/1
    def update
      if @email.update email_params
        redirect_to @email, notice: "Email was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /emails/1
    def destroy
      @email.destroy
      redirect_to emails_url, notice: "Email was successfully destroyed."
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    def set_email_class
      class_name = params.fetch(:email, {}).delete(:type) ||
        params.delete(:type)
      class_name = ::RiddlerAdmin::Email.default_class.name if class_name.blank?

      @email_class = class_name.constantize
    end

    # Only allow a trusted parameter "white list" through.
    def email_params
      params.require(:email).permit(:type, :title, :name, :subject, :body, :css, :include_predicate)
    end
  end
end
