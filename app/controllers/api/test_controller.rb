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
    if current_user.accountable.courses.tests.include?(@tests)
      render json: @tests, status: :ok
    else
      render json: { message: 'Autheraization Restricted' }, status: :unauthorized
    end
  end

  def show
    if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      @test = Test.find(params[:id])
    elsif current_user.role == 'student' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      @test = Test.find_by(id: params[:id])
      render json: @test, include: %i[questions options], status: :ok
    else
      render json: { message: 'Autheraization Restricted' }, status: :unauthorized
    end
    if !@test.nil?
      render json: @test, status: :ok
    else
      render json: { message: 'Not Found' }, status: :not_found
    end
  end

  def create
    if current_user.role == 'teacher'
      @test = Test.new(test_params)
      if @test.save
        render json: @test, status: :created
      else
        render json: { message: @test.errors.full_message }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Autheraization Restricted' }, status: :unauthorized
    end
  end

  def edit
    @test = Test.find(params[:id])
  end

  def update
    @test = Test.find_by(id: params[:id])
    if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      if !@test.nil?
        if @test.update(test_params)
          render json: { message: 'Updated Successfully' }, status: :ok
        else
          render json: { message: 'Something went wrong' }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Not Found' }, status: :not_found
      end
    else
      render json: { message: 'Autheraization Restricted' }, status: :unauthorized
    end
  end

  def destroy
    @test = Test.find_by(id: params[:id])
    if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      if !@test.nil?
        if @test.destroy
          render json: { message: 'Destroy Successfully' }, status: :ok
        else
          render json: { message: 'Something went wrong' }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Not Found' }, status: :not_found
      end
    else
      render json: { message: 'Autheraization Restricted' }, status: :unauthorized
    end
  end

  def test_params
    params.require(:test).permit(:name, :course_id)
  end
end
