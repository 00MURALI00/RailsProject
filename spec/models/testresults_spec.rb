require 'rails_helper'

RSpec.describe Testresult, type: :model do
  describe 'association' do
    context 'belongs to' do
      it 'test' do
        test = create(:test)
        testresult = create(:testresult, test: test)
        testresult.test = test
        expect(testresult.test).to eq(test)
      end
    end
  end
  describe 'score' do
    context 'presence' do
      it 'not valid' do
        testresult = build(:testresult, score: nil)
        testresult.validate
        expect(testresult.errors).to include(:score)
      end
    end
    context 'should not greater them 100 and less then 0' do
      it 'not valid' do
        testresult = build(:testresult, score: -1)
        testresult.validate
        expect(testresult.errors).to include(:score)
      end
      it 'not valid' do
        testresult = build(:testresult, score: 101)
        testresult.validate
        expect(testresult.errors).to include(:score)
      end
      it 'valid' do
        testresult = build(:testresult)
        testresult.validate
        expect(testresult.errors).not_to include(:testresult)
      end
    end
  end
end