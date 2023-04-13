require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'description' do
    context 'length' do
      it 'not valid' do
        course = build(:course, description: 'MyString')
        course.validate
        expect(course.errors).to include(:description)
      end

      it ' valid' do
        course = build(:course)
        course.validate
        expect(course.errors).not_to include(:description)
      end
    end
  end

  describe 'association' do
    context 'has_many' do
      %i[tests notes].each do |model|
        it model.to_s.humanize do
          # obj = create(model)
          association = Course.reflect_on_association(model).macro
          expect(association).to be(:has_many)
        end
      end
    end

    context 'has and belongs to many students' do
      it 'student' do
        association = Course.reflect_on_association(:students).macro
        expect(association).to be(:has_and_belongs_to_many)
      end
    end

    context 'belongs to teacher' do
      it 'teacher' do
        teacher = create(:teacher)
        course = create(:course, teacher: teacher)
        # course.teacher = teacher
        expect(course.teacher).to eq(teacher)
      end
    end
  end
end
