require 'rails_helper'

RSpec.describe Test, type: :model do
  describe 'association' do
    context 'belongs to' do
      it 'course' do
        test = create(:test)
        course = create(:course)
        test.course = course
        expect(test.course).to eq(course)
      end
    end
    context 'has many' do
      it 'testresult' do
        test = create(:test)
        testresult = create(:testresult, test: test)
        expect(test.testresults).to include(testresult)
      end
      context 'has many' do
        it 'questions' do
          # question = create(:question)
          association = Test.reflect_on_association(:questions).macro
          expect(association).to be(:has_many)
        end
      end
    end
  end
  describe 'name' do
    context 'test name' do
      it 'not valid' do
        test = build(:test, name: nil)
        test.validate
        expect(test.errors).to include(:name)
      end
      it 'valid' do
        test = build(:test, name: 'Mike')
        test.validate
        expect(test.errors).not_to include(:name)
      end
    end
    context 'length should not greater than 50' do
      it 'not valid' do
        name = 'a' * 51
        test = build(:test, name: name)
        test.validate
        expect(test.errors).to include(:name)
      end
    end
  end
  describe 'scope' do
    context 'published' do
      it 'valid' do
        test = build(:test, published_at: nil)
        expect(Test.published).not_to include(test)
      end
    end
    context 'unpublished' do
      it 'valid' do
        test = create(:test, published_at: nil)
        expect(Test.unpublished).to include(test)
      end
    end
  end
end
