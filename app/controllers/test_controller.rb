class TestController < ApplicationController
  def index
    @tests = Test.all.where(course_id: params[:course_id])
    p params[:test_id]
  end

  def show
    if current_user.role == 'teacher'
      @test = Test.find(params[:id])
    else
      @testw = Test.find_by(id: params[:id])
      render :taketest
    end
  end

  def new
    @test = Test.new
    # p @test
  end

  def create
    @test = Test.new(test_params)
    # render plain: @test
    if @test.save
      p @test
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
      redirect_to course_test_index_path
    else
      redirect_to edit_course_test_path
    end
  end

  def test_params
    params.require(:test).permit(:name, :course_id)
  end
end
