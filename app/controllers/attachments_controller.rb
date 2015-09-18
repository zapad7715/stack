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
    load_question
    redirect_to @question, notice: 'Access denied' if  @attachment.attachable.user_id != current_user.id
  end
  
  def load_question
    @question = @attachment.attachable_type == 'Question' ? @attachment.attachable : @attachment.attachable.question
  end
  
end
