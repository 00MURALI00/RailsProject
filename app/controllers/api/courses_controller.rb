# frozen_string_literal: true

class Api::CoursesController < Api::ApiController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!, except: %i[index]

  def index
    @courses = if user_signed_in? && current_user.role == 'teacher'
                 current_user.accountable.courses
               else
                 Course.all
               end
    render json: @courses.to_json, status: :ok
  end

  def show
    @course = Course.find_by(id: params[:id])
    # debugger
    if current_user.role == 'teacher' && current_user.accountable.courses.include?(@course)
      render json: @course, status: :ok
    elsif current_user.role == 'student'
      student = Student.find_by(id: current_user.accountable_id)
      if @course.students.include?(student)
        render json: @course, status: :ok
      else
        render json: '404 Not Found', status: 403  
      end
    else
      render json: '404 Not Found', status: :not_found
    end
  end

  def create
    @course = Course.new(name: params[:course][:name], description: params[:course][:description])
    if current_user.role == 'teacher' 
      @course.teacher_id = current_user.accountable_id
      # debugger
      if @course.save
        render json: @course, status: :created
      else
        render json: { error: @course.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Authorization restricted' }, status: 403
    end 
  end

  def destroy
    @course = Course.find_by(id: params[:id])
    if current_user.role == 'teacher' && current_user.accountable.courses.include?(@course)
      if !@course.nil?
        if @course.destroy
          render json: { message: 'Destroyed Successfully' }, status: :ok
        else
          render json: { error: @course.errors }, status: 422
        end
      else
        render json: { message: 'Something went wrong' }, status: :not_found
      end
    else
      render json: { error: 'Authorization restricted' }, status: 403
    end
  end

  def update
    @course = Course.find_by(id: params[:id])
    if current_user.role == 'teacher' && current_user.accountable.courses.include?(@course)
      if !@course.nil?
        if @course.update(course_params)
          render json: { message: 'Updated Successfully' }, status: :ok
        else
          render json: { error: @course.errors}, status: 422
        end
      else
        render json: { message: 'Something went wrong' }, status: :not_found
      end
    else
      render json: { error: 'Authorization restricted' }, status: 403
    end
  end

  def course_params
    params.require(:course).permit(:name, :description)
  end

  def enroll
    @course = Course.find(params[:id])
    if current_user.role == 'student' 
      @course.students << current_user.accountable
      render json: { message: 'Successfully enrolled in the Course' }, status: :ok
    else
      render json: { error: 'Authorization restricted' }, status: 403
    end
  end

  def drop
    @course = Course.find(params[:id])
    if current_user.role == 'student' && current_user.accountable.courses.include?(@course)
      @course.students.delete(current_user.accountable)
      render json: { message: 'Successfully dropped the Course' }, status: :ok
    else
      render json: { error: 'Authorization restricted' }, status: 403
    end
  end
end
