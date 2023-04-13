require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'belongs to question' do
    answer = create(:answer)
    question = create(:question)
    answer.question = question
    expect(answer.question).to eq(question)
  end

  context 'answer' do
    it 'answer not valid' do
      answer = build(:answer, answer: nil)
      answer.validate
      expect(answer.errors).to include(:answer)
    end
    it 'answer valid' do
      answer = build(:answer)
      answer.validate
      expect(answer.errors).not_to include(:answer)
    end
  end
end
