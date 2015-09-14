class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  
  include Voted
  
  def index
    @questions = Question.all
  end
  
  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end
  
  def new
    @question = Question.new
    @question.attachments.build
  end
  
  def edit
  end
  
  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      PrivatePub.publish_to "/questions/index", question: @question.to_json
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else 
      render :new    
    end
  end
  
  def update
    if current_user.id == @question.user_id
      @question.update(question_params)
      flash[:notice] = 'Your question successfully updated.'
    else
      flash[:notice] = 'Can not update question.'
    end
  end
  
  def destroy
    if @question.user == current_user
      @question.destroy
      flash[:notice] = 'Your Question successfully deleted.'
      redirect_to questions_path
    else
      render :show
    end
  end
  
  private
  
  def load_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
  
end
