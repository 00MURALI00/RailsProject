# frozen_string_literal: true

class Api::TestresultController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @testresult = Testresult.all
    render json: @testresult
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
