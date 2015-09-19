class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]
  before_action :access_attachment, only: [:destroy]
  
  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
  
  def access_attachment
    render status: :forbidden, notice: 'Access denied' if  @attachment.attachable.user_id != current_user.id
  end
  
end
