class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :access_question, only: [:destroy]
  before_action :access_question_js, only: [:update]
  before_action :build_answer, only: :show
  after_action :publish_question, only: [:create]
  
  respond_to :js, only: [:update]
  
  include Voted
  
  def index
    respond_with(@questions = Question.all)
  end
  
  def show
    respond_with @question
  end
  
  def new
    respond_with(@question = Question.new)
  end
  
  def edit
  end
  
  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end
  
  def update
    @question.update(question_params)
    respond_with @question
  end
  
  def destroy
    respond_with(@question.destroy)
  end
  
  private
  
  def load_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
  
  def build_answer
    @answer = @question.answers.build
  end
  
  def publish_question
    PrivatePub.publish_to "/questions/index", question: @question.to_json
  end
  
  def access_question
    redirect_to root_path, notice: 'Access denied' if  @question.user_id != current_user.id
  end
  
  def access_question_js
    render status: :forbidden, notice: 'Access denied' if  @question.user_id != current_user.id
  end
  
end
