class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [ :create ]
  
  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:notice] = 'Can not create answer.'
    end
  end
  
  def destroy
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.user_id
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    end
      redirect_to question_path @answer.question
  end


  private
  
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def answers_params
    params.require(:answer).permit(:body)
  end
end
