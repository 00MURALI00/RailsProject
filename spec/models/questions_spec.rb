require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'association' do
    context 'belongs to' do
      it 'test' do
        question = create(:question)
        expect(question.test).to be_an_instance_of(Test)
      end
    end
    context 'has one' do
      it 'option' do
        question = create(:question)
        option = create(:option, question: question)
        expect(question.option).to eq(option)
      end
    end
    context 'has one' do
      it 'answer' do
        question = create(:question)
        answer = create(:answer, question: question)
        expect(question.answer).to eq(answer)
      end
    end
  end
  describe 'question' do
    context 'presence' do
      it 'not valid' do
        question = build(:question, question: nil)
        question.validate
        expect(question.errors).to include(:question)
      end

      it 'valid' do
        question = build(:question)
        question.validate
        expect(question.errors).not_to include(:question)
      end
    end
  end
end
