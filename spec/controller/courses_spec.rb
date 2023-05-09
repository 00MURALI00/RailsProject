require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  # render_views
  # describe do
  let!(:teacher_user) { create(:user, :for_teachers) }
  let!(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:student_user) { create(:user) }
  describe 'GET index' do
    context 'when teacher or student login or no one logged in' do
      it 'render index' do
        get :index
        expect(response).to render_template :index
      end
    end
  end
  describe 'GET show' do
    context 'when teacher tries to access a exsisting course' do
      it 'render show' do
        sign_in teacher_user
        get :show, params: { id: course.id }
        expect(response).to render_template :show
      end
    end
    context 'when teacher tries to access a non exsisting course' do
      it 'redirect to courses' do
        sign_in teacher_user
        get :show, params: { id: course.id + 100 }
        expect(response).to redirect_to(courses_path)
      end
    end
    context 'when student tries to access a course not enrolled' do
      it 'redirect to courses path' do
        sign_in student_user
        get :show, params: { id: 1 }
        expect(response).to redirect_to(courses_path)
      end
    end
    context 'when student tries to access a course enrolled' do
      it 'render show' do
        sign_in student_user
        student_user.accountable.courses << course
        get :show, params: { id: course.id }
        expect(response).to render_template :show
      end
    end
  end
  describe 'POST create' do
    context 'when teacher tries to create a course' do
      it 'redirect to courses path' do
        sign_in teacher_user
        post :create,
             params: { course: { name: 'MyString', description: 'This is a valid description' } }
        expect(response).to redirect_to(courses_path)
      end
    end
    context 'when teacher tries tocreate a course with invalid params' do
      it 'render new' do
        sign_in teacher_user
        post :create, params: { course: { name: 'MyString', description: '' } }
        expect(response).to render_template :new
      end
    end
    # context 'when student tries to create a course' do
    #   it 'redirect to course path' do
    #     sign_in student_user
    #     post :create,
    #          params: { course: { name: 'MyString', description: 'This is a valid description' }, course_id: course.id }
    #     expect(response).to redirect_to(course_path)
    #   end
    # end
  end
  describe 'PATCH update' do
    context 'when teachers tries to update a course with valid params' do
      it 'redirected to courses path' do
        sign_in teacher_user
        put :update, params: { course: { name: 'MyString', description: 'This is a valid description' }, id: course.id  }
        expect(response).to redirect_to(courses_path)
      end
    end
    context 'when teacher tries to update a course with invalid params' do
      it 'throws 422 status code' do
        sign_in teacher_user
        put :update, params: { course: { name: 'MyString', description: '' }, id: course.id }
        expect(response).to render_template :edit
      end
    end
  end
  describe 'DELETE destroy' do
    context 'when teacher tries to delete a course' do
      it 'redirect to courses path' do
        sign_in teacher_user
        get :destroy, params: { id: course.id }
        expect(response).to redirect_to(courses_path)
      end
    end
    context 'when student tries to delete a course' do
      it 'redirect to courses path' do
        sign_in student_user
        get :destroy, params: { id: course.id }
        expect(response).to redirect_to(courses_path)
      end
    end
  end
  describe 'enroll and drop' do
    context 'when student tries to enroll in a course' do
      it 'redirect to courses path' do
        sign_in student_user
        get :enroll, params: { id: course.id }
        expect(flash[:notice]).to match(/Successfully enrolled in the Cours/)
      end
    end
    context 'when teacher tries to enroll a course' do
      it 'redirect to courses path' do
        sign_in teacher_user
        get :enroll, params: { id: course.id }
        expect(flash[:notice]).to match(/You are not authorized to view this page/)
      end
    end
    context 'when student tries to drop a course' do
      it 'redirect to courses path' do
        sign_in student_user
        course.students << student_user.accountable
        get :drop, params: { id: course.id }
        expect(flash[:notice]).to match(/Successfully dropped the Course/)
      end
    end
    context 'when teacher tries to drop a course' do
      it 'redirect to courses path' do
        sign_in teacher_user
        get :drop, params: { id: course.id }
        expect(flash[:notice]).to match(/You are not authorized to view this page/)
      end
    end
    context 'when student tries to drop a course that not been enrolled' do
      it 'redirect to courses path' do
        sign_in student_user
        get :drop, params: { id: course.id.to_i + 10 }
        expect(flash[:notice]).to match(/You are not authorized to view this page/)
      end
    end
  end
end
