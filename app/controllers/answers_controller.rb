class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [ :create ]
  before_action :load_answer, only: [ :update, :destroy, :best ]
  before_action :access_answer, only: [:update, :destroy ]
  before_action :access_best_answer, only: [ :best ]
  
  respond_to :js, only: [ :create, :update, :destroy, :best ]
  
  include Voted
  
  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end
  
  def best
    respond_with(@answer.best_answer)
  end
  
  def update
    @answer.update(answer_params)
    respond_with @answer
  end
  
  def destroy
    respond_with(@answer.destroy)
  end

  private
  
  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end
  
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def access_answer
    redirect_to @answer.question, notice: 'Access denied' if  @answer.user_id != current_user.id
  end
  
  def access_best_answer
    redirect_to @answer.question, notice: 'Access denied' if @answer.question.user_id != current_user.id
  end
  
  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file,  :id, :_destroy])
  end
  
end
