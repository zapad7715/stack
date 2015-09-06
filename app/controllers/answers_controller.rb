class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [ :create ]
  before_action :load_answer, only: [ :update, :destroy, :best ]
  
  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:notice] = 'Can not create answer.'
    end
  end
  
  def best
    if @answer.question.user_id == current_user.id
      @question = @answer.question
      @answer.best_answer
      flash[:notice] = 'Best answer has been choosen'
    end
  end
  
  def update
    if current_user.id == @answer.user_id
      @question = @answer.question
      flash[:notice] = 'Your answer successfully updated.' if @answer.update(answer_params)
    else
      flash[:notice] = 'Can not update answer.'
    end
  end
  
  def destroy
    if @answer.user_id == current_user.id
      @question = @answer.question
      flash[:notice] = 'Your answer successfully deleted.' if @answer.destroy
    else
      flash[:notice] = 'Can not delete the answer.'
    end
  end


  private
  
  def load_answer
    @answer = Answer.find(params[:id])
  end
  
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file,  :id, :_destroy])
  end
end
