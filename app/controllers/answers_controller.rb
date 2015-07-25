class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [ :create ]
  before_action :load_answer, only: [ :update, :destroy ]
  
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:notice] = 'Can not create answer.'
    end
  end
  
  def update
    if current_user.id == @answer.user_id
      @question = @answer.question
      @answer.update(answer_params)
      flash[:notice] = 'Your answer successfully updated.' 
    else
      flash[:notice] = 'Can not update answer.'
    end
  end
  
  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    end
      redirect_to question_path @answer.question
  end


  private
  def load_answer
    @answer = Answer.find(params[:id])
  end
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def answer_params
    params.require(:answer).permit(:body)
  end
end
