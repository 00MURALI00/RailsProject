class Api::CoursesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @courses = Course.all
    render json: @courses.to_json
  end

  def show
    @course = Course.find_by(id: params[:id])
    if !@course.nil?
      render json: @note
    else
      render json: 'Record Not Found'
    end
  end

  def create
    @course = Course.new(name: params[:course][:name], description: params[:course][:description])
    if @course.save
      render json: @course
    else
      render json: 'Something went wrong'
    end
  end

  def destroy
    @course = Course.find_by(id: params[:id])
    if !@course.nil?
      if @course.destroy
        render json: @course
      else
        render json: 'Something went wrong'
      end
    else
      render json: 'Something went wrong'
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find_by(id: params[:id])
    if !@course.nil?
      if @course.update(course_params)
        render json: @course
      else
        render json: 'Something went wrong'
      end
    else
      render json: 'Something went wrong'
    end
  end

  def course_params
    params.require(:course).permit(:name, :description)
  end
end
