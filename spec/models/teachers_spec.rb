require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe 'association' do
    context 'has many' do
      it 'course' do
        teacher = create(:teacher)
        course = create(:course, teacher: teacher)
        expect(teacher.courses).to include(course)
      end
    end
  end
  describe 'name' do
    context 'presence' do
      it 'not valid' do
        teacher = build(:teacher, name: nil)
        teacher.validate
        expect(teacher.errors).to include(:name)
      end
      it 'valid' do
        teacher = build(:teacher, name: 'Mike')
        teacher.validate
        expect(teacher.errors).not_to include(:name)
      end
    end
  end
  describe 'gender' do
    context 'presence'
    it 'not valid' do
      teacher = build(:teacher, gender: nil)
      teacher.validate
      expect(teacher.errors).to include(:gender)
    end
    it 'valid' do
      teacher = build(:teacher, gender: 'Male')
      teacher.validate
      expect(teacher.errors).not_to include(:gender)
    end
  end
end
describe 'age' do
  context 'presence' do
    it 'not valid' do
      teacher = build(:teacher, age: nil)
      teacher.validate
      expect(teacher.errors).to include(:age)
    end
    it 'valid' do
      teacher = build(:teacher, age: 55)
      teacher.validate
      expect(teacher.errors).not_to include(:age)
    end
    context 'not string' do
      it 'not valid' do
        teacher = build(:teacher, age: 'abc')
        teacher.validate
        expect(teacher.errors).to include(:age)
      end
    end
    context 'should not less than 0 and greater than 100'
    it 'not valid' do
      teacher = build(:teacher, age: 0)
      teacher.validate
      expect(teacher.errors).to include(:age)
    end
    it 'not valid' do
      teacher = build(:teacher, age: 100)
      teacher.validate
      expect(teacher.errors).to include(:age)
    end
  end
  it 'valid params' do
    teacher = build(:teacher, age: 55)
    expect(teacher).to be_valid
  end
end