require 'rails_helper'

RSpec.describe TestController, type: :controller do
  let(:teacher_user) { create(:user, :for_teachers) }
  let(:student_user) { create(:user, :for_students) }
  let(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:test) { create(:test, course: course) }
  let(:question) { create(:question, test: test) }
  let(:option) { create(:option, question: question) }
  describe 'GET index' do
    context 'when teacher tries to see all tests that he has access' do
      it 'throws 200 status code' do
        sign_in teacher_user
        get :index, params: {course_id: course.id}
        expect(response).to render_template :index
      end
    end
    context 'when teacher tries to see all tests that he dont have access' do
      it 'throws 401 status code' do
        sign_in teacher_user
        get :index, params: {course_id: course.id + 100}
        expect(flash[:notice]).to eq('Unauthorized access')
      end
    end
    context 'when student tries to see all tests that he has access' do
      it 'throws 200 status code' do
        sign_in student_user
        course.students << student_user.accountable
        get :index, params: {course_id: course.id}
        expect(response).to render_template :index
      end
    end
    context 'when student tries to see all tests that he dont have access' do
      it 'throws 401 status code' do
        sign_in student_user
        get :index, params: {course_id: course.id}
        expect(flash[:notice]).to eq('Unauthorized access')
      end
    end
  end
  describe 'GET show' do
    context 'when teacher tries to see a test' do
      it 'throws 200 status code' do
        sign_in teacher_user
        get :show, params: {course_id: course.id, id: test.id}
        expect(response).to render_template :show
      end
    end
    context 'when teacher tries to see a test that he dont have access' do
      it 'throws 401 status code' do
        sign_in teacher_user
        get :show, params: {course_id: course.id + 100, id: test.id}
        expect(response).to redirect_to(courses_path)
      end
    end
    context 'when the student to see a test that he access' do
      it 'throws 200 status code' do
        sign_in student_user
        course.students << student_user.accountable
        get :show, params: {course_id: course.id, id: test.id}
        expect(response).to render_template :taketest
      end
    end
    context 'when the student tries to see a test that he dont have access' do
      it 'throws 401 status code' do
        sign_in student_user
        get :show, params: {course_id: course.id, id: test.id}
        expect(response).to redirect_to(courses_path)
      end
    end
  end

  describe 'POST create' do
    context 'when teacher tries to create test' do
      it 'throws 200 status code' do
        sign_in teacher_user
        get :create,
             params: { test: { name: 'testing', course_id: course.id }, course_id: course.id, id: test.id }
        expect(response).to redirect_to(course_test_index_path)
      end
    end
  end
  describe 'DELETE destroy' do
    context 'when teacher tries to delete test' do
      it 'throws 200 status code' do
        sign_in teacher_user
        get :destroy, params: {course_id: course.id, id: test.id}
        expect(response).to redirect_to(course_test_index_path)
      end
    end
  end
  
  describe 'GET new' do
    context 'when teacher tries to create a new test' do
      it 'throws 200 status code' do
        sign_in teacher_user
        get :new, params: {course_id: course.id}
        expect(response).to render_template :new
      end
    end
    context 'student tries to create a new test' do
      it 'throws 401 status code' do
        sign_in student_user
        get :new, params: {course_id: course.id}
        expect(response).to redirect_to(courses_path)
      end
    end
  end

  describe 'GET edit' do
    context 'when course is created by teacher' do
      it 'throws 200 status code' do
        sign_in teacher_user
        get :edit, params: {course_id: course.id, id: test.id}
        expect(response).to render_template :edit
      end
    end
  end
end
