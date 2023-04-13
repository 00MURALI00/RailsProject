require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'association' do
    context 'has many' do
      it 'course' do
        student = create(:student)
        course = create(:course)
        student.courses << course
        expect(course.students).to include(student)
      end
    end
    context 'has many' do
      it 'test' do
        student = create(:student)
        course = create(:course)
        test = create(:test, course: course)
        course.students << student
        expect(student.tests).to include(test)
      end
    end
    context 'has many' do
      it 'note' do
        student = create(:student)
        course = create(:course)
        note = create(:note, course: course)
        student.courses << course
        expect(student.notes).to include(note)
      end
    end
  end
  describe 'name' do
    context 'presence' do
      it 'not valid' do
        student = build(:student)
        student.name = ''
        student.validate
        expect(student.errors).to include(:name)
      end
    end
  end
  describe 'age' do
    context 'value less than 0' do
      it 'not valid' do
        student = build(:student)
        student.age = -1
        student.validate
        expect(student.errors).to include(:age)
      end
    end
    context 'value greater than 100' do
      it 'age not valid' do
        student = build(:student)
        student.age = 101
        student.validate
        expect(student.errors).to include(:age)
      end
    end
    context 'not number' do
      it 'age not valid' do
        student = build(:student)
        student.age = 'string'
        student.validate
        expect(student.errors).to include(:age)
      end
    end
    context 'presence' do
      it 'valid' do
        student = build(:student, age: 5)
        student.validate
        expect(student.errors).not_to include(:age)
      end
      it 'not valid' do
        student = build(:student, age: '')
        student.validate
        expect(student.errors).to include(:age)
      end
    end
  end
  describe 'gender' do
    context 'presence' do
      it 'not valid' do
        student = build(:student)
        student.gender = ''
        student.validate
        expect(student.errors).to include(:gender)
      end
      it 'valid' do
        student = build(:student, gender: 'Male')
        student.validate
        expect(student.errors).not_to include(:gender)
      end
    end
  end
end
