class CoursesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  def index
    @q = Course.ransack(params[:q])
    @courses = if !@q.result(distinct: true).nil?
                 @q.result(distinct: true)
               elsif user_signed_in? && current_user.role == 'teacher'
                 current_user.accountable.courses
               else
                 Course.all
               end
  end

  def show
    # debugger
    if current_user.accountable.course_ids.include?(params[:id].to_i)
      @course = Course.find(params[:id])
      render :show
    else
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to courses_path
    end
  end

  def new
    if current_user.role == 'teacher'
      @course = Course.new
    else
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to courses_path
    end
  end

  def create
    if current_user.role == 'teacher'
      @course = Course.new(course_params)
      @course.teacher_id = current_user.accountable_id
      if @course.image.nil?
        @course.image = image_tag "Dummy_flag.png"
      end
      if @course.save
        flash[:notice] = 'Successfully created the Course'
        redirect_to courses_path
      else
        flash[:notice] = 'Failed to create Course'
        render :new, status: :unprocessable_entity
      end
    else
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to course_path
    end
  end

  def destroy
    if current_user.role == 'teacher'
      @course = Course.find(params[:id])
      if @course.destroy
        flash[:notice] = 'Course was successfully destroyed.'
        redirect_to courses_path
      else
        flash[:notice] = 'Failed to destroy Course'
        redirect_to courses_path
      end
    else
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to courses_path
    end
  end

  def edit
    @course = Course.find_by(id: params[:id])
    return if current_user.role == 'teacher' && current_user.accountable.courses.include?(@course)

    flash[:notice] = 'You are not authorized to view this page'
    redirect_to courses_path
  end

  def update
    @course = Course.find(params[:id])
    if current_user.role == 'teacher' && current_user.accountable.courses.include?(@course)
      if @course.update(course_params)
        # p @course
        flash[:notice] = 'Sucessfully edited the Course'
        redirect_to courses_path
      else
        flash[:notice] = 'Failed to edit the Course'
        render :edit, status: :unprocessable_entity
      end
    else
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to course_path
    end
  end

  def enroll
    @course = Course.find(params[:id])
    if current_user.role == 'student'
      @course.students << current_user.accountable
      flash[:notice] = 'Successfully enrolled in the Course'
      redirect_to courses_path
    else
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to courses_path
    end
  end

  def drop
    @course = Course.find_by(id: params[:id])
    if current_user.role == 'student'
      if current_user.accountable.courses.include?(@course)
        @course.students.delete(current_user.accountable)
        flash[:notice] = 'Successfully dropped the Course'
        redirect_to courses_path
      else
        flash[:notice] = 'You are not authorized to view this page'
        redirect_to courses_path
      end
    else
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to courses_path
    end
  end

  def course_params
    params.require(:course).permit(:name, :description, :image)
  end
end
