class TestresultController < ApplicationController
  def index

  end
  
  def create
    score = getScore(params[:tests])
    # p score
    @testresult = Testresult.new(test_id: params[:test_id], score: score)
    if @testresult.save
      flash[:notice] = 'Successfull'
      redirect_to course_path(params[:course_id])
    else
      flash[:notice] = 'failed'
      redirect_to test_testtake_path
    end
  end

  def show
  end

  def getScore (hash)

    score = 0
    hash.each do |key, value|
      question = key[9,key.length]
      answer = Answer.select(:answer).find_by(question_id: question)
      # p "#{answer[:answer]} #{value[:opt]}"
      if answer[:answer].eql?(value[:opt])
        score = score + 1
      end
      # p answer
    end
    # p score
    score
  end
end
