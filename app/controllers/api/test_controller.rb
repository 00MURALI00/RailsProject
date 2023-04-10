class Api::TestController < Api::ApiController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!
  def index
    # @tests = Test.all
    @tests = if current_user.role == 'teacher'
               Test.all.where(course_id: params[:course_id])
             else
               Test.all.where(course_id: params[:course_id]).where.not(published_at: nil)
             end
    p params[:test_id]
    render json: @tests
  end

  def show
    # @test = Test.find_by(id: params[:id])
    # p @test
    if current_user.role == 'teacher'
      @test = Test.find(params[:id])
    else
      @test = Test.find_by(id: params[:id])
    render :taketest
    end
    if !@test.nil?
      render json: @test
    else
      render json: 'Record Not Found'
    end
  end

  def new
    @test = Test.new
  end

  def create
    @test = Test.new(test_params)
    if @test.save
      render json: @test
    else
      render json: @test.errors
    end
  end

  def edit
    @test = Test.find(params[:id])
  end

  def update
    @test = Test.find_by(id: params[:id])
    if !@test.nil?
      if @test.update(test_params)
        render json: @test
      else
        render json: 'Something went wrong'
      end
    else
      render json: 'Something went wrong'
    end
  end

  def destroy
    @test = Test.find_by(id: params[:id])
    if !@test.nil?
      if @test.destroy
        render json: @test
      else
        render json: 'Something went wrong'
      end
    else
      render json: 'Something went wrong'
    end
  end

  def test_params
    params.require(:test).permit(:name, :course_id)
  end
end
