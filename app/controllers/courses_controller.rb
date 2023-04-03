class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(name: params[:course][:name], description: params[:course][:description])
    p @course
    if @course.save
      flash[:notice] = 'Successfully created the Course'
      redirect_to courses_path
    else
      flash[:notice] = 'Failed to create Course'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      # p @course
      flash[:notice] = 'Sucessfully edited the Course'
      redirect_to courses_path
    else
      flash[:notice] = 'Failed to edit the Course'
      render :edit, status: :unprocessable_entity
    end
  end

  def course_params
    params.require(:course).permit(:name, :description)
  end
end
