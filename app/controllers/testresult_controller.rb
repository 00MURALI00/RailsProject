# frozen_string_literal: true

class TestresultController < ApplicationController
  def index
    @testresult = if current_user.role == 'student'
                    Testresult.where(student_id: current_user.accountable_id).group(:test_id)
                  else
                    Testresult.all.group(:test_id)
                  end
  end

  def create
    score = getScore(params[:test])
    @testresult = Testresult.new(test_id: params[:test_id], score: score, student_id: current_user.accountable_id)
    if @testresult.save
      flash[:notice] = 'Successfull'
      redirect_to course_path(params[:course_id])
    else
      flash[:notice] = 'failed'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @testresult = Testresult.find_by(id: params[:testresult_id])
    if @testresult.destroy && !@testresult.nil? && current_user.role == 'teacher'
      flash[:notice] = 'Successfully Destroyed Test result'
      redirect_to testresult_index_path
    else
      flash[:notice] = 'Failed to destroy Test result'
      redirect_to testresult_index_path
    end
  end

  def getScore(hash)
    score = 0
    unless hash.nil?
      hash.each do |key, value|
        question = key[9, key.length]
        answer = Answer.select(:answer).find_by(question_id: question)
        # p "#{answer[:answer]} #{value[:opt]}"
        score += 1 if answer[:answer].eql?(value[:opt])
        # p answer
      end
      # p score
    end
    score
  end
end
