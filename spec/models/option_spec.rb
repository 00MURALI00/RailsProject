require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'association' do
    context 'belongs to' do
      it 'question' do
        option = create(:option)
        question = create(:question)
        option.question = question
        expect(option.question).to eq(question)
      end
    end
  end
  describe 'option' do
    context 'options' do
      it 'valid' do
        option = build(:option)
        option.validate
        expect(option.errors).not_to include(:option)
      end
    end
    context 'opt1' do
      it 'not valid' do
        option = build(:option, opt1: nil)
        option.validate
        expect(option.errors).to include(:opt1)
      end
      it 'valid' do
        option = build(:option, opt1: 'opt1')
        option.validate
        expect(option.errors).not_to include(:option)
      end
    end
    context 'opt2' do
      it 'not valid' do
        option = build(:option, opt2: nil)
        option.validate
        expect(option.errors).to include(:opt2)
      end
      it 'valid' do
        option = build(:option, opt2: 'opt2')
        option.validate
        expect(option.errors).not_to include(:option)
      end
    end
    context 'opt3' do
      it 'not valid' do
        option = build(:option, opt3: nil)
        option.validate
        expect(option.errors).to include(:opt3)
      end
      it 'valid' do
        option = build(:option, opt3: 'opt3')
        option.validate
        expect(option.errors).not_to include(:option)
      end
    end
    context 'opt4' do
      it 'not valid' do
        option = build(:option, opt4: nil)
        option.validate
        expect(option.errors).to include(:opt4)
      end
      it 'valid' do
        option = build(:option, opt4: 'opt4')
        option.validate
        expect(option.errors).not_to include(:option)
      end
    end
  end
end