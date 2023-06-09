class QuestionController < ApplicationController
  before_action :authenticate_user!
  def index
    @questions = Question.all.where(test_id: params[:test_id])
    return if current_user.accountable.course_ids.include?(params[:course_id].to_i)

    # render json: { message: 'Autheraization Restricted' }, status: :unauthorized
  end

  def show
    @question = Question.find(params[:id])
    return if current_user.accountable.course_ids.include?(params[:course_id].to_i)

    # render json: { message: 'Autheraization Restricted' }, status: :unauthorized
  end

  def new
    @question = Question.new
    @question.build_option
    @question.build_answer
  end

  def create
    if current_user.role == 'student' || !current_user.accountable.course_ids.include?(params[:course_id].to_i)
      flash[:notice] = 'Unauthorized Access'
      redirect_to root_path
      return
    end
    @question = Question.new(question_params)
    @question.test_id = params[:test_id]
    # p @question
    if @question.save
      flash[:notice] = 'Successfully added the Notes'
      redirect_to course_test_question_index_path
    else
      flash[:notice] = 'Failed to add question'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      flash[:notice] = 'Successfully updated the Notes'
      redirect_to course_test_question_index_path
    else
      flash[:notice] = 'Failed to update the Notes'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question = Question.find(params[:id])
    # p @question
    if @question.destroy && current_user.role == 'teacher'
      flash[:notice] = 'Successfully deleted the question'
      redirect_to course_test_question_index_path
    else
      flash[:notice] = 'Failed to delete question'
      redirect_to course_test_question_path
    end
  end

  def question_params
    params.require(:question).permit(:question, option_attributes: %i[opt1 opt2 opt3 opt4],
                                                answer_attributes: [:answer])
  end
end
