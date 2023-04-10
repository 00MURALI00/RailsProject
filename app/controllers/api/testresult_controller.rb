# frozen_string_literal: true

class Api::TestresultController < Api::ApiController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!

  def index
    @testresult = if current_user.role == ('student')
                    Testresult.where(student_id: current_user.accountable_id)
                  else
                    Testresult.all
                  end
  end

  def create
    score = getScore(params[:test])
    @testresult = Testresult.new(test_id: params[:test_id], score: score, student_id: params[:student_id])
    if @testresult.save
      render json: @testresult
    else
      render json: 'Something went wrong'
    end
  end

  def show; end

  def getScore(hash)
    score = 0
    hash.each do |key, value|
      question = key[9, key.length]
      answer = Answer.select(:answer).find_by(question_id: question)
      score += 1 if answer[:answer].eql?(value[:opt])
    end
    score
  end
end
