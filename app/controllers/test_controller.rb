class TestController < ApplicationController
  before_action :authenticate_user!
  def index
    # debugger
    @tests = if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
               Test.all.where(course_id: params[:course_id])
             elsif current_user.role == 'student' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
               Test.all.where(course_id: params[:course_id]).where.not(published_at: nil)
             else
               flash[:notice] = 'Unauthorized access'
               redirect_to courses_path
             end
    # p params[:test_id]
  end

  def show
    if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      @test = Test.find(params[:id])
    elsif current_user.role == 'student' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      @test = Test.find_by(id: params[:id])
      count = Testresult.where(test_id: @test.id, student_id: current_user.accountable.id).count
      p @test.attempts
      p count
      if @test.attempts > count
      render :taketest
      else
        flash[:notice] = 'You are left with no attempts'
        redirect_to course_test_index_path
      end
    else
      flash[:notice] = 'Unauthorized access'
      redirect_to courses_path
    end
  end

  def new
    if current_user.role == 'teacher'
      @test = Test.new
    else
      flash[:notice] = 'Unauthorized access'
      redirect_to courses_path
    end
    # p @test
  end

  def create
    @test = Test.new(test_params)
    # render plain: @test
    if @test.save
      # p @test
      redirect_to course_test_index_path
    else
      flash[:notice] = 'Failed to add Test'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @test = Test.find(params[:id])
  end

  def update
    @test = Test.find(params[:id])
    if @test.update(test_params)
      redirect_to course_test_index_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @test = Test.find(params[:id])
    if @test.destroy
      flash[:notice] = 'Successfully deleted'
      redirect_to course_test_index_path
    else
      flash[:notice] = 'Failed to delete'
      redirect_to edit_course_test_path
    end
  end

  def test_params
    params.require(:test).permit(:name, :course_id, :attempts)
  end
end
