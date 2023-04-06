class Api::QuestionController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    @questions = Question.includes(:option).all.where(test_id: params[:test_id])
    render json: @questions, include: [:option]
  end

  def show
    @question = Question.includes(:option).find_by(id: params[:id])
    if !@question.nil?
      # @question << option: @option
      render json: @question, include: [:option]
    else
      render json: 'Record Not Found'
    end
  end

  def new
    @question = Question.new
    @question.build_option
    @question.build_answer
  end

  def create
    @question = Question.new(question_params)
    @question.test_id = params[:test_id]
    # p @question
    if @question.save
      # flash[:notice] = 'Successfully added the Notes'
      render json: @question
      # redirect_to course_test_question_index_path
    else
      render json: @question.error
      # render :new, status: :unprocessable_entity
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.includes(:option).find_by(params[:id])
    if !@question.nil?
      if @question.update(question_params)
        render json: @question, include: [:option]
      else
        render json: @question.errors
      end
    else
      render json: 'Record Not Found'
    end
  end

  def destroy
    @question = Question.includes(:option).find_by(id: params[:id])
    if !@question.nil?
      if @question.destroy
        render json: @question, include: [:option]
      else
        render json: @question.error
      end else
            render json: 'Record Not Found'
    end
  end

  def question_params
    params.require(:question).permit(:question, option_attributes: %i[opt1 opt2 opt3 opt4],
                                                answer_attributes: [:answer])
  end
end
