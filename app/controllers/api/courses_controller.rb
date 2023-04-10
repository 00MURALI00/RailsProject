class Api::CoursesController < Api::ApiController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!, except: %i[index]

  def index
    @courses = Course.all
    render json: @courses.to_json
  end

  def show
    @course = Course.find_by(id: params[:id])
    if !@course.nil?
      render json: @course, status: :ok
    else
      render json: '404 Not Found', status: :not_found
    end
  end

  def create
    @course = Course.new(name: params[:course][:name], description: params[:course][:description])
    if @course.save
      render json: @course, status: :created
    else
      render json: 'Something went wrong', status: :not_acceptable
    end
  end

  def destroy
    @course = Course.find_by(id: params[:id])
    if !@course.nil?
      if @course.destroy
        render json: @course, status: :ok
      else
        render json: 'Something went wrong', status: :unprocessable_entity
      end
    else
      render json: 'Something went wrong', status: :not_found
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find_by(id: params[:id])
    if !@course.nil?
      if @course.update(course_params)
        render json: @course, status: :accepted
      else
        render json: 'Something went wrong', status: :unprocessable_entity
      end
    else
      render json: 'Something went wrong', status: :not_found
    end
  end

  def course_params
    params.require(:course).permit(:name, :description)
  end
end
