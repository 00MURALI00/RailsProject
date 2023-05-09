class Api::QuestionController < Api::ApiController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!
  def index
    @questions = Question.includes(:option).all.where(test_id: params[:test_id])
    if current_user.accountable.course_ids.include?(params[:course_id].to_i)
      render json: @questions, include: [:option], status: :ok
    else
      render json: { message: 'Autheraization Restricted' }, status: 403
    end
  end

  def show
    @question = Question.includes(:option).find_by(id: params[:id])
    if !@question.nil?
      # debugger
      if current_user.accountable.course_ids.include?(params[:course_id].to_i)
        render json: @question, include: [:option], status: :ok
      else
        render json: { message: 'Autheraization Restricted' }, status: 403
      end
    else
      render json: { message: 'Not Found' }, status: :not_found
    end
  end

  def create
    if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      @question = Question.new(question_params)
      @question.test_id = params[:test_id]
      if @question.save
        render json: @question, status: :created
      else
        render json: { error: @question.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to perform this action' }, status: 403
    end
  end

  def update
    @question = Question.includes(:option).find_by(params[:id])
    if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      if !@question.nil?
        if @question.update(question_params)
          render json: { message: 'Updated Successfully' }, include: [:option], status: :accepted
        else
          render json: { error: @question.errors.full_message }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Not Found' }, status: :not_found
      end
    else
      render json: { error: 'You are not authorized to perform this action' }, status: 403
    end
  end

  def destroy
    @question = Question.includes(:option).find_by(id: params[:id])
    if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      if !@question.nil?
        if @question.destroy
          render json: { message: 'Destroyed Successfully' }, include: [:option], status: :ok
        else
          render json: { error: @question.errors }, status: :unprocessable_entity
        end else
              render json: { message: 'Not Found' }, status: :not_found
      end
    else
      render json: { error: @question.errors }, status: 403
    end
  end

  def question_params
    params.require(:question).permit(:question, option_attributes: %i[opt1 opt2 opt3 opt4],
                                                answer_attributes: [:answer])
  end
end
