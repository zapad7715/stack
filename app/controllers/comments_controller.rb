class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable
  
  respond_to :js

  def create
    respond_with(@comment = Comment.create(commentable: @commentable, user_id: current_user.id, comment_body: comment_params[:comment_body]), load_question)
  end

  private

  def load_commentable
    @commentable =  params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end
  
  def load_question
    @question = @comment.commentable_type == 'Question' ? @comment.commentable : @comment.commentable.question
  end

  def comment_params
    params.require(:comment).permit(:comment_body)
  end
end
