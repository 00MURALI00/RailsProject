require 'rails_helper'

RSpec.describe Api::CoursesController, type: :request do
# render_views
# describe do
  let!(:teacher_user) { create(:user, :for_teachers) }
  let(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:student_user) { create(:user) }
  let!(:teacher_token) { create(:doorkeeper_access_token, resource_owner_id: teacher_user.id) }
  let(:student_token) { create(:doorkeeper_access_token, resource_owner_id: student_user.id) }
  describe 'GET index' do
    context 'when teacher or student login or no one logged in' do
      it 'throws 200 status code' do
        get '/api/courses'
        # p response
        # debugger
        expect(response).to have_http_status(200)
      end
    end
  end
  describe 'GET show' do
    context 'when teacher tries to access a non exsisting course' do
      it 'throws 404 status code' do
        get "/api/courses/#{course.id + 100}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(404)
      end
    end
    context 'when teacher tries to access a exsisting course' do
      it 'throws 200 status code' do
        get api_course_path(access_token: teacher_token.token, id: course.id)
        expect(response).to have_http_status(200)
      end
    end
    context 'when student tries to access a course not enrolled' do
      it 'throws 401 status code' do
        get api_course_path(access_token: student_token.token, id: course.id)
        expect(response).to have_http_status(401)
      end
    end
    context 'when student tries to access a course enrolled' do
      it 'throws 200 status code' do
        student_user.accountable.courses << course
        get api_course_path(access_token: student_token.token, id: course.id)
        expect(response).to have_http_status(200)
      end
    end
    context 'when no one logged in' do
      it 'throws 401 status code' do
        get api_course_path(id: course.id)
        expect(response).to have_http_status(401)
      end
    end
  end
  describe 'POST create' do
    context 'when teacher tries to create a course' do
      it 'throws 201 status code' do
        post api_courses_path(access_token: teacher_token.token),
             params: { course: { name: 'MyString', description: 'This is a valid description' } }
        expect(response).to have_http_status(201)
      end
    end
    context 'when teacher tries tocreate a course with invalid params' do
      it 'throws 422 status code' do
        post api_courses_path(access_token: teacher_token.token),
             params: { course: { name: 'MyString', description: '' } }
        expect(response).to have_http_status(422)
      end
    end
    context 'when student tries to create a course' do
      it 'throws 401 status code' do
        post api_courses_path(access_token: student_token.token),
             params: { course: { name: 'MyString', description: 'This is a valid description' } }
        expect(response).to have_http_status(401)
      end
    end
  end
  describe 'PATCH update' do
    context 'when teachers tries to update a course with valid params' do
      it 'throws 200 status code' do
        patch api_course_path(access_token: teacher_token.token, id: course.id),
              params: { course: { name: 'MyString', description: 'This is a valid description' } }
        expect(response).to have_http_status(200)
      end
    end
    context 'when teacher tries to update a course with invalid params' do
      it 'throws 422 status code' do
        patch api_course_path(access_token: teacher_token.token, id: course.id),
              params: { course: { name: 'MyString', description: '' } }
        expect(response).to have_http_status(422)
      end
    end
    context 'when student tries to update a course' do
      it 'throws 401 status code' do
        patch api_course_path(access_token: student_token.token, id: course.id),
              params: { course: { name: 'MyString', description: 'This is a valid description' } }
        expect(response).to have_http_status(401)
      end
    end
  end
  describe 'DELETE destroy' do
    context 'when teacher tries to delete a course' do
      it 'throws 204 status code' do
        delete api_course_path(access_token: teacher_token.token, id: course.id)
        expect(response).to have_http_status(200)
      end
    end
    context 'when student tries to delete a course' do
      it 'throws 401 status code' do
        delete api_course_path(access_token: student_token.token, id: course.id)
        expect(response).to have_http_status(401)
      end
    end
  end
end
